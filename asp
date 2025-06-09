{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "bwlive": "Server=10.4.64.15;Database=bwlive;User ID=birlawhite;Password=M@nsv1530;Trusted_Connection=False;TrustServerCertificate=true;",
    "itkHaria": "Server=10.4.64.15;Database=ItKharia;User ID=itKharia;Password=Mans^1530;Trusted_Connection=False;TrustServerCertificate=true;",
    "imageData": "Server=10.4.64.15;Database=imageData;User ID=sa;Password=Point@0652;Trusted_Connection=False;TrustServerCertificate=true;"
  }
}



using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using sparshWebService.DataAccess;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add Controllers
builder.Services.AddControllers();
builder.Services.AddSwaggerGen();

// Retrieve Connection Strings
var connectionStrings = builder.Configuration.GetSection("ConnectionStrings").Get<Dictionary<string, string>>();

// Register DatabaseHelper as a Singleton
builder.Services.AddSingleton(provider =>
 new DatabaseHelper(
 connectionStrings["bwlive"],
 connectionStrings["itkHaria"],
 connectionStrings["imageData"]));

// Add HttpClient for DI
builder.Services.AddHttpClient();

// ✅ Register IHttpContextAccessor to fix DI error
builder.Services.AddHttpContextAccessor();

// Add Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
 .AddJwtBearer(options =>
 {
     options.TokenValidationParameters = new TokenValidationParameters
     {
         ValidateIssuer = true,
         ValidateAudience = false,
         ValidateLifetime = true,
         ValidateIssuerSigningKey = true,
         ValidIssuer = "Birla White IT", // Set your valid issuer
         IssuerSigningKeyResolver = (token, securityToken, kid, parameters) =>
         {
             var jwtToken = new JwtSecurityTokenHandler().ReadJwtToken(token);
             var partnerId = jwtToken.Claims.FirstOrDefault(c => c.Type == "PartnerID")?.Value;
             if (partnerId != null)
             {
                 var dbHelper = builder.Services.BuildServiceProvider().GetRequiredService<DatabaseHelper>();
                 var secretKey = dbHelper.GetSecretKey(partnerId); // Retrieve SecretKey from DB
                 if (!string.IsNullOrEmpty(secretKey))
                 {
                     return new[] { new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey)) };
                 }
             }
             throw new SecurityTokenInvalidSigningKeyException("Invalid PartnerID or SecretKey.");
         }
     };

     options.Events = new JwtBearerEvents
     {
         OnMessageReceived = context =>
         {
             var authHeader = context.Request.Headers["Authorization"].ToString();
             if (!string.IsNullOrEmpty(authHeader) && authHeader.StartsWith("Bearer "))
             {
                 context.Token = authHeader.Replace("Bearer ", "");
             }
             return Task.CompletedTask;
         }
     };
 });

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Custom Middleware for PartnerID and API access validation
app.UseMiddleware<AuthenticationMiddleware>();

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

// Add a default home page for the API
app.MapGet("/", async context =>
{
    context.Response.ContentType = "text/html";
    await context.Response.WriteAsync("<h1>Welcome to My API</h1><p>This is the default home page.</p>");
});

app.MapControllers();
app.Run();


using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using sparshWebService.DataAccess;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Threading.Tasks;

public class AuthenticationMiddleware
{
    private readonly RequestDelegate _next;
    private readonly DatabaseHelper _dbHelper;

