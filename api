<%@ include file="/Envr/JSP/SecurityCom.jsp"%>

<%
String	sql = "",
		docuType = "DSR",
		docuNumb = "",
		dsrParam = XssFilter.parSmGet("dsrParam"),
		cusRtlFl = "",
		areaCode = "",
		cusRtlCd = "",
		cusRtTyp = "",
		repoCatg = "",
		atchNId1 = "",
		atchNmId = "",
		prodQnty = "",
		upldFlNm = "",
		projQnty = "",
		cstBisTy = "",
		actnRemk = "",
		targetDt = "",
		repoCatgMk = "",
		prodQntyMk = "",
		projQntyMk = "",
		custCdRt = "",
		catgPack = "",
		actnRemkMk = "",
		targetDtMk = "",
		dsrParTy = "83", //implemented from 01-Dec-17
		procType = XssFilter.parSmGet("procType"),
		docuDate = XssFilter.parSmGet("docuDate"),
		dsrRem01 = XssFilter.parSmGet("dsrRem01"),
		dsrRem02 = XssFilter.parSmGet("dsrRem02"),
		dsrRem03 = XssFilter.parSmGet("dsrRem03"),
		dsrRem04 = XssFilter.parSmGet("dsrRem04"),
		dsrRem05 = XssFilter.parSmGet("dsrRem05"),
		dsrRem06 = XssFilter.parSmGet("dsrRem06"),
		dsrRem07 = XssFilter.parSmGet("dsrRem07"),
		dsrRem08 = XssFilter.parSmGet("dsrRem08"),
		cityName = XssFilter.parSmGet("cityName"),
		pinCodeN = XssFilter.parSmGet("pinCodeN"),
		dsrRem09 = "",
		district = "",
		deptCode = XssFilter.parSmGet("deptCode"),
		submMthd = XssFilter.parSmGet("submMthd"),
		FinlRslt = XssFilter.parSmGet("FinlRslt"),
		geoLatit = XssFilter.parSmGet("geoLatit"),
		geoLongt = XssFilter.parSmGet("geoLongt"),
		serNumbr[] = null, 
		serNumMk[] = null, 
		statFlag = "N",
		//appValue[] = null,
		msg = "";

int imgCount = 0;

String[] srNumber1 = XssFilter.parArGet("srNumber1");

cusRtlFl = XssFilter.parSmGet("cusRtlFl");
areaCode = XssFilter.parSmGet("areaCode");
if (areaCode.equals(""))
{
	areaCode = log.getArCode();
}
cusRtlCd = XssFilter.parSmGet("cusRtlCd");

if(XssFilter.parArGet("serNumbr") != null)
	serNumbr = XssFilter.parArGet("serNumbr");
if(XssFilter.parSmGet("cstBisTy") != null)
	cstBisTy = XssFilter.parSmGet("cstBisTy");

if(XssFilter.parArGet("serNumMk") != null)
	serNumMk = XssFilter.parArGet("serNumMk");



if (dsrParam.equals("50") || dsrParam.equals("61"))
{
	dsrRem09 =	XssFilter.parSmGet("dsrRem09");
	district =	XssFilter.parSmGet("district");
	custCdRt =	XssFilter.parSmGet("custCdRt");
	
//	// System.out.println("custCdRt " + custCdRt);
	if(!custCdRt.trim().equals(""))
		cusRtlCd = custCdRt.trim();
	
	if(cusRtlFl.equals("R"))
	{
		cusRtTyp = "RT";
	}
	else if(cusRtlFl.equals("C"))
	{
		cusRtTyp = "ST";
	}
	else if (cusRtlFl.equals("RD"))
	{
		cusRtTyp = "RD";
	}
	else if(cusRtlFl.equals("RR"))
	{
		cusRtTyp = "RR";
	}
	else
	{
		cusRtTyp = cusRtlFl;
	}
}
if(!cusRtlCd.trim().equals("")) 
{
	if(!cusRtlCd.trim().equals(""))
		cusRtlCd = cusRtlCd.substring(0, 8);

	if(cusRtlFl.equals("R"))
	{
		cusRtTyp = "RT";
	}
	else if(cusRtlFl.equals("C") || cusRtlFl.equals("RD"))
	{
		sql = "select custType from dpmCustomer with (nolock) where custCode = '" + cusRtlCd + "' and isActive = 'Y' ";
		rset = WebSessBean.selectRecord(sql);
		if(rset.next())
			cusRtTyp = rset.getString(1);
	
	}
}
if (siteMktg.equals("S"))
{
	areaCode = UserBean.getArCode();
}