    public AuthenticationMiddleware(RequestDelegate next, DatabaseHelper dbHelper)
    {
        _next = next;
        _dbHelper = dbHelper;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // Bypass authentication for TokenController
        var currentPath = context.Request.Path.Value?.ToLower();
        if (currentPath?.StartsWith("/api/token", StringComparison.OrdinalIgnoreCase) == true ||
            currentPath?.StartsWith("/api/Dsr", StringComparison.OrdinalIgnoreCase) == true)
        {
            // Skip authentication for TokenController
            await _next(context);
            return;
        }

        // Extract PartnerID and Authorization header
        var partnerId = context.Request.Headers["PartnerID"].FirstOrDefault();
        var authorizationHeader = context.Request.Headers["Authorization"].FirstOrDefault();

        if (string.IsNullOrEmpty(partnerId) || string.IsNullOrEmpty(authorizationHeader) || !authorizationHeader.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
        {
            context.Response.StatusCode = 400; // Bad Request
            await context.Response.WriteAsync("PartnerID header and Authorization Bearer token are required.");
            return;
        }

        // Extract JWT token
        var jwtToken = authorizationHeader.Replace("Bearer ", "", StringComparison.OrdinalIgnoreCase).Trim();
        try
        {
            var jwtHandler = new JwtSecurityTokenHandler();
            if (!jwtHandler.CanReadToken(jwtToken))
            {
                context.Response.StatusCode = 401; // Unauthorized
                await context.Response.WriteAsync("Invalid JWT token.");
                return;
            }

            // Validate the JWT token
            var token = jwtHandler.ReadJwtToken(jwtToken);
            var tokenPartnerId = token.Claims.FirstOrDefault(c => c.Type == "PartnerID")?.Value;

            if (string.IsNullOrEmpty(tokenPartnerId) || !string.Equals(tokenPartnerId, partnerId, StringComparison.OrdinalIgnoreCase))
            {
                context.Response.StatusCode = 401; // Unauthorized
                await context.Response.WriteAsync("Invalid or mismatched PartnerID in token.");
                return;
            }

            // Validate API access
            var allowedApis = _dbHelper.GetAllowedAPIs(partnerId);
            if (!allowedApis.Contains(currentPath))
            {
                context.Response.StatusCode = 403; // Forbidden
                await context.Response.WriteAsync("Access to the API is not allowed for this PartnerID.");
                return;
            }

            // Call the next middleware
            await _next(context);
        }
        catch (Exception ex)
        {
            context.Response.StatusCode = 401; // Unauthorized
            await context.Response.WriteAsync($"Token validation failed: {ex.Message}");
        }
    }
}



using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace sparshWebService.DataAccess
{
    public class DatabaseHelper
    {
        private readonly string _bwliveConnectionString;
        private readonly string _itKhariaConnectionString;
        private readonly string _imageDataConnectionString;

        public DatabaseHelper(string bwliveConnectionString, string itKhariaConnectionString, string imageDataConnectionString)
        {
            _bwliveConnectionString = bwliveConnectionString;
            _itKhariaConnectionString = itKhariaConnectionString;
            _imageDataConnectionString = imageDataConnectionString;
        }

        // General method to execute SELECT queries for any connection string
        private List<Dictionary<string, object>> ExecuteSelectQuery(string connectionString, string query, Dictionary<string, object> parameters)
        {
            var resultList = new List<Dictionary<string, object>>();

            using (var conn = new SqlConnection(connectionString))
            using (var cmd = new SqlCommand(query, conn))
            {
                foreach (var param in parameters)
                {
                    cmd.Parameters.AddWithValue(param.Key, param.Value);
                }

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var row = new Dictionary<string, object>();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            row[reader.GetName(i)] = reader[i];
                        }
                        resultList.Add(row);
                    }
                }
            }

            return resultList;
        }

        // General method to execute INSERT, UPDATE, or DELETE queries for any connection string
        private int ExecuteCommand(string connectionString, string query, Dictionary<string, object> parameters)
        {
            using (var conn = new SqlConnection(connectionString))
            using (var cmd = new SqlCommand(query, conn))
            {
                foreach (var param in parameters)
                {
                    cmd.Parameters.AddWithValue(param.Key, param.Value);
                }

                conn.Open();
                return cmd.ExecuteNonQuery(); // Returns the number of rows affected
            }
        }

        // Function to handle queries for bwlive database (WebSessBean)
        public List<Dictionary<string, object>> WebSessBean(string query, Dictionary<string, object> parameters)
        {
            return ExecuteSelectQuery(_bwliveConnectionString, query, parameters);
        }

        // Function to handle queries for itKharia database (KkrSessBean)
        public List<Dictionary<string, object>> KkrSessBean(string query, Dictionary<string, object> parameters)
        {
            return ExecuteSelectQuery(_itKhariaConnectionString, query, parameters);
        }

        // Function to handle queries for imageData database (ImgSessBean)
        public List<Dictionary<string, object>> ImgSessBean(string query, Dictionary<string, object> parameters)
        {
            return ExecuteSelectQuery(_imageDataConnectionString, query, parameters);
        }

        // Retrieve SecretKey for a given PartnerID from the RegisteredUsers table (itKharia)
        public string GetSecretKey(string partnerId)
        {
            var query = "SELECT secrtKey FROM prmApiPrtnr WHERE partnrId = @PartnerID";
            var parameters = new Dictionary<string, object>
            {
                { "@PartnerID", partnerId }
            };

            var result = KkrSessBean(query, parameters);
            if (result.Count > 0)
            {
                return result[0]["secrtKey"]?.ToString();
            }

            throw new Exception("SecretKey not found for the given PartnerID.");
        }
        public List<string> GetAllowedAPIs(string partnerId)
        {
            var query = @"SELECT allwdAPI 
                  FROM prmApiPrtnr 
                  WHERE partnrId = @PartnerID";
            var parameters = new Dictionary<string, object>
    {
        { "@PartnerID", partnerId }
    };

            var result = KkrSessBean(query, parameters);
            if (result.Count > 0)
            {
                var allowedApis = result[0]["allwdAPI"]?.ToString();
                return allowedApis?.Split(',').Select(api => api.Trim().ToLower()).ToList();
            }

            throw new Exception("No APIs found for the given PartnerID.");
        }

        // Log API requests into the comApiLogs table (itKharia)
        public void InsertIntoLog(string partnerId, string endpoint, string responseStatus, int statCode, object requestBody)
        {
            var checkQuery = "SELECT COUNT(*) AS Count FROM prmApiPrtnr WHERE partnrId = @PartnerID";
            var checkParams = new Dictionary<string, object>
    {
        { "@PartnerID", partnerId }
    };

            var exists = KkrSessBean(checkQuery, checkParams);
            if (exists.Count == 0 || Convert.ToInt32(exists[0]["Count"]) == 0)
            {
                Console.WriteLine($"Warning: PartnerID '{partnerId}' does not exist. Log insertion skipped.");
                return;
            }
            // Extract up to 8 properties from the request body
            var bodyDict = requestBody?.GetType().GetProperties()
                .Where(p => p.GetValue(requestBody) != null)
                .Select(p => $"{p.Name}={p.GetValue(requestBody)}")
                .Take(8)
                .ToList() ?? new List<string>();

            // Fill missing fields with empty strings
            while (bodyDict.Count < 8)
                bodyDict.Add("");

            var insertQuery = @"
        INSERT INTO comApiLogs (PartnerID, Endpoint, ResponseStatus, statCode, ReqsBod1, ReqsBod2, ReqsBod3, ReqsBod4, ReqsBod5, ReqsBod6, ReqsBod7, ReqsBod8)
        VALUES (@PartnerID, @Endpoint, @ResponseStatus, @StatCode, @ReqsBod1, @ReqsBod2, @ReqsBod3, @ReqsBod4, @ReqsBod5, @ReqsBod6, @ReqsBod7, @ReqsBod8)";

            var insertParams = new Dictionary<string, object>
    {
        { "@PartnerID", partnerId },
        { "@Endpoint", endpoint },
        { "@ResponseStatus", responseStatus },
        { "@StatCode", statCode },
        { "@ReqsBod1", bodyDict[0] },
        { "@ReqsBod2", bodyDict[1] },
        { "@ReqsBod3", bodyDict[2] },
        { "@ReqsBod4", bodyDict[3] },
        { "@ReqsBod5", bodyDict[4] },
        { "@ReqsBod6", bodyDict[5] },
        { "@ReqsBod7", bodyDict[6] },
        { "@ReqsBod8", bodyDict[7] }
    };
            ExecuteCommand(_itKhariaConnectionString, insertQuery, insertParams);
        }

        internal async Task<int> ExecuteNonQueryAsyncBwlive(string sql, Dictionary<string, object> p)
        {
            throw new NotImplementedException();
        }

        internal void InsertIntoLog(string? path, string v1, int v2, object value)
        {
            throw new NotImplementedException();
        }
    }
}