if (cusRtlFl.equals("RD"))
{
	cusRtlFl = "C";
}
else if(cusRtlFl.equals("RR"))
{
	cusRtTyp = "RR";
	cusRtlFl = "R";
}
else if(cusRtlFl.equals("07") || cusRtlFl.equals("08"))
{
	cusRtTyp = cusRtlFl;
	cusRtlFl = "P";
}

try
{
	WebSessBean.setAutoCommit(false);
	if (procType.equals("A"))
	{
			docuNumb = WebSessBean.getDocumentNo(docuType, areaCode);

			sql = "insert into dptDSRActvt (docuNumb, docuDate, dsrParTy, dsrParam, cusRtlFl, areaCode, cusRtlCd, dsrRem01, dsrRem02, dsrRem03, dsrRem04, dsrRem05, dsrRem06, dsrRem07, dsrRem08, dsrRem09, district, deptCode, statFlag, createId, createDt, locaCapr, latitute, lgtitute, pinCodeN, cityName, cstBisTy, cuRtType) values ("
				+ "'" +	docuNumb + "', "
				+ "'" + WebSessBean.dmyTOddmmmyyyy(docuDate) + "', "
				+ "'" + dsrParTy + "', "
				+ "'" + dsrParam + "', "
				+ "'" + cusRtlFl + "', "
				+ "'" + areaCode + "', "
				+ "'" + cusRtlCd + "', "
				+ "'" + dsrRem01 + "', "
				+ "'" + dsrRem02 + "', "
				+ "'" + dsrRem03 + "', "
				+ "'" + dsrRem04 + "', "
				+ "'" + dsrRem05 + "', "
				+ "'" + dsrRem06 + "', "
				+ "'" + dsrRem07 + "', "
				+ "'" + dsrRem08 + "', "
				+ "'" + dsrRem09 + "', "
				+ "'" + district + "', "
				+ "'" + deptCode + "', "
				+ "'" + statFlag + "', "
				+ "'" + loginIdM + "', "
				+ "getdate(), "
				+ "'" + FinlRslt + "', " 
				+ "'" + geoLatit + "', " 
				+ "'" + geoLongt + "', " 
				+ "'" + pinCodeN + "', " 
				+ "'" + cityName + "', " 
				+ "'" + cstBisTy + "', " 
				+ "'" + cusRtTyp + "') "; 
//	out.println(sql);
			WebSessBean.updateRecord(sql);	
			
			for(int i = 0; serNumbr != null && i < serNumbr.length; i++)
			{
				repoCatg = XssFilter.parSmGet("repoCatg" + serNumbr[i]);
				prodQnty = XssFilter.parSmGet("prodQnty" + serNumbr[i]);
				projQnty = XssFilter.parSmGet("projQnty" + serNumbr[i]);
				actnRemk = XssFilter.parSmGet("actnRemk" + serNumbr[i]);
				catgPack = XssFilter.parSmGet("catgPack" + serNumbr[i]);
				targetDt = WebSessBean.getNullDate(WebSessBean.dmyTOymd(XssFilter.parSmGet("targetDt" + serNumbr[i]))); 
				
		//		// System.out.println("Enter First For loop");
				if (!repoCatg.equals("") && Double.parseDouble(prodQnty) == 0 && Double.parseDouble(projQnty) == 0)
					continue;
				else
				{
					sql = "insert into dptDSRActvtDtl (docuNumb, docuSrNo, repoCatg, catgPack, prodQnty, projQnty, actnRemk, targetDt, statFlag, createId, createDt) "
							+ "values ( "
							+ "'" +	docuNumb + "', "
							+ "'" +	(i + 1) + "', "
							+ "'" +	repoCatg + "', "
							+ "'" +	catgPack + "', "
							+ "'" +	prodQnty + "', "
							+ "'" +	projQnty + "', "
							+ "'" +	actnRemk + "', "
							+ " " +	targetDt + ", "
							+ "'N', "
							+ "'" +	loginIdM + "', "
							+ "getdate()) ";
					WebSessBean.updateRecord(sql);	
				}
			}

			if (dsrParam.equals("50") || dsrParam.equals("01"))
			{
		//		// System.out.println("Param Condition");
				for(int j = 0; serNumMk != null && j < serNumMk.length; j++)
				{
			//		// System.out.println("Param Condition Loop");
					repoCatgMk = XssFilter.parSmGet("repoCatgMk" + serNumMk[j]);
					prodQntyMk = XssFilter.parSmGet("prodQntyMk" + serNumMk[j]);
					projQntyMk = XssFilter.parSmGet("projQntyMk" + serNumMk[j]);
					actnRemkMk = XssFilter.parSmGet("actnRemkMk" + serNumMk[j]);
					targetDtMk = WebSessBean.getNullDate(WebSessBean.dmyTOymd(XssFilter.parSmGet("targetDtMk" + serNumMk[j]))); 


					if (!repoCatg.equals("") && Double.parseDouble(prodQnty) == 0 && Double.parseDouble(projQnty) == 0)
						continue;
					else
					{
						sql = "insert into dptDSRActvtDtl (docuNumb, docuSrNo, repoCatg, prodQnty, projQnty, actnRemk, targetDt, mrktData, statFlag, createId, createDt) "
								+ "values ( "
								+ "'" +	docuNumb + "', "
								+ "'" +	(serNumbr.length + j + 1) + "', "
								+ "'" +	repoCatgMk + "', "
								+ "'" +	prodQntyMk + "', "
								+ "'" +	projQntyMk + "', "
								+ "'" +	actnRemkMk + "', "
								+ " " +	targetDtMk + ", "
								+ "'01', "
								+ "'N', "
								+ "'" +	loginIdM + "', "
								+ "getdate()) ";
						WebSessBean.updateRecord(sql);	
					}
				}
			}
			
			WebSessBean.insertDocuFlow(docuNumb, 0, "N", loginIdM, ipAddres, machName, "");
			WebSessBean.setDocumentNo(docuType, areaCode);
			

				for(int i=0; i<srNumber1.length; i++)
				{
					upldFlNm = XssFilter.parSmGet("upldFlNm" + srNumber1[i]);
				
					if(!upldFlNm.equals(""))
					{	
						sql = "update imagedata.dbo.cotDocAttch "
							+ "set docuNumb = '" + docuNumb + "', updateDt = GETDATE(), updateId = '" + loginIdM + "' " 
							+ "where docuNumb = '" + upldFlNm + "' " ;

						KkrSessBean.updateRecord(sql);
						imgCount++;
					}
				}

			if(imgCount > 0)
			{
				sql = "select atchNmId from  imagedata.dbo.cotDocAttch with (nolock) where docuNumb = '" + docuNumb + "' ";
				//// System.out.println(sql);
				rset = KkrSessBean.selectRecord(sql);
				while (rset.next())
				{
					atchNmId = rset.getString(1);
					atchNId1 += "," + atchNmId;
				}
				
				atchNId1 = atchNId1.substring(1);

				sql = "update dptDSRActvt set atchNmId = '" + atchNId1 + "' where  docuNumb = '" + docuNumb + "' " ;
			//	// System.out.println(sql);
				WebSessBean.updateRecord(sql);
			}
			WebSessBean.commitConn();
			KkrSessBean.commitConn();
	//	WebSessBean.rollbackConn();
	//	KkrSessBean.rollbackConn();

		//msg = appValue[1];
		msg = "Document saved with " + docuNumb;
	}
	else if(procType.equals("U"))
	{
		docuNumb = XssFilter.parSmGet("docuNumb");

		sql = "update dptDSRActvt set dsrParTy = '" + dsrParTy + "', "
			+ "dsrParam = '" + dsrParam + "', "
			+ "docuDate = '" + WebSessBean.dmyTOddmmmyyyy(docuDate) + "', "
			+ "cusRtlFl = '" + cusRtlFl + "', "
			+ "cusRtlCd = '" + cusRtlCd + "', "
			+ "dsrRem01 = '" + dsrRem01 + "', "
			+ "dsrRem02 = '" + dsrRem02 + "', "
			+ "dsrRem03 = '" + dsrRem03 + "', "
			+ "dsrRem04 = '" + dsrRem04 + "', "
			+ "dsrRem05 = '" + dsrRem05 + "', "
			+ "dsrRem06 = '" + dsrRem06 + "', "
			+ "cstBisTy = '" + cstBisTy + "', "
			+ "dsrRem07 = '" + dsrRem07 + "', "
			+ "dsrRem08 = '" + dsrRem08 + "',  "
			+ "dsrRem09 = '" + dsrRem09 + "',  "
			+ "district = '" + district + "',  "
			+ "pinCodeN = '" + pinCodeN + "',  "
			+ "cityName = '" + cityName + "',  "
			+ "areaCode = '" + areaCode + "',  "
			+ "cuRtType = '" + cusRtTyp + "',  "
			+ "updateDt = GETDATE(), "
			+ "updateId = '" + loginIdM + "' "
			+ "where  docuNumb = '" + docuNumb + "' " ;
		
		WebSessBean.updateRecord(sql);

			sql = "delete from dptDSRActvtDtl where docuNumb = '" + docuNumb + "' ";
			WebSessBean.updateRecord(sql);	
			for(int i = 0; serNumbr != null && i < serNumbr.length; i++)
			{
				repoCatg = XssFilter.parSmGet("repoCatg" + serNumbr[i]);
				prodQnty = XssFilter.parSmGet("prodQnty" + serNumbr[i]);
				projQnty = XssFilter.parSmGet("projQnty" + serNumbr[i]);
				actnRemk = XssFilter.parSmGet("actnRemk" + serNumbr[i]);
				catgPack = XssFilter.parSmGet("catgPack" + serNumbr[i]);
				targetDt = WebSessBean.getNullDate(WebSessBean.dmyTOymd(XssFilter.parSmGet("targetDt" + serNumbr[i]))); 

				if (!repoCatg.equals("") && Double.parseDouble(prodQnty) == 0 && Double.parseDouble(projQnty) == 0)
					continue;
				else
				{
				sql = "insert into dptDSRActvtDtl (docuNumb, docuSrNo, repoCatg, catgPack, prodQnty, projQnty, actnRemk, targetDt, statFlag, createId, createDt) "
							+ "values ( "
							+ "'" +	docuNumb + "', "
							+ "'" +	(i + 1) + "', "
							+ "'" +	repoCatg + "', "
							+ "'" +	catgPack + "', "
							+ "'" +	prodQnty + "', "
							+ "'" +	projQnty + "', "
							+ "'" +	actnRemk + "', "
							+ " " +	targetDt + ", "
							+ "'N', "
							+ "'" +	loginIdM + "', "
							+ "getdate()) ";
					WebSessBean.updateRecord(sql);	
				}
			}
			for(int j = 0; serNumMk != null && j < serNumMk.length; j++)
			{
				repoCatgMk = XssFilter.parSmGet("repoCatgMk" + serNumMk[j]);
				prodQntyMk = XssFilter.parSmGet("prodQntyMk" + serNumMk[j]);
				projQntyMk = XssFilter.parSmGet("projQntyMk" + serNumMk[j]);
				actnRemkMk = XssFilter.parSmGet("actnRemkMk" + serNumMk[j]);
				targetDtMk = WebSessBean.getNullDate(WebSessBean.dmyTOymd(XssFilter.parSmGet("targetDtMk" + serNumMk[j]))); 

				if (!repoCatgMk.equals("") && Double.parseDouble(prodQntyMk) == 0 && Double.parseDouble(projQntyMk) == 0)
					continue;
				else
				{
					sql = "insert into dptDSRActvtDtl (docuNumb, docuSrNo, repoCatg, prodQnty, projQnty, actnRemk, targetDt, statFlag, createId, createDt) "
							+ "values ( "
							+ "'" +	docuNumb + "', "
							+ "'" +	(j + 1) + "', "
							+ "'" +	repoCatgMk + "', "
							+ "'" +	prodQntyMk + "', "
							+ "'" +	projQntyMk + "', "
							+ "'" +	actnRemkMk + "', "
							+ " " +	targetDtMk + ", "
							+ "'N', "
							+ "'" +	loginIdM + "', "
							+ "getdate()) ";
					WebSessBean.updateRecord(sql);	
				}
			}

		WebSessBean.commitConn();
//		WebSessBean.rollbackConn();

		msg = "Data SuccessFully updated Document No is :  " + docuNumb + "."  ;
	}

	if(submMthd.equals("E"))
		response.sendRedirect(errorPage + "?message=" + msg );
	else
		response.sendRedirect("DSRActv.jsp?docuDate=" + docuDate);
}
catch (Exception e)
{
	WebSessBean.rollbackConn();
	KkrSessBean.rollbackConn();
	throw new Exception("Error in updating details in " + pageAddress + e.toString() + docuNumb + sql );
}
finally
{
	UtilBean.sessMgmtRst();
}
%>

