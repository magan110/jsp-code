<%@ include file="/Envr/JSP/SecurityCom.jsp"%>

<%
ResultSet rset = null;
ResultSetMetaData rsmd = null;

/*
http://10.4.64.20/BirlaWhite/Mobile/DSRActv.jsp

ADD EDIT DELETE Button to be Given 

dsrSizAr Text Box Limit Size Array to be Filled with Department Condition

separate 

DSR Changes In DEC 2018

	1.	DSR Open in update Mode with Last Three Days
	2.  Added Search Box in areaCode
	3.  AJAX Dropdown in Purchaser & Retl Code
	4.  New Dept type Added For varun Goyal KKR162
	5.  Added New product 
	6.  Also Capture Area Code during Save page
	7.  Added New Column For cusRtTyp
	8.  Approval Proccess For new VAP Team
	9.  Added Two new Colummn For CASC Name& Mobile No in Site Activity -- Pending


DSR Change 05/09/2019

1.  Market mapping
2.


*/
//// System.out.println("1");
String  sql = "",
		procType = "A",
		docuNumb = "",
		paramCod = "",
		paramDes = "",
		mktNamUF = "Y",
		cusRtlFl = "",
		areaCode = "",
		custCdRt = "",
		cusRtlCd = "",
		randNmSt = "",
		stateGeo = "",
		pinCodeN = "",
		custName = "",
		rplNwScF = "",
		rplNwAlF = "",
		cstBisTy = "",
		prtDsCnt = "",
		kycVerFl = "",
		pndIsuDt = "",
		pendIsue = "N",
		cityName = "",
		calVstTy = "",
		FinlRslt = "",
		geoLatit = "",
		geoLongt = "",
		wcErlSlb = "0",
		wpErlSlb = "0",
		vpErlSlb = "0",
		ordExDat = "",
		dsrRem09 = "",
		dsrRem01 = "",
		wcHgstSl = "",
		bwCurWcc = "",
		bwCurWcp = "",
		bwCurVap = "",
		pendWith = "",
		mrktName = "",
		brndSlWc = "",
		brndSlWp = "",
		isuDetal = "",
		dsrRem02 = "",
		dsrRem03 = "",
		dsrRem04 = "",
		dsrRem05 = "",
		dsrRem06 = "",
		bwAvgWcc = "",
		bwAvgWcp = "",
		sapLgnGr = (log.sapLgnIdGet().length() < 6 ? "" : log.sapLgnIdGet().substring(0, 6)),
		bwAvgVap = "",
		dsrRem07 = "",
		dsrRem08 = "",
		bwStkWcc = "0.00",
		bwStkWcp = "0.00",
		bwStkVap = "0.00",
		docuSrNo = "",
		repoCatg = "",
		prodQnty = "",
		statCode = "",
		areaDesc = "",
		cuRtType = "",
		actnRemk = "",
		targetDt = "",
		docuTySt = "",
		zoneCode = "",
		message  = "",
		locaCapr = "",
		lgtitute = "",
		latitute = "",
		district = "",
		cusRtlNm = "",
		snopFrAl = "",
		mobileNo = "",
		prdCodMk = "",
		docuType = "",
		gftTyStr = "",
		mrtlCode = "",
		isTilRtl = "",
		inOutFlg = "",
		docuDate = sysDateOnly, 
		strtDate = "01" + sysDateOnly.substring(2),
		dsrParam = "",
		deptCode = log.deptCodeGet(), // For Department added KKR115	Advertisement 26-Apr-18 
//		deptCode = "KKR116", 
		dsrParamStr = "",
		wcHgstSlStr = "",
		cusRtlFlStr = "",
		count = "",
		rtlInTim = "IN",
		custLabl = "Purchaser / Retailer",
		dsrRemAr[] = new String[8],
		dsrSizAr[][] = new String[4][8], // 0 and 1 for Text Area Ht Wd and 2 for S Select List, T for text Box 
		formName = "DSRActvNew"; 
int i, j, msAreCnt = 0, trAreCnt= 0;
boolean recFound = false,
		actPntRq = false,
		prdSelRq = false,
		cusSelRq = false,
		cusCodRq = false,
		prjSelRq = false,
		pinCdRqA = false,
		dsrEntAl = true,
		dsrStkAl = true,
		rtlTrgFl = false,
		docuDtRq = false;

int		ttlMpdRt = 0,
		ttlMpdUq = 0,
		targtCmt = 0,
		targtPty = 0,
		noOfColm = 0,
		targtVAP = 0;

Double 	trgCmtPr = 0.00,
		trgPtyPr = 0.00,
		tileStck = 0.00,
		trgVapPr = 0.00;

for(j = 0; j < dsrSizAr[0].length; j++) // common Width for Text Area 
{
	dsrSizAr[0][j] = "2";
	dsrSizAr[1][j] = "35";
	dsrSizAr[2][j] = "T";
	dsrRemAr[j] = "";
}


sql = " select count(*) as count from bwlive.dbo.dptDSRActvt a with (nolock), prmEmployee b with (nolock), bkmAreaStZn c with (nolock) where a.createId = b.loginIdM and b.areaCode = c.areaCode and  a.rtOutTim is null and a.createDt >= '26 Sep 2024 11:26' and c.zoneCode = 'N' and dsrParam = '05' and statFlag not in ('C','R') and  a.createId = '" + loginIdM + "' ";
	rset = WebSessBean.selectRecord(sql);
	if(rset.next()) 
	{
		 i=1;
		count = rset.getString(i++);
	}

if(!count.equals("0"))
{

	sql = "select 'U',docuNumb, isnull(cast(rtlInTim as varchar),'IN'), isnull(cast(rtlInTim as varchar),'OUT')  from bwlive.dbo.dptDSRActvt where rtOutTim is null and createDt >= '26 Sep 2024 11:26' and dsrParam = '05' and statFlag not in ('C','R') and createId = '" + loginIdM + "' ";
	rset = WebSessBean.selectRecord(sql);
	if(rset.next()) 
	{
		 i=1;
		procType = rset.getString(i++);
		docuNumb = rset.getString(i++);
		rtlInTim = rset.getString(i++);
	}
}
//System.out.println("rtlInTim : "+rtlInTim);


//System.out.println("procType : "+procType);

sql = " select paramCod, paramDes from wcmParametr with (nolock) where paramTyp = '117' and paramCod <> '00000' and isActive = 'Y' ";
gftTyStr = WebSessBean.getSqlToOptionStr(sql, mrtlCode);

if(loginIdM.equals("2954") || loginIdM.equals(log.getZoneHead()))
{
	pendWith = log.getFuncHdMk();
}
else if(sapLgnGr.equals("BWZHKY") || sapLgnGr.equals("BWSHRT") || sapLgnGr.equals("BWZHCS") || sapLgnGr.equals("BWZCUB")) 
{
	pendWith = log.getZoneHead();
}
else if(sapLgnGr.equals("BWMORL")) 
{
//	pendWith = log.rurlHeadGet(); //ruralHead
	sql = " select rurlStHd from bkmStateLgc with (nolock) where stLgcCod in (select stLgcCod from bkmAreaMast with (nolock) where areaCode  = '" + log.getArCode() + "') ";
	rset = WebSessBean.selectRecord(sql);

	if(rset.next())
	{
		pendWith = rset.getString(1);
	}
}
else if(log.deptCodeGet().equals("KKR162")) 
{
	pendWith = "2440"; //VAP Team
}
else
{
	pendWith = log.getStatHead();
}

if(log.getUserType().equals("S"))
{
	sql = "select retlArHd from bkmAreaMast where areaCode = '" + log.getArCode() + "' ";
	rset = WebSessBean.selectRecord(sql);

	if(rset.next())
	{
		pendWith = rset.getString(1);
	}
}

wcHgstSlStr = WebSessBean.getSqlToOptionStr("select sapPrdCd, prodDesc + ' : ' + repoCatg from bkmProducts with (nolock) where isActive = 'Y' and repoCatg in  ('02','01') and packSize in (40,50) and tradeNtr = 'T' ", prdCodMk);

statCode = log.stateCodGet();

	sql = "select zoneCode from bkmAreaStZn where areaCode = '" + log.getArCode() + "' ";
	rset = WebSessBean.selectRecord(sql);
	if(rset.next())
	{
		zoneCode = rset.getString(1);
	}

	if(zoneCode.equals("A") || zoneCode.equals("B"))
	{
		pinCdRqA = true;
	}
	
//	loginIdM = "2961";
	sql = "select  count(distinct a.areaCode), count(distinct b.areaCode) "
		+ "from	bkmAreaMast a with (nolock) left outer join dptMktIntel b with (nolock) on a.areaCode = b.areaCode and		b.mnthYear = dbo.cofPrevMnYr(convert(varchar(6), getdate(), 112),  getdate())  "
		+ "where	a.retlArHd = '" + loginIdM + "' and  a.areaCode not in ('EXB','EXC','EXE','EXG','EXN','EXR','EXT','EXR','KKR', 'KAT', 'DLC','PNY','BKM','HAM','KGR','SGO','DHU','JAG') and isnull(a.isOnlyDp,'N') <> 'Y' and a.isActive = 'Y' ";
	rset = WebSessBean.selectRecord(sql);

//
//	out.println(sql);
	if(rset.next())
	{
		msAreCnt = rset.getInt(1);
		trAreCnt = rset.getInt(2);
//	out.println("msAreCnt : " + msAreCnt + loginIdM);
//	out.println("trAreCnt : " + trAreCnt);
		if(msAreCnt > 0 && msAreCnt != trAreCnt) // && trAreCnt != "0"		  unComment When Lockdown over
			dsrEntAl = false;
	}

//	loginIdM = "2961";
	sql = "select  count(distinct a.areaCode), count(distinct b.areaCode) "
		+ "from	bkmAreaMast a with (nolock) left outer join "
		+ "( "
		+ "		select distinct a.mnthYear, b.areaCode "
		+ "		from dptStkTgtRc a with (nolock), dpmCustomer b with (nolock) "
		+ "		where mnthYear = convert(varchar(6), getdate(), 112) "
		+ "		and   a.custCode  = b.custCode and a.repoCatg = '01' "
		+ ") b "
		+ "on a.areaCode = b.areaCode and		b.mnthYear = convert(varchar(6), getdate(), 112) "
		+ "where	a.areaCode not in ('EXB','EXC','EXE','EXG','EXN','EXR','EXT','KKR','EXT', 'KAT', 'DLC','HAM','KGR','SHI','SGO','DHU') and isnull(a.isOnlyDp,'N') <> 'Y' "
		+ "and	a.retlArHd = '" + loginIdM + "' and  a.areaCode not in ('EXB','EXC','EXE','EXG','EXN','EXR','EXT','EXT','KKR', 'KAT', 'DLC','PNY','BKM','HAM','KGR','SHI','SGO','DHU','JAG') and a.isActive = 'Y'  ";
	rset = WebSessBean.selectRecord(sql);
	//out.println(sql);
	if(rset.next())
	{
		msAreCnt = rset.getInt(1);
		trAreCnt = rset.getInt(2);

//	out.println("msAreCnt : " + msAreCnt + loginIdM);
//	out.println("trAreCnt : " + trAreCnt);
		if(msAreCnt > 0 && msAreCnt != trAreCnt) // && trAreCnt != "0" --Commented as per Rajendra advise 04-02-2020
			dsrStkAl = false;
	}
	
	if(dsrStkAl)
	{
		sql = "select  count(distinct a.areaCode), count(distinct b.areaCode) "
			+ "from	bkmAreaMast a with (nolock) left outer join "
			+ "( "
			+ "		select distinct a.mnthYear, b.areaCode "
			+ "		from dptStkTgtRc a with (nolock), dpmCustomer b with (nolock) "
			+ "		where mnthYear = convert(varchar(6), getdate(), 112) "
			+ "		and   a.custCode  = b.custCode and a.repoCatg = '02' "
			+ ") b "
			+ "on a.areaCode = b.areaCode and		b.mnthYear = convert(varchar(6), getdate(), 112) "
			+ "where	a.areaCode not in ('EXB','EXC','EXE','EXG','EXN','EXR','EXT','EXT','KKR', 'KAT', 'DLC','HAM','KGR','SHI','SGO','DHU') and isnull(a.isOnlyDp,'N') <> 'Y' "
			+ "and	a.retlArHd = '" + loginIdM + "' and  a.areaCode not in ('EXB','EXC','EXE','EXG','EXN','EXR','EXT','EXT','KKR', 'KAT', 'DLC','PNY','BKM','HAM','KGR','SHI','SGO','DHU','JAG') and a.isActive = 'Y'  ";
		rset = WebSessBean.selectRecord(sql);
		if(rset.next())
		{
			msAreCnt = rset.getInt(1);
			trAreCnt = rset.getInt(2);

	//	out.println("msAreCnt : " + msAreCnt + loginIdM);
	//	out.println("trAreCnt : " + trAreCnt);
			if(msAreCnt > 0 && msAreCnt != trAreCnt) // && trAreCnt != "0" --Commented as per Rajendra advise 04-02-2020
				dsrStkAl = false;
		}
	}
	sql = "select AreaDesc from bkmAreaMast with (nolock) where retlArHd = '" + loginIdM + "' and  isActive = 'Y' and isnull(isOnlyDp,'N') <> 'Y' ";
	rset = WebSessBean.selectRecord(sql);

	while(rset.next())
	{
		areaDesc += rset.getString(1) + ", ";
	}


if(zoneCode.equals("C"))
{
	sql = "select  sum(mapedRtlCnt), sum(trgtEntCt), sum(cmt01) as cmt01, sum(cmt02) as cmt02, sum(cmt03) as cmt03, sum(ttlCnt) as ttlCnt, "
		+ "		   dbo.cofCalcPerc('normPerc', sum(cmt01), sum(mapedRtlCnt)) as 'Cmt-%', "
		+ "		   dbo.cofCalcPerc('normPerc', sum(cmt02), sum(mapedRtlCnt)) as 'Puty-%', "
		+ "		   dbo.cofCalcPerc('normPerc', sum(cmt03), sum(mapedRtlCnt)) as 'Vap-%' "
		+ "From  "
		+ "( "
		+ "	select b.loginIdM, b.emplName, count(*)  as mapedRtlCnt, 0 as trgtEntCt, 0 as cmt01,0 as cmt02, 0 as cmt03, 0 as ttlCnt "
		+ "	from rtmRetailer a with (nolock), prmEmployee b with (nolock), bkmAreaStZn c with (nolock) "
		+ "	where a.concEmpl = b.loginIdM "
		+ "	and   b.areaCode = c.areaCode "
		+ "	and   a.isActive = 'Y' "
		+ "	and   b.isActive = 'Y'  and b.position <> 'EM05' "
		+ "	and   c.zoneCode = 'C' and   a.createDt < convert(varchar(11), DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0), 113)  "
		+ " and   b.loginIdM = '" + loginIdM + "' "
		+ "	group by b.loginIdM, b.emplName "
		+ "	union all "
		+ "	select b.loginIdM, b.emplName, 0, count(distinct a.retlCode) as trgtEntCt,  "
		+ "		   sum(case when repoCatg = '01' then 1 else 0 end) as cmt01, "
		+ "		   sum(case when repoCatg = '02' then 1 else 0 end) as cmt02, "
		+ "		   sum(case when repoCatg = '03' then 1 else 0 end) as cmt03, count(*) as ttlCnt "
		+ "	from rtmRetailer a with (nolock), prmEmployee b with (nolock), bkmAreaStZn c with (nolock), dptCusRtlTg d with (nolock) "
		+ "	where a.concEmpl = b.loginIdM "
		+ "	and   b.areaCode = c.areaCode "
		+ "	and   a.retlCode = d.cusRtlCd "
		+ "	and   d.cusRtlFl = 'R' "
		+ "	and   d.mnthYear = CONVERT(varchar(6), getdate(), 112) "
		+ "	and   d.statFlag not in ('C','R') "
		+ "	and   a.isActive = 'Y' "
		+ "	and   b.isActive = 'Y' and b.position <> 'EM05'  "
		+ "	and   c.zoneCode = 'C' "
		+ " and   b.loginIdM = '" + loginIdM + "' "
		+ "	group by b.loginIdM, b.emplName "
		+ ") x "
		+ "where x.loginIdM = '" + loginIdM + "' "
		+ "and   x.loginIdM not in ('2603','3841','vendor1') "
		+ "group by loginIdM, emplName ";

	rset = WebSessBean.selectRecord(sql);

	if(rset.next())
	{
		ttlMpdRt = rset.getInt(1);
		ttlMpdUq = rset.getInt(2);
		targtCmt = rset.getInt(3);
		targtPty = rset.getInt(4);
		targtVAP = rset.getInt(5);
		trgCmtPr = rset.getDouble(7);
		trgPtyPr = rset.getDouble(8);
		trgVapPr = rset.getDouble(9);

		if(ttlMpdRt > 0 && (trgCmtPr < 100 || trgPtyPr < 100 || trgVapPr < 100))
		{
			dsrEntAl = false;
			rtlTrgFl = true;
		}
	}
}

dsrStkAl =true;
dsrEntAl =true;
	/*
//	// System.out.println("dsrEntAl 5 " + dsrEntAl );
	sql = "	select  'SnOP',  nwMtKgLt, count(distinct case when noOfEntry > 0 then areaCode else null end), count(distinct areaCode),  "
		+ "			case when sum(noOfEntry) > 0 then 'Done' else 'Pending' end "
		+ "From  "
		+ "( "
		+ "	selecT  c.stLgcCod, c.retlStHd, a.areaCode, d.nwMtKgLt, count(*) as noOfEntry "
		+ "	From	dptAreaDemd a with (nolock), bkmAreaMast b with (nolock), bkmStateLgc c with (nolock), bkmCatgPack d with (nolock) "
		+ "	where	a.areaCode = b.areaCode "
		+ "	and		b.stLgcCod = c.stLgcCod	"
		+ "	and		a.mnthYear = dbo.cofNextYrMn(convert(varchar(6), getdate(), 112)) "
		+ "	and		a.catPckCd = d.catPckCd "
		+ "	and     a.statFlag not in ('C','R') "
		+ "	group   by c.stLgcCod, c.retlStHd, a.areaCode, d.nwMtKgLt "
		+ "	union all "
		+ "	selecT  c.stLgcCod, c.retlStHd, b.areaCode, d.nwMtKgLt, 0 "
		+ "	From	bkmAreaMast b with (nolock), bkmStateLgc c with (nolock), bkmCatgPack d with (nolock) "
		+ "	where	b.stLgcCod = c.stLgcCod "
		+ "	and     d.isActive = 'Y' "
		+ "	and     b.isActive = 'Y' and  b.areaCode not in ('EXB','EXC','EXE','EXG','EXN','EXR','EXT','EXR','EXT','EXR','KKR', 'KAT', 'DLC','PNY','BKM','NAT','KAT','JPF','KGR') "
		+ "	and     d.prodCdDs is not null "
		+ "	group   by c.stLgcCod, c.retlStHd, b.areaCode, d.nwMtKgLt "
		+ ")x "
		+ "where retlStHd = '" + loginIdM + "' "
		+ "and   day(getdate()) >= 19 "
		+ "group by stLgcCod,  nwMtKgLt "  ;
	rset = WebSessBean.selectRecord(sql);
	
	while(rset.next())
	{
		snopFrAl = rset.getString(5);
	//	   // System.out.println(snopFrAl);
		if(snopFrAl.equals("Pending") && dsrEntAl)
		{
			dsrEntAl = false;
			break;
		}
	}
	*/
//	// System.out.println("snopFrAl 6" + snopFrAl );
// out.println("dsrStkAl " + dsrStkAl);

sql = "select '1BF', 'Before' union select '2AF', 'After' union select 'ADH', 'More Image' ";
docuTySt = WebSessBean.getSqlToOptionStr(sql, ""); 

if (XssFilter.parSmGet("deptCode") != null)
	deptCode = XssFilter.parSmGet("deptCode");

if (XssFilter.parSmGet("dsrRem08") != null)
	dsrRem08 = XssFilter.parSmGet("dsrRem08");

if (XssFilter.parSmGet("cusRtlFl") != null)
	cusRtlFl = XssFilter.parSmGet("cusRtlFl");

if (XssFilter.parSmGet("procType") != null)
	procType = XssFilter.parSmGet("procType");

if (XssFilter.parSmGet("docuNumb") != null)
	docuNumb = XssFilter.parSmGet("docuNumb");

if (XssFilter.parSmGet("cuRtType") != null)
	cuRtType = XssFilter.parSmGet("cuRtType");

if (XssFilter.parSmGet("calVstTy") != null)
	calVstTy = XssFilter.parSmGet("calVstTy");

if (XssFilter.parSmGet("areaCode") != null)
	areaCode = XssFilter.parSmGet("areaCode");

if (XssFilter.parSmGet("cusRtlCd") != null)
	cusRtlCd = XssFilter.parSmGet("cusRtlCd");

if (XssFilter.parSmGet("dsrParam") != null)
	dsrParam = XssFilter.parSmGet("dsrParam");

if (XssFilter.parSmGet("formName") != null)
	formName = XssFilter.parSmGet("formName");

if (XssFilter.parSmGet("docuDate") != null)
	docuDate = XssFilter.parSmGet("docuDate");

if (XssFilter.parSmGet("message") != null)
	message = XssFilter.parSmGet("message");

if (XssFilter.parSmGet("docuType") != null)
	docuType = XssFilter.parSmGet("docuType");

if (XssFilter.parSmGet("inOutFlg") != null)
	inOutFlg = XssFilter.parSmGet("inOutFlg");


if(procType.equals("U") || procType.equals("D"))
{
	docuDtRq = true;
}
else if(procType.equals("A"))
{
	docuDtRq = false;
}

if(!rtlInTim.equals("IN"))
{
	procType = "U";
}

%>
 <!-- Header Starts -->
<jsp:include page="/Envr/JSP/HeaderCom.jsp" flush="true">
		<jsp:param name="mobFrend" value="B"/>
</jsp:include>
<!-- Header Ends -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" ></script>
<script>
if("<%=zoneCode%>" == "N" && "<%=procType%>" == "A" && "<%=rtlInTim%>" == "IN")
	location.href = "DSRInOutFlg.jsp";
</script>
<%
try
{
	if(!docuNumb.equals("") && (procType.equals("U")  || procType.equals("D")))
	{
		sql = "select docuNumb, convert(char(10), docuDate , 103), dsrParam, cusRtlFl, cusRtlCd, dsrRem01, dsrRem02, dsrRem03, dsrRem04, dsrRem05, dsrRem06, dsrRem07, dsrRem08, areaCode, isnull(cuRtType, ''), convert(char(10), ordExDat , 103)   from dptDSRActvt with (nolock) where docuNumb = '" + docuNumb + "'  and createId = '" + loginIdM + "' ";	// and createId = '" + loginIdM + "'
		rset = WebSessBean.selectRecord(sql);
	//	out.println(sql);
		if (rset.next())
		{
			docuNumb = rset.getString(1);
			docuDate = rset.getString(2);
			dsrParam = rset.getString(3);
			cusRtlFl = rset.getString(4);
			cusRtlCd = rset.getString(5);
			dsrRem01 = rset.getString(6);
			dsrRem02 = rset.getString(7);
			dsrRem03 = rset.getString(8);
			dsrRem04 = rset.getString(9);
			dsrRem05 = rset.getString(10);
			dsrRem06 = rset.getString(11);
			dsrRem07 = rset.getString(12);
			dsrRem08 = rset.getString(13);
			areaCode = rset.getString(14);
			cuRtType = rset.getString(15);
			ordExDat = rset.getString(16);
		}

		if (cuRtType.equals("RR"))
		{
			cusRtlFl = "RR";			
		}
		if (cuRtType.equals("RD"))
		{
			cusRtlFl = "RD";			
		}
		mrktName = dsrRem01; 
		pendIsue = dsrRem02; 
		pndIsuDt = dsrRem03; 
		isuDetal = dsrRem04; 
		brndSlWc = dsrRem06; 
		brndSlWp = dsrRem07; 
		prtDsCnt = dsrRem08; 

//		out.println("dsrRem01 : " + dsrRem01);
	//	areaCode = docuNumb.substring(3,6);

	//	out.println("areaCode Update " + areaCode);
	}

sql = "select 'R', 'Retailer' union select 'RR', 'Rural Retailer' union select 'C', 'Stockiest/ Urban Stockiest' union select 'D', 'Direct Dealer' union select 'RD', 'Rural Stockiest' union select 'AD', 'AD' union select 'UR', 'UBS' ";//select 'C', 'Stockiest/ Urbon Stockiest' union select 'D', 'Direct Dealer'  union select 'RD', 'Rural Stockiest'  union 
if(dsrParam.equals("52") || dsrParam.equals("13") || dsrParam.equals("23") || dsrParam.equals("41") || dsrParam.equals("50"))
	actPntRq = true;
if(dsrParam.equals("01") ||dsrParam.equals("02") ||dsrParam.equals("61") || dsrParam.equals("51") || dsrParam.equals("11") || dsrParam.equals("21"))
	prdSelRq = true;
if(dsrParam.equals("01") || dsrParam.equals("02") || dsrParam.equals("21"))
	prjSelRq = true;


if(dsrParam.equals("01") || dsrParam.equals("61") || dsrParam.equals("02") || dsrParam.equals("12") || dsrParam.equals("13") || dsrParam.equals("22") || dsrParam.equals("23") || dsrParam.equals("04") || dsrParam.equals("05") || dsrParam.equals("50") || dsrParam.equals("41")) // || dsrParam.equals("21") || dsrParam.equals("11") // removed 31-Jan-18
{
	cusSelRq = true;
	
	if(dsrParam.equals("50") || dsrParam.equals("61"))
		cusCodRq = false;
	else
		cusCodRq = true;
}
		cusCodRq = true;


if(deptCode.equals("KKR158"))
	 deptCode = "KKR116";
else if(deptCode.equals("KKR125")) // Key accounts 
	 deptCode = "KKR118";

cusRtlFlStr = WebSessBean.getSqlToOptionStr(sql, cusRtlFl);


//dsrParamStr = WebSessBean.getSqlToOptionStr("select paramCod, paramDes from wcmParametr with (nolock) where paramTyp = 83 and paramCod <> '00000' and paramCod in ('02') ", dsrParam); 
%>

<script type="text/javascript" language="javascript">
var withutLcAl = "N";
var withAlNm = 0;

function getBuildNumb(str) 
{
  var myVar = null;
  myVar = Android.getBuildNumb();
  
  if(myVar < "1.54")
  {
    displErr("Dear User Please Update Your Mobile App from Play Store");
//    window.location  = "https://play.google.com/store/apps/details?id=com.bw.sparsh";
    return false;
  }
}

if("<%=mobilApp%>" == "true" && isAndroid)
	getBuildNumb();  


var upldFlNm ;

var hdRowCnt = 1;

function refreshed(currObjt)
{
	//return false;
	if(currObjt == "Y")
	{
		if(document.<%=formName%>.cusRtlCd.value == "")
		{
			displErr("Purchaser Code Cannot be blank");
			return false
		}
		if(document.<%=formName%>.cusRtlCd.value.length > 1)
		{
			var cstRtlVl = document.<%=formName%>.cusRtlCd.value.split("~");
			document.<%=formName%>.cusRtlCd.value = cstRtlVl[0];
		var rtnValue = customerValidDsr();
		}
	}
	else
	{
		rtnValue = true;
	}
	if(rtnValue)
	{
		document.<%=formName%>.method = "POST";
		document.<%=formName%>.action = "<%=formName%>.jsp";
		document.<%=formName%>.submit();
	}
}

var hdRowCnt = 1;

function addrow1(currOjct)
{
	addrow(currOjct, "", "", "", "", "");
}


function addrowGf1(currOjct)
{
	addrowGf(currOjct, "", "");
}


function repoDescPop(numbRows)
{
	var srcFldNm = "repoDesc" + numbRows,
		tgtFldNm = "repoDesc" + numbRows + "Div",
		newCustS = "Y";

	var queryCod = "",
		wherList = "",
		rtnValue = false,
		rqstType = "G";
		queryCod = "MK_01059";

	wherList = whMasAdd(wherList, "Y");
	wherList = whereAdd(wherList, "SW_03", "'T','B'");

	rtnValue = setPrmNew("<%=formName%>", srcFldNm, queryCod, rqstType, "DN", wherList, tgtFldNm);
	if (!rtnValue)
		return false;

	repoDescArr = document.getElementById(tgtFldNm).innerText.split("~~");
	document.getElementById(tgtFldNm).innerText = "";

	$("#repoDesc" + numbRows).autocomplete(
	{
		source: repoDescArr
	});
	return true;

}

function repoDescChng(numbRows)
{
	a = eval("document.<%=formName%>.prodCode" + numbRows).options[eval("document.<%=formName%>.prodCode" + numbRows).selectedIndex].text;
	b = a.split(" : ");

	document.getElementById("catgPkPr" + numbRows).value = b[0];
	document.getElementById("secnPack" + numbRows).value = b[3];
	document.getElementById("secNoTon" + numbRows).value = b[4];
	rtnValue = packSizeChk("document.<%=formName%>.prodQnty" + numbRows, b[3]);

	if(rtnValue)
	{	
		eval("document.<%=formName%>.projQnty" + numbRows).value =   eval("document.<%=formName%>.prodQnty" + numbRows).value / b[4];
		document.getElementById("prdQtMt" + numbRows).innerText =    eval("document.<%=formName%>.prodQnty" + numbRows).value / b[4];
	}
}

function packSizeChk(prodQnty, secnPack)
{
	//displErr(eval(prodQnty).value + " . secnPack : " + secnPack)
	var qtyToChk = parseFloat(eval(prodQnty).value)/parseInt(secnPack);
	
//	displErr("qtyToChk " + qtyToChk % 1);
	
	if(qtyToChk % 1 > 0)
	{
		displErr("Entered " + eval(prodQnty).value + " Bags. Qty is not as per Pack Size.");
		eval(prodQnty).value = "";
		eval(prodQnty).focus();
		return false;
	}
	return true;
}

function repoCtPkDcCHng(numbRows)
{
	a = eval("document.<%=formName%>.prdCodMk" + numbRows).options[eval("document.<%=formName%>.prdCodMk" + numbRows).selectedIndex].text;
	b = a.split(" : ");
	document.getElementById("repoCtPk" + numbRows).value = b[1];
}
function mrktMisPrc_Row(branName, prdCodMk, bPriceVl, cPriceVl)
{
//	displErr(branName);
	var numrow1 = getNumRows2();
	var newRow = insertRowBw(document.all.mrktMisPrc);

	var disabFlg = "", 
		docNoStr = "";

	name = "abc1";
	m = insertCellBw(newRow);
	m.innerHTML = "<div class='chkBox'><input type='checkbox' name='" + name + "' value='" + numrow1 + "' onClick='deleter2()'></div>";

	name = "branName" + numrow1;
	m = insertCellBw(newRow);
	m.innerHTML = "<select name='" + name + "' id='" + name + "' class='form-control'><option value='' selected>Select</option><option value='BW'>Birla White</option><option value='JK'>JK</option><option value='AP'>Asian Paint</option><option value='BG'>Berger</option><option value='Ot'>Others</option>";

	name = "prdCodMk" + numrow1;
	m = insertCellBw(newRow); //wcHgstSlStr
	m.innerHTML = "<select name='" + name + "' id='" + name + "' class='form-control' onChange='return repoCtPkDcCHng(" + numrow1 + ")'><%=wcHgstSlStr%></select> ";

	name = "bPriceVl" + numrow1;
	m = insertCellBw(newRow);
	m.innerHTML = "<input type='text'  class='form-control' class='form-control' placeholder='Enter Amount' name='" + name + "' id='" + name + "' value='" + bPriceVl + "' data-mini='true' size='4' maxlength='7' title='in MT'>";
	
	name = "cPriceVl" + numrow1;
	m = insertCellBw(newRow);
	m.innerHTML = "<input type='text'  class='form-control' class='form-control' placeholder='Enter Amount' name='" + name + "' id='" + name + "' value='" + cPriceVl + "' data-mini='true' size='4' maxlength='7' title='in MT'>";
	 
	m.innerHTML += "<input type='hidden' name='srNumMrktMis' value=" + numrow1 + ">";
	m.innerHTML += "<input type='hidden' name='repoCtPk" + numrow1 + "'  id='repoCtPk" + numrow1 + "' value=''>";
	if(branName != "")
	{
		eval("document.<%=formName%>.branName" + numrow1).value = branName;
		eval("document.<%=formName%>.prdCodMk" + numrow1).value = prdCodMk;
		eventFireBw("onchange", eval("document.<%=formName%>.prdCodMk" + numrow1));
	}
	if($("select").select2 != null)
		$("select").select2();
}

function addrow(repoCatg, prodCode, prodQnty, projQnty, actnRemk, targetDt)
{
	var numrows = getNumRows();
	//var newRow = insertRowBw(document.all.prjTable);

	var disabFlg = "", 
		docNoStr = "";
	var addRowData = "<div class='card mb-2 p-5 child_div' ><div class='form-row'>";

	name = "abc1";
	addRowData += "<input type='hidden' class='form-control-check mx-1 fs-6 fw-bold-Custm mb-2 remove_field' name='" + name + "' id='" + name + "' value='" + numrows + "'>";
	addRowData += "<div class='form-group col-md-2 col-3'><label class='fs-6 fw-bold-Custm custmLabl mb-2'>Sr No</label><br> " + numrows + "</div>";

	//m.innerHTML = "<div class='chkBox'><input type='checkbox' name='" + name + "' value='" + numrows + "' onClick='deleter1()'></div>";
	addRowData += "<input type='hidden' name='catgPkPr" + numrows + "' id='catgPkPr" + numrows + "' value=''>"; 
	addRowData += "<input type='hidden' name='secnPack" + numrows + "' id='secnPack" + numrows + "' value=''>"; 
	addRowData += "<input type='hidden' name='secNoTon" + numrows + "' id='secNoTon" + numrows + "' value=''>"; 

	name = "repoCatg" + numrows;
	addRowData += "<div class='form-group col-md-4 col-9'><label class='fs-6 fw-bold-Custm custmLabl mb-2'>Product</label><select name='" + name + "' id='" + name + "' value=" + repoCatg + " class='form-control' data-live-search='true' onChange='prodRateGet(true, " + numrows + ")'><%=MrktgSuper.getRepCatgDesc(repoCatg, true)%></select></div>";
	
	name = "prodCode" + numrows;
	// onChange=\"priceDataDwnld(" + numrows + ")\"						 
	addRowData += "<div class='form-group col-md-4 col-12'><label class='fs-6 fw-bold-Custm custmLabl mb-2'>Product SKU</label><select name='" + name + "' id='" + name + "' value='" + prodCode + "' onChange='repoDescChng('', " + numrows + ", 'A')' class='form-control' ><option>Select</option></select></div>";

	name = "prodQnty" + numrows;
	addRowData += "<div class='form-group col-md-4 col-8'><label class='fs-6 fw-bold-Custm custmLabl mb-2'>Qty (in Beg)</label><input type='tel' onChange='repoDescChng(" + numrows + ")' class='form-control' placeholder='Enter Qty in Bags' name='" + name + "' id='" + name + "' value='" + prodQnty + "' data-mini='true' size='4' maxlength='7' title='in Bags'> <p>Qty in MT : <div id='prdQtMt"  + numrows + "'></div></p></div>";
	

	name = "projQnty" + numrows;
	addRowData += "<input type='hidden' class='col-12  mx-sm-12s' name='" + name + "' id='" + name + "' value='" + projQnty + "' data-mini='true' size='4' maxlength='7' title='in MT'>";

	addRowData += "<input type='hidden' name='actnRemk" + numrows + "' value=''>";

//		m = insertCellBw(newRow);
	addRowData += "<input type='hidden' name='targetDt" + numrows + "' value=''>";
	addRowData += "<input type='hidden' name='serNumbr' value=" + numrows + ">";
	addRowData += "<div class='form-group col-md-2 col-4'><label>Delete</label><br><input class='btn btn-secondary deleteButton' type='button' value='Del' /></div>";
	addRowData += "</div></div>";
	$("#addblock").before(addRowData);

	if("<%=procType%>" == "U" || "<%=procType%>" == "D")
	{
		eval("document.<%=formName%>.repoCatg" + numrows).value = repoCatg;
		eventFireBw("onchange", eval("document.<%=formName%>.repoCatg" + numrows));
		eval("document.<%=formName%>.prodCode" + numrows).value = prodCode;
		eventFireBw("onchange", eval("document.<%=formName%>.prodQnty" + numrows));
	}
	if($("select").select2 != null)
		$("select").select2();
}

$(document).on("click", ".deleteButton", function() 
{
	if(document.<%=formName%>.abc1.length != null)
	{
		if(document.<%=formName%>.abc1.length == 1)
		{
			alert("Can't Delete Last Row");
			return false;
		}
		else
		{
			$(this).closest('.child_div').remove();
			
		}
	}
	else
	{
		alert("Can't Delete Last Row");
		return false;
	}
});



/* Gift Distribution Addrow Start */
function addrowGf(mrtlCode, isueQnty)
{
	var numrows = getNumRows();


	var addRowData = "<div class='card mb-2 p-5 child_div' ><div class='form-row'>";

	name = "abc1";
	addRowData += "<input type='hidden' class='form-control-check mx-1 fs-6  fw-bold fw-bold-Custm mb-2 remove_field' name='" + name + "' id='" + name + "' value='" + numrows + "'>";
	//addRowData += "<div class='form-group col-md-2 col-3'><label class='fs-6 fw-bold fw-bold-Custm custmLabl mb-2'>Sr No</label><br> " + numrows + "</div>";

	
	name = "mrtlCode" + numrows;					 
	addRowData += "<div class='form-group col-md-4 col-12'><label class='fs-6  fw-bold fw-bold-Custm custmLabl mb-2'>Gift Type</label><select name='" + name + "' id='" + name + "' value='" + mrtlCode + "' class='form-control' ><%=gftTyStr%></select></div>";

	name = "isueQnty" + numrows;
	addRowData += "<div class='form-group col-md-4 col-8'><label class='fs-6  fw-bold fw-bold-Custm custmLabl mb-2'>Quantity</label><input type='tel' onChange='repoDescChng(" + numrows + ")' class='form-control' name='" + name + "' id='" + name + "' value='" + isueQnty + "' size='4' maxlength='7' ></div>";
	
	addRowData += "<input type='hidden' name='serNumGf' value=" + numrows + ">";
	addRowData += "<div class='form-group col-md-2 col-4 fw-bold gap'><label class='fs-6 fw-bold mb-2'>Delete</label><br><input class='btn btn-primary deleteButton' type='button' value='Del' /></div>";
	addRowData += "</div></div>";
	$("#addblock1").before(addRowData);

	if("<%=procType%>" == "U" || "<%=procType%>" == "D")
	{
		eval("document.<%=formName%>.mrtlCode" + numrows).value = mrtlCode;
		eventFireBw("onchange", eval("document.<%=formName%>.mrtlCode" + numrows));
		eval("document.<%=formName%>.isueQnty" + numrows).value = isueQnty;
		//eventFireBw("onchange", eval("document.<%=formName%>.isueQnty" + numrows));
	}
	if($("select").select2 != null)
		$("select").select2();
}

$(document).on("click", ".deleteButton", function() 
{
	if(document.<%=formName%>.abc1.length != null)
	{
		if(document.<%=formName%>.abc1.length == 1)
		{
			alert("Can't Delete Last Row");
			return false;
		}
		else
		{
			$(this).closest('.child_div').remove();
			
		}
	}
	else
	{
		alert("Can't Delete Last Row");
		return false;
	}
});

/* Gift distribution addrow end*/


/***
function addrow(repoCatg, prodCode, prodQnty, projQnty, actnRemk, targetDt)
{
	var numrows = getNumRows();
	var newRow = insertRowBw(document.all.prjTable);

	var disabFlg = "", 
		docNoStr = "";

	name = "abc1";
	m = insertCellBw(newRow);
	m.innerHTML = "<div class='chkBox'><input type='checkbox' name='" + name + "' value='" + numrows + "' onClick='deleter1()'></div>";
	m.innerHTML += "<input type='hidden' name='catgPkPr" + numrows + "' id='catgPkPr" + numrows + "' value=''>"; 
	m.innerHTML += "<input type='hidden' name='secnPack" + numrows + "' id='secnPack" + numrows + "' value=''>"; 
	m.innerHTML += "<input type='hidden' name='secNoTon" + numrows + "' id='secNoTon" + numrows + "' value=''>"; 

	name = "repoCatg" + numrows;
	m = insertCellBw(newRow);
	m.innerHTML = "<select name='" + name + "' id='" + name + "' value=" + repoCatg + " class='form-control' data-live-search='true' onChange='prodRateGet(true, " + numrows + ")'><%=MrktgSuper.getRepCatgDesc(repoCatg, true)%></select>";

	name = "prodCode" + numrows;
	m = insertCellBw(newRow);	// onChange=\"priceDataDwnld(" + numrows + ")\"						 
	m.innerHTML = "<select name='" + name + "' id='" + name + "' value='" + prodCode + "' onChange='repoDescChng('', " + numrows + ", 'A')' class='form-control' ><option>Select</option></select>";

	name = "prodQnty" + numrows;
	m = insertCellBw(newRow);
	m.innerHTML = "<input type='tel' onChange='repoDescChng(" + numrows + ")' class='form-control' placeholder='Enter Qty in Bags' name='" + name + "' id='" + name + "' value='" + prodQnty + "' data-mini='true' size='4' maxlength='7' title='in Bags'> <p>Qty in MT : <div id='prdQtMt"  + numrows + "'></div></p>";
	
	name = "projQnty" + numrows;
	m.innerHTML += "<input type='hidden' class='col-12  mx-sm-12s' name='" + name + "' id='" + name + "' value='" + projQnty + "' data-mini='true' size='4' maxlength='7' title='in MT'>";

	m.innerHTML += "<input type='hidden' name='actnRemk" + numrows + "' value=''>";

//		m = insertCellBw(newRow);
	m.innerHTML += "<input type='hidden' name='targetDt" + numrows + "' value=''>";
	m.innerHTML += "<input type='hidden' name='serNumbr' value=" + numrows + ">";

	if("<%=procType%>" == "U" || "<%=procType%>" == "D")
	{
		eval("document.<%=formName%>.repoCatg" + numrows).value = repoCatg;
		eventFireBw("onchange", eval("document.<%=formName%>.repoCatg" + numrows));
		eval("document.<%=formName%>.prodCode" + numrows).value = prodCode;
		eventFireBw("onchange", eval("document.<%=formName%>.prodQnty" + numrows));
	}
	if($("select").select2 != null)
		$("select").select2();
}  
***/
function prodRateGet(reinit, varNumRw)
{
	if (document.<%=formName%>.areaCode.value != "")
	{
		var wherList = "", plantCod ="";
			plantCod = "FBW";

	//	wherList = whereAdd(wherList, "SW_01", plantCod);
		wherList = whereAdd(wherList, "SW_03", eval("document.<%=formName%>.repoCatg" + varNumRw).value);	
		rtnValue = sapProdStr('<%=formName%>', 'repoCatg' + varNumRw, 'T', wherList, 'prodCode' + varNumRw, 'DY');
	//	displErr(rtnValue);
		$("#prodCode" + varNumRw).select2();

//		$("#prodCode" + varNumRw).trigger('change');
   }
   else
   {
	   displErr("Please select Sales Area");   
   }
   return true;
}
function addrowMrkShr(repoCatgMk, repoDescMk, prodQntyMk, projQntyMk, actnRemkMk, targetDtMk)
{
	var numrows = getNumRows();
	var newRow = insertRowBw(document.all.prjTableMekt);

	var disabFlg = "", 
		docNoStr = "";

	if(repoCatgMk != "")
		disabFlg = " disabled ";

		name = "abc2";
		m = insertCellBw(newRow);
		m.innerHTML = "<div class='chkBox'><input type='checkbox' name='" + name + "' value='" + numrows + "' " + disabFlg + "></div>";
		m.innerHTML += "<input type='hidden' name='repoCatgMk" + numrows + "' value='" + repoCatgMk + "'>"; 

		m = insertCellBw(newRow);
		m.innerHTML = repoDescMk; 

		name = "prodQntyMk" + numrows;
		m = insertCellBw(newRow);
		m.innerHTML = "<input type='number'  class='col-12  mx-sm-12' name='" + name + "' id='" + name + "' value='" + prodQntyMk + "' data-mini='true' size='4' maxlength='7' title='in MT'>";


		name = "projQntyMk" + numrows;
		m = insertCellBw(newRow);
		m.innerHTML = "<input type='number' class='col-12  mx-sm-12' name='" + name + "' id='" + name + "' value='" + projQntyMk + "' data-mini='true' size='4' maxlength='7' title='in MT'>";

//		m = insertCellBw(newRow);
		m.innerHTML += "<input type='hidden' name='actnRemkMk" + numrows + "' value=''>";

//		m = insertCellBw(newRow);
		m.innerHTML += "<input type='hidden' name='targetDtMk" + numrows + "' value=''>";
	
//		m = insertCellBw(newRow);
		m.innerHTML += "<input type='hidden' name='serNumMk' value=" + numrows + ">";
}

function addrowMrkPrv(repoCatgPr, repoDescPr, prodQntyPr, projQntyPr, mrtkDatePr)
{
	var numrows = getNumRows();
	var newRow = insertRowBw(document.all.prjTablePrv);

		m = insertCellBw(newRow);
		m.innerHTML = repoDescPr; 

		m = insertCellBw(newRow);
		m.innerHTML = prodQntyPr; 

		m = insertCellBw(newRow);
		m.innerHTML = projQntyPr; 

		m = insertCellBw(newRow);
		m.innerHTML = mrtkDatePr; 
}

function deleter1()
{
	deleterCv("<%=formName%>", "abc1", "prjTable", hdRowCnt);
}
function deleter2()
{
	deleterCv("<%=formName%>", "abc1", "mrktMisPrc", hdRowCnt);
}

$(function()
{

    // Opera 8.0+
    var isOpera = (!!window.opr && !!opr.addons) || !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0;

    // Firefox 1.0+
    var isFirefox = typeof InstallTrigger !== 'undefined';

    // Safari 3.0+ "[object HTMLElementConstructor]" 
    var isSafari = /constructor/i.test(window.HTMLElement) || (function (p) { return p.toString() === "[object SafariRemoteNotification]"; })(!window['safari'] || safari.pushNotification);

    // Internet Explorer 6-11
    var isIE = /*@cc_on!@*/false || !!document.documentMode;

    // Edge 20+
    var isEdge = !isIE && !!window.StyleMedia;

    // Chrome 1+
    var isChrome = !!window.chrome && !!window.chrome.webstore;
        // Blink engine detection
	$("#cusRtlFl").change(function()
	{
	//	displErr("1");
		document.<%=formName%>.cusRtlCd.value = '';
		custCdRtArr = "";
		cusRtlCdArr = "";
	});

	$("#areaCode").change(function()
	{
	//	displErr("1");
		document.<%=formName%>.cusRtlCd.value = '';
		custCdRtArr = "";
		cusRtlCdArr = "";
	});

}); 

function enbDsbl()
{
	if(document.<%=formName%>.pendIsue.value == "Y")
	{
		enableDisable("pndIsuDt", "E", false, true);
		enableDisable("isuDetal", "E", false, true);
		$("select").select2();
	}
	else
	{
		enableDisable("pndIsuDt", "D", false, true);
		enableDisable("isuDetal", "D", false, true);
		$("select").select2();
	}

}
function enabDisb() 
{
	var enabDsFl = "";
	
	if(<%=cusCodRq%>) 
		enabDsFl = "E";
	else
		enabDsFl = "D";

	//displErr(enabDsFl);
	//enableDisable("areaCode", enabDsFl, false, true);
	//enableDisable("cusRtlFl", enabDsFl, false, true);
//	enableDisable("docuDate", enabDsFl, false, true);
	readonly("cusRtlCd", enabDsFl, false, true);
	//document.<%=formName%>.cusRtlFl.value = '';
	//document.<%=formName%>.areaCode.value = ''; // To check Value Initialized ni displaying in Front End
	
	$("#cusRtlCd").addClass("");

	if(<%=docuDtRq%>) 
	{
		enabDsFl = "D";
//	displErr(1);
	//	document.<%=formName%>.docuDate.value = <%=docuDate%>;
//		enableDisable("docuDate", enabDsFl, false, false);
	}
}


function edValueKeyPressCust() 
{
    var edValue = document.getElementById("cusRtlCd").value.length;
//	displErr(edValue);
	if(edValue > 3)
		cusRtlCdHlpget('G');
}

</script>

<form name="<%=formName%>">
<%
if(dsrEntAl && dsrStkAl)
{
%>
		<input type="hidden" size="24" value="<%=sysDateOnly%>" name="sysDateOnly" >
		<input type="hidden" name="deptCode" value="<%=deptCode%>">
		<input type="hidden" name="formName" value="<%=formName%>">
		<input type="hidden" name="pendWith" value="<%=pendWith%>">
		<input type="hidden" name="submMthd" value="">
<%

	if(!cusRtlCd.equals(""))
	{
		sql = "select a.retlCode, a.retlName, a.mobileNo, a.custCode, a.sapRtlCd, "
			+ "isnull(a.locaCapr, 'NA') as locaCapr, isnull(a.latitute, 'NA') as latitute, "
			+ "isnull(a.lgtitute, 'NA') as lgtitute, case when isNull(kycVerFl, 'N') <> 'Y' then 'N' else kycVerFl end as kycVerFl, ISNULL(mrktName, '') "
			+ " From rtmRetailer a with (nolock) "
			+" where isActive = 'Y' "			   
			+" and   retlCode = '" + cusRtlCd + "' "
			+" union all select a.custCode, a.custName, a.mobileNo, a.custCode, a.sapCusCd, "
			+ "isnull(a.locaCapr, 'NA') as locaCapr, isnull(a.latitute, 'NA') as latitute, "
			+ "isnull(a.lgtitute, 'NA') as lgtitute, 'Y' as kycVerFl, ISNULL(mrktName, '') "
			+ " From dpmCustomer a with (nolock) "
			+" where isActive = 'Y' "
			+" and   custCode = '" + cusRtlCd + "'";
		rset = WebSessBean.selectRecord(sql);
		
		if (rset.next())
		{
			cusRtlCd = rset.getString(1);
			cusRtlNm = rset.getString(2);
			mobileNo = rset.getString(3);
			locaCapr = rset.getString(6);
			latitute = rset.getString(7);
			lgtitute = rset.getString(8);
			kycVerFl = rset.getString(9);
			mrktName = rset.getString(10);
		}	

		if(!mrktName.equals(""))
		{
			mktNamUF = "N";
		}

		if(cusRtlFl.equals("R") || cusRtlFl.equals("RR"))	
		{		
			//sql = "select 0 ,0, 0";
			/*	*/
			sql = "select  isnull(sum(case when mrgRepCt = '01' then salesQty else 0 end), 0)/3 as wc, "
				+" 		isnull(sum(case when mrgRepCt = '02' then salesQty else 0 end), 0)/3 as wcp, "
				+" 		isnull(sum(case when mrgRepCt = '03' then salesQty else 0 end), 0)/3 as vap "
				+" From sbvTlySlsDt with (nolock) "
				+" where retlCode = '" + cusRtlCd + "' "
				+" and rtlInvDt between convert(varchar(11), dateadd(mm, -4,dateadd(dd, +1, eomonth(getdate()))), 106) and convert(varchar(11), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 113) ";
				
		}
		else 
		{
			sql =" select isnull(sum(case when mrgRepCt = '01' then invnQnty else 0 end), 0)/3 as wc, "
				+"	   isnull(sum(case when mrgRepCt = '02' then invnQnty else 0 end), 0)/3 as wcp, "
				+"	   isnull(sum(case when mrgRepCt = '03' then invnQnty else 0 end), 0)/3 as vap	"
				+"from dpsCustSlDt a with (nolock), bkmProducts b with (nolock), bkmRepoCatg c with (nolock) "
				+"where  a.prodCode = b.prodCode "
				+"and    b.repoCatg = c.repoCatg "
				+"and    a.invMnTyp = 'NS'		 "
				+"and    a.invDocDt between convert(varchar(11), dateadd(mm, -4,dateadd(dd, +1, eomonth(getdate()))), 106) and convert(varchar(11), DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, getdate()), 0)), 113) "
				+"and    a.custCode = '" + cusRtlCd + "'";
		}	
		rset = WebSessBean.selectRecord(sql);
		
		if (rset.next())
		{
			bwAvgWcc = rset.getString(1);
			bwAvgWcp = rset.getString(2);
			bwAvgVap = rset.getString(3);

			if(bwAvgWcc.equals(""))
				bwAvgWcc = "0.00";
			if(bwAvgWcp.equals(""))
				bwAvgWcp = "0.00";
			if(bwAvgVap.equals(""))
				bwAvgVap = "0.00";
		}
		else
		{
			bwAvgWcc = "0.00";
			bwAvgWcp = "0.00";
			bwAvgVap = "0.00";	
		}
		
		/** Current Month **/
		if(cusRtlFl.equals("R") || cusRtlFl.equals("RR"))	
		{		
			//sql = "select 0 ,0, 0";
			/*	*/
			sql = "select  isnull(sum(case when mrgRepCt = '01' then salesQty else 0 end), 0) as wc, "
				+" 		isnull(sum(case when mrgRepCt = '02' then salesQty else 0 end), 0) as wcp, "
				+" 		isnull(sum(case when mrgRepCt = '03' then salesQty else 0 end), 0) as vap "
				+" From sbvTlySlsDt with (nolock) "
				+" where retlCode = '" + cusRtlCd + "' "
				+" and rtlInvDt between convert(varchar(11), dateadd(mm, -1,dateadd(dd, +1, eomonth(getdate()))), 113) and convert(varchar(11), getdate(), 113) ";
				
		}
		else 
		{
			sql =" select isnull(sum(case when mrgRepCt = '01' then invnQnty else 0 end), 0) as wc, "
				+"	   isnull(sum(case when mrgRepCt = '02' then invnQnty else 0 end), 0) as wcp, "
				+"	   isnull(sum(case when mrgRepCt = '03' then invnQnty else 0 end), 0) as vap	"
				+"from dpsCustSlDt a with (nolock), bkmProducts b with (nolock), bkmRepoCatg c with (nolock) "
				+"where  a.prodCode = b.prodCode "
				+"and    b.repoCatg = c.repoCatg "
				+"and    a.invMnTyp = 'NS'		 "
				+"and    a.invDocDt between convert(varchar(11), dateadd(mm, -1,dateadd(dd, +1, eomonth(getdate()))), 113) and convert(varchar(11), getdate(), 113) "
				+"and    a.custCode = '" + cusRtlCd + "'";
		}	
		rset = WebSessBean.selectRecord(sql);
		
		if (rset.next())
		{
			bwCurWcc = rset.getString(1);
			bwCurWcp = rset.getString(2);
			bwCurVap = rset.getString(3);

			if(bwCurWcc.equals(""))
				bwCurWcc = "0.00";
			if(bwCurWcp.equals(""))
				bwCurWcp = "0.00";
			if(bwCurVap.equals(""))
				bwCurVap = "0.00";
		}
		else
		{
			bwCurWcc = "0.00";
			bwCurWcp = "0.00";
			bwCurVap = "0.00";	
		}

			//sql = "select 0 ,0, 0";
			/* */
/*
		sql = "select  sum(case when b.mrgRepCt = '01' then stockQty else 0 end) wc01, "
			+ "		sum(case when b.mrgRepCt = '02' then stockQty else 0 end) wc02, "
			+ "		sum(case when b.mrgRepCt = '03' then stockQty else 0 end) wc03 "
			+ "From sbvCustStck a with (nolock), bkmRepoCatg b with (nolock) "
			+ "where   a.repoCatg = b.repoCatg "
			+ "and     a.custCode = '" + cusRtlCd + "'";
			
		rset = WebSessBean.selectRecord(sql);
		if(rset.next())
		{
			bwStkWcc = rset.getString(1);
			bwStkWcp = rset.getString(2);
			bwStkVap = rset.getString(3);
		}
		else
		{
			bwStkWcc = "0.00";	
			bwStkWcp = "0.00";
			bwStkVap = "0.00";	
		}
		*/
			bwStkWcc = "0.00";	
			bwStkWcp = "0.00";
			bwStkVap = "0.00";	
	}

if(!mobilApp && (dsrParam.equals("50") || dsrParam.equals("01")))
{
%>
   		<div class="notice d-flex bg-light rounded border-primary border border-dashed mb-10 p-4">
			Dear User:  You can not submit Retailer / Stockiest Visit on Desktop application. Please download Birla white SPARSH Mobile App from Play store .
		</div>
<%
}
else
{
%>
<div class="row gy-5 g-xl-10">
	<div class="col-xl-6">
		<div class="card card-xl-stretch">
			<div class="card-header border-0">
				<h3 class="card-title align-items-start flex-column">
					<span class="card-label fw-bolder fs-3 mb-1">Basic Details</span>
				</h3>
				<div class="card-toolbar"></div>
			</div>
			<div class=" pt-2 p-4">
				<div class="row">
					<div class="col-xl-6">
						<div class="d-flex flex-column mb-8 fv-row">
							<!--begin::Label-->
							<label class="d-flex align-items-start fs-5 fw-bold mb-2">
								<span class="required">Process Type</span>
							</label>
							<div class="align-items-start fs-5 fw-bold mb-2">
								<label class="check"> 
									<input type="radio" name="procType" id="procType" value="A" onClick="return refreshed('A')"> <span>Add</span> 
								</label>																	   
								<label class="check"> <input type="radio" name="procType" id="procType" onClick="return refreshed('A')" value="U"> <span>Update</span> </label> 
								<label class="check"> <input type="radio" name="procType" id="procType" onClick="return refreshed('A')" value="D"> <span>Delete</span> </label> 
							</div>
						</div>
					</div>			
<%
	if(procType.equals("U") || procType.equals("D"))
	{
		if(zoneCode.equals("N"))
		{
%>
			<div class="col-xl-6">
				<div class="d-flex flex-column mb-8 fv-row">
					<label class="d-flex align-items-center fs-5 fw-bold mb-2"  for="docuNumb" class="select">Document No*</label>
					<select name="docuNumb" class=" selectpicker"  data-live-search="true" id="docuNumb" onchange="return refreshed('A')"><%=WebSessBean.getSqlToOptionStr(" select docuNumb, dbo.wcfParamDes(dsrParam, 'dsrParNw')+ ' ~ ' + docuNumb + ' ~ ' + convert(char(10), docuDate , 103) from dptDSRActvt with (nolock) where createDt > GETDATE() - 4  and createId = '" + loginIdM + "' and statFlag not in ('C', 'R') and dsrParam in ('04','05') order by docuNumb desc ", docuNumb)%></select>
				</div>
			</div>
<%
		}
		else
		{
%>
				<div class="col-xl-6">
					<div class="d-flex flex-column mb-8 fv-row">
						<label class="d-flex align-items-center fs-5 fw-bold mb-2"  for="docuNumb" class="select">Document No*</label>
						<select name="docuNumb" class=" selectpicker"  data-live-search="true" id="docuNumb" onchange="return refreshed('A')"><%=WebSessBean.getSqlToOptionStr(" select distinct top 30 docuNumb, dbo.wcfParamDes(dsrParam, 'dsrParNw')+ ' ~ ' + docuNumb + ' ~ ' + convert(char(10), docuDate , 103) from dptDSRActvt with (nolock) where docuDate > GETDATE() - 4  and createId = '" + loginIdM + "' and statFlag not in ('C', 'R') and dsrParam in ('04','05') order by docuNumb desc ", docuNumb)%></select>
					</div>
				</div>
<%
		}
	}
%>
<!--
	<div class="col-xl-6">
		<div class="form-group">
			<label >Tele Call/Personal Visit</label>
			<div class="card1">
				<label class="check"> 
					<input type="radio" name="dsrParam" id="dsrParam1" value="04" onClick="distancChk()"> <span>Tele Call</span> 
				</label>																	   
				<label class="check"> <input type="radio" name="dsrParam" id="dsrParam2" value="05" onClick="distancChk()"> <span>Personal Visit</span> </label> 
			</div>
		</div>
	</div>			
-->
	<input type="hidden" name="dsrParam" id="dsrParam1" value="05" onClick="distancChk()"> 
					<div class="col-xl-6">
						<div class="d-flex flex-column mb-8 fv-row">
									<label class="d-flex align-items-center fs-5 fw-bold mb-2"  for="cusRtlFl"><%=custLabl%>*:</label>
									<select name="cusRtlFl" id="cusRtlFl" class="" placeholder="<%=custLabl%>" value="<%=cusRtlFl%>"><%=cusRtlFlStr%></select> 
						</div>
					</div>			
					<div class="col-xl-6">
						<div class="d-flex flex-column mb-8 fv-row">
							<label class="d-flex align-items-center fs-5 fw-bold mb-2"  for="areaCode">Area Code*:</label>
							<select name="areaCode"   value="<%=areaCode%>" id="areaCode"><%=WebSessBean.getArDesc(areaCode, true)%></select>
						</div>
					</div>
					<div class="col-xl-6">
						<div class="d-flex flex-column mb-8 fv-row">
							<label class="d-flex align-items-center fs-5 fw-bold mb-2">Code*:</label>
							<div class="input-group mb-3">
								<input type="text" name="cusRtlCd" placeholder="Purchaser Code" id="cusRtlCd" maxlength="8" value="<%=cusRtlCd%>"  onkeyup="edValueKeyPressCust(this.value)" autocomplete='off'   onchange="return refreshed('Y')">
								<div class="input-group-append">
									<input type='button' name='srchcusRtlCd' class="searchBtnApp" onClick = "cusRtlCdHlpLoc('L')" alt="Click for Search"  >
								</div>
							</div>					
						</div>
					</div>
	<input type="hidden" name="mktNamUF" id="mktNamUF" value="<%=mktNamUF%>">
	<script>
		document.<%=formName%>.areaCode.value = "<%=areaCode%>";
		
		$('#cusRtlCd').on('blur', function() {
			refreshed('Y'); 
		});
		$('#cusRtlCd').on('change', function()
		{
			//alert("Change Trigger");
		//	refreshed('Y');
		});
	</script>
				<div id="cusRtlCdDiv" style="display:none"></div>
				<div class="col-xl-6">
					<div class="d-flex flex-column mb-8 fv-row">
							<label class="d-flex align-items-center fs-5 fw-bold mb-2" for="dsrRem08">Name</label>
							<%=cusRtlNm%>
					</div>
				</div>
				<div class="col-xl-6">
					<div class="d-flex flex-column mb-8 fv-row">
					<label class="d-flex align-items-center fs-5 fw-bold mb-2">Click Here to Edit Kyc</label>
						<div class="input-group">
							<span><a type="button" onclick="return openClickWind('/BirlaWhite/Master/Customer/<%=cusRtlFl.equals("R") ? "RetailerEntry" : cusRtlFl.equals("RT") ? "SubDistrEntry" : "CustProfileUpdSelf"%>.jsp?procType=U&areaCode=<%=areaCode%>&<%=cusRtlFl.equals("R") || cusRtlFl.equals("RT") ? "retlCode" : "custCode"%>=<%=cusRtlCd%>')" >
								<input type="button" name="EditKyc" value="Edit KYC" class="btn btn-primary" data-toggle='tooltip' data-placement='bottom' title="Click Here for Edit KYC" >
							</a></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</div>
<div class="col-xl-6" >
	<div class="card card-xl-stretch">
		<div class="card-header border-0">
			<h3 class="card-title align-items-start flex-column">
				<span class="card-label fw-bolder fs-3 mb-1">Details</span>
			</h3>
			<div class="card-toolbar"></div>
		</div>	
		<div class=" pt-2 p-4">
			<div class="row">
			<div class="col-xl-6">
				<div class="d-flex flex-column mb-8 fv-row">
					<label class="d-flex align-items-center fs-5 fw-bold mb-2">KYC Status</label>
					<select name="kycVerFl" id="kycVerFl" class="form-control" disabled><%=WebSessBean.getYesNo(kycVerFl, true)%></select >
				</div>
			</div>
			<div class="col-xl-6">
				<div class="d-flex flex-column mb-8 fv-row">
					<label class="d-flex align-items-center fs-5 fw-bold mb-2" for="docuDate">Report Date*</label>
					<input type="text" readonly="true"  name="docuDate" id="docuDate"  class="" size="24" value="<%=docuDate%>" onfocus='showCal("<%=formName%>","docuDate")' onChange="return docuDateChkLoc()" >
					<div id="docuDateDiv"></div>
				</div>
			</div>
<!-- 	<div class="col-xl-6">
		<div class="d-flex flex-column mb-8 fv-row">
				 <label class="d-flex align-items-center fs-5 fw-bold mb-2">
						<span class="required">KYC Status</span>
					</label>
					<div class="input-group input-group-solid mb-5">
						<select name="kycVerFl" id="kycVerFl" class="form-control" disabled><%=WebSessBean.getYesNo(kycVerFl, true)%></select >
						<span class="input-group-text cursor-pointer" >
							<a type="button" onclick="return openClickWind('/BirlaWhite/Master/Purchaser/<%=cusRtlFl.equals("R") ? "RetailerEntry" : cusRtlFl.equals("RT") ? "SubDistrEntry" : "CustProfileUpdSelf"%>.jsp?procType=U&areaCode=<%=areaCode%>&<%=cusRtlFl.equals("R") || cusRtlFl.equals("RT") ? "retlCode" : "custCode"%>=<%=cusRtlCd%>')" >
							<i class="fas fa-edit fs-4" name="srchdocuNumb"   onClick="openLupLoc()" title="Click here to Look-up Document Number"></i></a>
						</span>
					</div>
				
			</div>
	</div> -->
			<div class="col-xl-6">
				<div class="d-flex flex-column mb-8 fv-row">
					<label class="d-flex align-items-center fs-5 fw-bold mb-2">Market Name (Location Or Road Name)*</label>
					<input type="text" name="mrktName" id="mrktName" value="<%=mrktName%>" title="Please Enter Correct You can not Edit Next time" <%=mrktName.equals("") ? "" : " disabled"%> placeholder="Market Name">
				</div>
			</div>
			<div class="col-xl-6">
				<div class="d-flex flex-column mb-8 fv-row">
					<!--begin::Label-->
					<label class="d-flex align-items-start fs-5 fw-bold mb-2">
						<span class="required">Participation of Display Contest*</span>
					</label>
					<div class="d-felx check1">
						<label class="check"> <input type="radio" name="prtDsCnt" value="Y" id="prtDsCnt" onclick="enbDsbl(this)"> <span>Yes</span> </label>
						<label class="check"> <input type="radio" name="prtDsCnt" value="N" id="prtDsCnt" onclick="enbDsbl(this)"> <span>No</span> </label> 
						<label class="check"> <input type="radio" name="prtDsCnt" value="N" id="prtDsCnt" onclick="enbDsbl(this)"> <span>NA</span> </label> 
					</div>
				</div>
			</div>
			<div class="col-xl-6">
				<div class="d-flex flex-column mb-8 fv-row">
				<label class="d-flex align-items-center fs-5 fw-bold mb-2">Any Pending Issues(Yes /No)* </label>
				   <div class="d-felx">
					   <div class="check1">
							<label class="check"> <input type="radio" name="pendIsue" value="Y" id="pendIsue" onclick="enbDsbl(this)"> <span>Yes</span> </label>
							<label class="check"> <input type="radio" name="pendIsue" value="N" id="pendIsue" onclick="enbDsbl(this)"> <span>No</span> </label> 
						</div>
				   </div>
				</div>
			</div>
			<div class="col-xl-6">
				<div class="d-flex flex-column mb-8 fv-row">
						<label class="d-flex align-items-center fs-5 fw-bold mb-2">if Yes, pending issue details*</label>
						<select name="pndIsuDt" id="pndIsuDt" value="<%=pndIsuDt%>" disabled class="form-control"><%=WebSessBean.getSqlToOptionStr("select 'T', 'Token' union all select 'S', 'Scheme' union all select 'P', 'Product' union all select 'O', 'Other' ", pndIsuDt)%></select >
				</div>
			</div>
			<div class="col-xl-6">
				<div class="d-flex flex-column mb-8 fv-row">
						<label class="d-flex align-items-center fs-5 fw-bold mb-2">if Yes, Specify Issue</label>
					<input type="text" name="isuDetal" id="isuDetal" value="<%=isuDetal%>" disabled>
				</div>
			</div>
		</div>
		</div>
	</div>
</div>
<%
if((procType.equals("U")  || procType.equals("D")) && !docuNumb.equals(""))
{
	sql = "select  prodQnty, projQnty, prodQtyV "
		+ "from     dptDSRActvtDtl a  with (nolock) "
		+" where    docuNumb = '" + docuNumb + "' "
		+ "and		createId = '" + loginIdM + "' "
		+ "and		mrktData = '01' ";
		rset = WebSessBean.selectRecord(sql);
	if(rset.next())
	{
		wcErlSlb = rset.getString(1);
		wpErlSlb = rset.getString(2);
		vpErlSlb = rset.getString(3);
	}
	sql = "select   prodQnty, projQnty, prodQtyV "
		+ "from     dptDSRActvtDtl a  with (nolock) "
		+" where    docuNumb = '" + docuNumb + "' "
		+ "and		createId = '" + loginIdM + "' "
		+ "and		mrktData = '02' ";
	rset = WebSessBean.selectRecord(sql);
	if(rset.next())
	{
		bwStkWcc = rset.getString(1);
		bwStkWcp = rset.getString(2);
		bwStkVap = rset.getString(3);
	}
	else
	{
		bwStkWcc = "0.00";	
		bwStkWcp = "0.00";
		bwStkVap = "0.00";	
	}
}
%>
<div class="col-xl-6">
	<div class="card card-xl-stretch">
		<div class="">
			<div class="row">
				<div class="col-xl-12">
					<div class="form-group">
						<label>Enrolment Slab (in MT)*	</label>
						 <div class="row p-4">
							<div class="col-4 mb-1 form-label-group"> 
								<input type="number" name="wcErlSlb" id="wcErlSlb" value="<%=wcErlSlb%>" class="input-field"  tooltip="WC"> 
								<label for="wcErlSlb">WC</label>
							</div>
							<div class="col-4 mb-1 form-label-group"> 
								<input type="number" name="wpErlSlb" id="wpErlSlb" value="<%=wpErlSlb%>" class="input-field"  tooltip="WC"> 
								<label for="wpErlSlb">WCP</label>
							</div>
							<div class="col-4 mb-1 form-label-group"> 
								<input type="number" name="vpErlSlb" id="vpErlSlb" value="<%=vpErlSlb%>" class="input-field"  tooltip="WC"> 
								<label for="vpErlSlb">VAP</label>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xl-12">
					<div class="form-group">
						<label>BW Stocks Availability (in MT)*</label>
						 <div class="row">
							<div class="col-4 mb-1 form-label-group"> 
								<input type="number" name="bwStkWcc" id="bwStkWcc" value="<%=bwStkWcc%>" class="input-field"  tooltip="WC" <%=cusRtlFl.equals("C") || cusRtlFl.equals("RD") ? " disabled" : ""%>> 
								<label for="bwStkWcc">WC</label>
							</div>
							<div class="col-4 mb-1 form-label-group"> 
								<input type="number" name="bwStkWcp" id="bwStkWcp" value="<%=bwStkWcp%>" class="input-field"  tooltip="WC" <%=cusRtlFl.equals("C") || cusRtlFl.equals("RD") ? " disabled" : ""%>> 
								<label for="bwStkWcp">WCP</label>
							</div>
							<div class="col-4 mb-1 form-label-group"> 
								<input type="number" name="bwStkVap" id="bwStkVap" value="<%=bwStkVap%>" class="input-field"  tooltip="WC" <%=cusRtlFl.equals("C") || cusRtlFl.equals("RD") ? " disabled" : ""%>> 
								<label for="bwStkVap">VAP</label>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="col-xl-6" id="wcIndustry">
	<div class="card card-xl-stretch p-6">
		<div class="">
			<div class="row">
				<div class="col-xl-12">
					<label>Brands selling - WC(Industry Volume) (in MT)*</label>
					<div class="card1">
						<label class="check"> <input type="checkbox" name="brndSlWc" value="BW"> <span>BW</span> </label>
						<label class="check"> <input type="checkbox" name="brndSlWc" value="JK"> <span>JK</span> </label> 
						<label class="check"> <input type="checkbox" name="brndSlWc" value="RK"> <span>RAK</span> </label> 
						<label class="check"> <input type="checkbox" name="brndSlWc" value="OT"> <span>Other</span></label> 
					</div>
					<br>
					<input type="text" name="slWcVlum" value="" Placeholder="WC Industry Volume in (MT)">
				</div>
				<div class="col-xl-12" id="wcpIndustry">
					<label>Brands selling - WCP(Industry Volume)*</label>
					<div class="card1">
						<label class="check"> <input type="checkbox" name="brndSlWp" value="BW"  onClick="return hgtSlgSkuCp('BW')"> <span>BW</span> </label>
						<label class="check"> <input type="checkbox" name="brndSlWp" value="JK" onClick="return hgtSlgSkuCp('JK')"> <span>JK</span> </label> 
						<label class="check"> <input type="checkbox" name="brndSlWp" value="AP" onClick="return hgtSlgSkuCp('ASIAN')"> <span>Asian Paints</span> </label> 
						<label class="check"> <input type="checkbox" name="brndSlWp" value="BG" onClick="return hgtSlgSkuCp('BERGER')"> <span>Berger</span> </label> 						
						<label class="check"> <input type="checkbox" name="brndSlWp" value="AC" onClick="return hgtSlgSkuCp('Oth')"> <span>Aerocon</span> </label> 
						<label class="check"> <input type="checkbox" name="brndSlWp" value="PM" onClick="return hgtSlgSkuCp('Oth')"> <span>Paint Major</span> </label> 
						<label class="check"> <input type="checkbox" name="brndSlWp" value="OT" onClick="return hgtSlgSkuCp('Oth')"> <span>Any Other</span> </label> 
					</div>
					<br>
					<input type="text" name="slWpVlum" value="" Placeholder="WCP Industry Volume in (MT)">
				</div>
			</div>
		</div>
	</div>
</div>
<%
if(!cusRtlCd.equals(""))
{
%>
<div class="col-xl-6">
	<div class="card card-xl-stretch p-6 m-3">
		<div class="">
			<div class="row">
				<div class="col-xl-12">
					<div class="form-group">
						<label>Last 3 Months Average - BW (in MT)</label>
						 <div class="row">
							<div class="col-4 mb-1 form-label-group"> 
								<input type="text" id="bwAvgWcc" class="input-field" value="<%=WebSessBean.dfFormat(Double.parseDouble(bwAvgWcc), 2, "0.00")%>" tooltip="WC" readonly> 
								<label for="bwAvgWcc">WC</label>
							</div>
							<div class="col-4 mb-1 form-label-group"> 
								<input type="text" id="bwAvgWcp" name="bwAvgWcp" class="input-field" value="<%=WebSessBean.dfFormat(Double.parseDouble(bwAvgWcp), 2, "0.00")%>"  tooltip="WC" readonly> 
								<label for="bwAvgWcp">WCP</label>
							</div>
							<div class="col-4 mb-1 form-label-group"> 
								<input type="text" id="bwAvgVap" name="bwAvgVap" class="input-field" value="<%=WebSessBean.dfFormat(Double.parseDouble(bwAvgVap), 2, "0.00")%>"  tooltip="WC" readonly> 
								<label for="bwAvgVap">VAP</label>
							</div>
						 </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="col-xl-6">
	<div class="card card-xl-stretch p-6 m-3">
		<div class="">
			<div class="row">
				<div class="col-xl-12">
					<div class="form-group">
						<label>Current Months - BW (in MT)</label>
						 <div class="row">
							<div class="col-4 mb-1 form-label-group"> 
								<input type="text" id="bwCurWcc" class="input-field" value="<%=WebSessBean.dfFormat(Double.parseDouble(bwCurWcc), 2, "0.00")%>" tooltip="WC" readonly> 
								<label for="bwCurWcc">WC</label>
							</div>
							<div class="col-4 mb-1 form-label-group"> 
								<input type="text" id="bwCurWcp" name="bwCurWcp" class="input-field" value="<%=WebSessBean.dfFormat(Double.parseDouble(bwCurWcp), 2, "0.00")%>"  tooltip="WCP" readonly> 
								<label for="bwCurWcp">WCP</label>
							</div>
							<div class="col-4 mb-1 form-label-group"> 
								<input type="text" id="bwCurVap" name="bwCurVap" class="input-field" value="<%=WebSessBean.dfFormat(Double.parseDouble(bwCurVap), 2, "0.00")%>"  tooltip="VAP" readonly> 
								<label for="bwCurVap">VAP</label>
							</div>
						 </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%
}
%>
<div class="col-xl-6" id="lstThrAvg">
	<div class="card card-xl-stretch p-6">
		<div class="">
			<div class="row">
				<div class="col-xl-12">
					<div class="form-group">
						<label>Last 3 Months Average*</label>
						<table id="lstmntAvg">
							<thead>
								<tr>
									<th></th>
									<th>WC Qty</th>
									<th>WCP Qty</th>
								</tr>
							</thead>
<%
	if(procType.equals("U") || procType.equals("D"))
	{
		sql = "select   case when actnRemk like '% - JK' then 'JK' when actnRemk like '% - Asian' then 'Asian' 	else 'Other' end, case when actnRemk like '% - JK' then 'jk' when actnRemk like '% - Asian' then 'as' 	else 'ot' end, prodQnty, projQnty "
			+ "from     dptDSRActvtDtl a  with (nolock) "
			+" where    docuNumb = '" + docuNumb + "' "
			+ "and		createId = '" + loginIdM + "' "
			+ "and		mrktData = '04' ";
		rset = WebSessBean.selectRecord(sql);
		while(rset.next())
		{
%>
							<tr>
								<td><%=rset.getString(1)%></td>
								<td>
									<input type="text" id="<%=rset.getString(2)%>AvgWcc" name="<%=rset.getString(2)%>AvgWcc" class="input-field" PlaceHolder="WC" value="<%=rset.getString(3)%>"> 
								</td>
								<td>
									<input type="text" name="<%=rset.getString(2)%>AvgWcp" id="<%=rset.getString(2)%>AvgWcp" class="input-field" PlaceHolder="WCP" value="<%=rset.getString(4)%>"> 
								</td>
							</tr>
<%
		}
						
	}
	else
	{
%>
							<tr>
								<td>JK</td>
								<td>
									<input type="text" id="jkAvgWcc" name="jkAvgWcc" class="input-field" PlaceHolder="WC" value="0"> 
								</td>
								<td>
									<input type="text" name="jkAvgWcp" id="jkAvgWcp" class="input-field" PlaceHolder="WCP" value="0"> 
								</td>
							</tr>
							<tr>
								<td>Asian</td>
								<td>
									<input type="text" id="asAvgWcc" name="asAvgWcc" class="input-field" PlaceHolder="WC" value="0"> 
								</td>
								<td>
									<input type="text" name="asAvgWcp" id="asAvgWcp" class="input-field" PlaceHolder="WCP" value="0"> 
								</td>
							</tr>
							<tr>
								<td>Other</td>
								<td>
									<input type="text" id="otAvgWcc" name="otAvgWcc" class="input-field" PlaceHolder="WC" value="0"> 
								</td>
								<td>
									<input type="text" name="otAvgWcp" id="otAvgWcp" class="input-field" PlaceHolder="WCP" value="0"> 
								</td>
							</tr>
<%
	}
%>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%
if(!cusRtlCd.equals("") && (cusRtlFl.equals("R") || cusRtlFl.equals("RR") || cusRtlFl.equals("D") || cusRtlFl.equals("AD")))	//	
{
		sql = "select schmName from cdtSchmIntrst where cusRtlcd = '" + cusRtlCd + "' ";
		rset = WebSessBean.selectRecord(sql);
		while (rset.next())
		{
			rplNwScF = rset.getString(1);
		}
		rplNwAlF = "Y";
		rset = WebSessBean.closeRset(rset);
}
%>
<div class="col-xl-6">
	<div class="card card-xl-stretch p-4">
		<div class="">
			<div class="row">
				<div class="col-xl-12 table-responsive">
					<div class="form-group">
						<label>Last Billing date <%=cusRtlFl.equals("R") || cusRtlFl.equals("RR") ? "as per Tally" : ""%></label>
						 <div class="card">
						 <table>
							<thead>
								<tr>
									<th>Product</th>
									<th>Date</th>
									<th>Qty.</th>
								</tr>
							</thead>
<%
if(cusRtlFl.equals("R") || cusRtlFl.equals("RR"))	
{
	//sql = "select '' , '', 0";
	/* */
	sql = "select a.mrgRepDs, convert(varchar(11), a.rtlInvDt, 113) as rtlInvDt, sum(salesQty) as salesQty From sbvTlySlsDt a with (nolock), "
		+"( "
		+"	select mrgRepCt, max(rtlInvDt) as rtlInvDt "
		+"	From sbvTlySlsDt with (nolock) "
		+"	where retlCode = '" + cusRtlCd + "' "
		+"	group by mrgRepCt "
		+") b "
		+"where a.mrgRepCt = b.mrgRepCt "
		+"and   a.rtlInvDt = b.rtlInvDt	"
		+"and   retlCode = '" + cusRtlCd + "' "
		+"group by a.mrgRepDs, a.rtlInvDt "
		+"order by a.rtlInvDt desc";
		
}
else
{
	sql = "select c.mrgRepDs, convert(varchar(11), a.invDocDt, 113) as rtlInvDt, sum(invnQnty) as salesQty  "
		+"from dpsCustSlDt a with (nolock), bkmProducts b with (nolock),  "
		+"	 bkmRepoCatg c with (nolock), "
		+"	 ( "
		+"		select a.custCode, c.mrgRepCt, max(a.invDocDt) as invDocDt "
		+"		from dpsCustSlDt a with (nolock), bkmProducts b with (nolock), bkmRepoCatg c with (nolock) "
		+"		where  a.prodCode = b.prodCode "
		+"		and    b.repoCatg = c.repoCatg and b.isActive= 'Y' "
		+"		and    a.invMnTyp = 'NS' "
		+"		and    a.custCode = '" + cusRtlCd + "' "
		+"		group by a.custCode, mrgRepCt "
		+"	)d "
		+"where  a.prodCode = b.prodCode "
		+"and    b.repoCatg = c.repoCatg "
		+"and    a.custCode = d.custCode "
		+"and    a.invDocDt = d.invDocDt "
		+"and    c.mrgRepCt = d.mrgRepCt and b.isActive= 'Y'  "
		+"group by c.mrgRepDs, convert(varchar(11), a.invDocDt, 113) "
		+"order by convert(varchar(11), a.invDocDt, 113) desc";
}
	rset = WebSessBean.selectRecord(sql);
	
	while (rset.next())
	{
%>
						<tr>
							<td><%=rset.getString(1)%></td>
							<td><%=rset.getString(2)%></td>
							<td><%=rset.getString(3)%></td>
						</tr>
<%
	}
%>
				  </table>
			  </div>
     		 </div>
		 </div>
	  </div>
	 </div>
  </div>
</div>
<div class="col-xl-6">
	<div class="card card-xl-stretch p-4">
		<div class="">
			<div class="row">
				<label>Order Booked in call/e meet</label> 
				<div class="col-xl-12 table-responsive">
				<div class="accordion" id="accordionExample">
					<div id="addblock" class="addblock">
					</div>
				</div>

				<!-- <table class="table table-responsive" id="prjTable">
					<tr>
						<div class='chkBox'><th id="th">Del</th></div>
						<th id="th">Product</th>
						<th id="th">Product (SKU)</th>
						<th id="th">Order Qty. (in Bags)</th>
					</tr>
					<tbody> -->
<%
		if (procType.equals("A"))
		{
%>
			<script language="Javascript">
				addrow('02', '', '0', '0', '0', '');
			</script>
<%
		}
		else if((procType.equals("U") || procType.equals("D")) && !docuNumb.equals(""))
		{
//			sql = "select a.repoCatg, a.repoDesc,  prodQnty,projQnty, actnRemk, isnull(convert(char(10), targetDt, 103), '') from bkmRepoCatg a with (nolock), dptDSRActvtDtl b with (nolock) where a.isActive = 'Y' and   a.repoCatg = b.repoCatg and   a.repoCatg in ('01', '02', '03', '09', '15') and  docuNumb = '" + docuNumb + "' ";	// and createId = '" + loginIdM + "'" + docuNumb + "
			sql = "select a.repoCatg, b.catgPack,  isnull(prodQnty, 0), isnull(projQnty, 0), isnull(actnRemk, ''), isnull(convert(char(10), targetDt, 103), '') "
				+ "from bkmRepoCatg a with (nolock), dptDSRActvtDtl b  with (nolock) "
				+" where    a.repoCatg = b.repoCatg " 
				+ "and		docuNumb = '" + docuNumb + "' "
				+ "and		b.createId = '" + loginIdM + "' "
				//+ "and      a.repoCatg in ('01', '02', '03', '09','12','15','17','18','19') "
				+ "and		a.isActive = 'Y'  and mrktData = '05' ";
				rset = WebSessBean.selectRecord(sql);
			while(rset.next())
			{
%>			
				<script language="Javascript">
					addrow('<%=rset.getString(1)%>','<%=rset.getString(2)%>','<%=rset.getString(3)%>','<%=rset.getString(4)%>','<%=rset.getString(5)%>','<%=rset.getString(6)%>','0');
				</script>
<%
				recFound = true;
			}
		}

%>
					<!-- 	</tbody>
											</table> -->
				</div>
						<div align="center">
							<button name="skAdd" id="skAdd" class="btn btn-primary" onClick="addrow1()" type="button">+</button>
						</div>
			</div>
		</div>
	</div>
</div>
<div class="col-xl-6">
	<div class="card card-xl-stretch p-6">
		<div class="">
			<div class="row">
				<div class="col-lg-12 col-xs-12 col-12" id="mrktWcpHgstSlSKU">
					<div class="form-group table-responsive">
						<label>Market -- WCP (Highest selling SKU)</label>
						<table class="table-responsive" id="mrktMisPrc">
							<thead>
								<tr>
									<td>Del</td>
									<td>Brand</td>
									<td>Product</td>
									<td>Price - B</td>
									<td>Price - C</td>
								</tr>
							</thead>
<%
		if (procType.equals("A"))
		{
%>
			<script language="Javascript">
				mrktMisPrc_Row('', '', '0','0');
			</script>
<%
		}
		else if((procType.equals("U") || procType.equals("D")) && !docuNumb.equals(""))
		{
//			sql = "select a.repoCatg, a.repoDesc,  prodQnty,projQnty, actnRemk, isnull(convert(char(10), targetDt, 103), '') from bkmRepoCatg a with (nolock), dptDSRActvtDtl b with (nolock) where a.isActive = 'Y' and   a.repoCatg = b.repoCatg and   a.repoCatg in ('01', '02', '03', '09', '15') and  docuNumb = '" + docuNumb + "' ";	// and createId = '" + loginIdM + "'" + docuNumb + "
			sql = "select isnull(b.repoCatg, ''), isnull(catgPack, '') as catgPack, isnull(prodQnty, 0), isnull(projQnty, 0), isnull(actnRemk, '') "
				+ "from  dptDSRActvtDtl b  with (nolock)  "
				+" where    docuNumb = '" + docuNumb + "' "
				+ "and		b.createId = '" + loginIdM + "' "
				//+ "and      a.repoCatg in ('01', '02', '03', '09','12','15','17','18','19') "
				+ "and		mrktData = '06' ";
				rset = WebSessBean.selectRecord(sql);
			while(rset.next())
			{
%>			
				<script language="Javascript">
				// mrktMisPrc_Row(branName, prdCodMk, bPriceVl, cPriceVl)
					mrktMisPrc_Row('<%=rset.getString(1)%>','<%=rset.getString(2)%>','<%=rset.getString(3)%>','<%=rset.getString(4)%>');
				</script>
<%

				recFound = true;
			}
		}

%>
					</table>
				</div>
					<div align="center">
						<button name="skAdd" id="skAdd" class="btn btn-primary" onClick="mrktMisPrc_Row('', '', '0', '0')" type="button">+</button>
					</div>
			</div>
		</div>
	</div>
</div>
</div>
<%
if(mobilApp)
{
%>	
<div class="col-xl-6" id="finlRsltDiv7">
	<div class="card card-xl-stretch p-6">
		<div class="">
			<div class="row p-5">
				<div class="col-lg-12">
					<div class="form-group">
						<label class="control-label  float-sm-left"  for="dsrRem07">Address</label>	<br>
						<label class="control-label  float-sm-left"  for="ordExDat">Current Location</label>
						<input type="text" name="geoLatit" id="geoLatit" value="<%=geoLatit%>" readonly>
						<input type="text" name="geoLongt" id="geoLongt" value="<%=geoLongt%>" readonly>
						<input id="FinlRslt" name="FinlRslt" size="25" class="" type="hidden" value="<%=FinlRslt%>" readonly>
						<br>
						<label class="control-label  float-sm-left"  for="ordExDat">Purchaser Location</label>
						<br>
						<input type="text" name="latitute" id="latitute" value="<%=latitute%>" readonly>
						<input type="text" name="lgtitute" id="lgtitute" value="<%=lgtitute%>" readonly>
						<input type="hidden" name="locaCapr" id="locaCapr" value="">
						<input style="display:none;" type="button" value="Get Address" onclick="GetAddress()" />
						<div id="latlng" ></div>
						<div id="current" style="display:none"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
//  document.getElementById("finlRsltDiv").style.display = "none";
</script>
<%
}
else
{
%>
		<div id="current" style="display:none"></div>
		<input type="hidden" name="geoLatit" id="geoLatit" value="">
		<input type="hidden" name="geoLongt" id="geoLongt" value="">
		<input type="hidden" name="FinlRslt" id="FinlRslt" value="">
		<input type="hidden" name="lgtitute" id="lgtitute" value="">
		<input type="hidden" name="latitute" id="latitute" value="">
		<input type="hidden" name="locaCapr" id="locaCapr" value="">
		<input type="hidden" name="formName" id="formName" value="DSRActvNew">
		<input type="hidden" name="dsrInOut" id="dsrInOut" value="">
		<input type="hidden" name="zoneCode" id="zoneCode" value="">
<%
}
%>

		<input type="hidden" name="dsrExcpA" id="dsrExcpA" value="N">
		<input type="hidden" name="randNmSt" value="<%=randNmSt%>">
<div class="col-xl-6">
	<div class="card card-xl-stretch p-6">
		<div class="">
			<div class="row p-6">
				<div class="col-xl-6">
					<div class="form-group">
						<label class="control-label  float-sm-left"  for="ordExDat">Order Execution date</label>
						<input type="text" name="ordExDat" id="ordExDat" value="<%=ordExDat%>" placeholder="Order Execution date" class="" size="24" value="" onfocus='showCal("<%=formName%>","ordExDat")'>
					</div>
				</div>
				<div class="col-xl-6">
					<div class="form-group">
						<label>Any other Remarks</label>
						<input type="text" name="dsrRem05" id="dsrRem05" value="<%=dsrRem05%>" maxlength="200">
					</div>
				</div>
				<div class="col-xl-6" id="cityNameDiv">
					<div class="form-group">
						<label>Select Reason*</label>
						<select name="cityName" id="cityName" value="<%=cityName%>" class="form-control">
							<%=WebSessBean.getSqlToOptionStr("select '01', 'Network Issue' union select '02', 'Battery Low' union select '03', 'Mobile Not working' union select '04', 'Location not capturing' union select '05', 'Wrong Location OF Retailer' union select '06', 'Wrong Location Captured' ", cityName)%>
						</select >
					</div>
				</div>
				<div class="col-xl-6">
 					<div class="form-group pt-10">
<!--					<div id="map-canvas"/></div> -->
						<div id="map" class="row" style="width:250px; height:400px;"></div>
<!-- 						<div id="legend"><h3>Legend</h3></div>
							<p id="error"></p> -->
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!--  Gift Allotment Start Ravindra 07 May 2024-->
<div class="col-xl-6">
	<div class="card card-xl-stretch p-4">
		<div class="">
			<div class="row">
				<label>Gift Distribution</label> 
				<div class="col-xl-12 table-responsive">
				<div class="accordion" id="accordionExample">
					<div id="addblock1" class="addblock">
					</div>
				</div>
<%
		if (procType.equals("A"))
		{
%>
			<script language="Javascript">
				addrowGf('02', '', '0');
			</script>
<%
		}
		else if((procType.equals("U") || procType.equals("D")) && !docuNumb.equals(""))
		{
			sql = "select '','',0 ";
				rset = WebSessBean.selectRecord(sql);
			while(rset.next())
			{
%>			
				<script language="Javascript">
					addrowGf('<%=rset.getString(1)%>','<%=rset.getString(2)%>','<%=rset.getString(3)%>');
				</script>
<%
				recFound = true;
			}
		}

%>

				   <div align="center">
						<button name="skAdd" id="skAdd" class="btn btn-primary" onClick="addrowGf1()" type="button">+</button>
					</div>
				</div>		
			</div>
		</div>
	</div>
</div>

<!--  Gift Distribution End  -->

<%
	if(cusRtlFl.equals("R") || cusRtlFl.equals("RR")  || cusRtlFl.equals("D")  || cusRtlFl.equals("AD")  || cusRtlFl.equals("UR"))
	{
%>
<!--  Tile Seller Retailer Start -->
<div class="col-xl-6">
	<div class="card card-xl-stretch p-4">
		<label>Tile Adhesives</label>
		<div class="row">
			<div class="col-md-6">
				<label>Is this Tile Adhesives seller?</label>
				<select name="isTilRtl">
					<%=WebSessBean.getSqlToOptionStr("select 'Y', 'YES' union select 'N', 'No' ", isTilRtl)%>
				</select>
			</div>
			<div class="col-md-6">
				<label>Tile Adhesive Stock</label>
				<input type="text" class="form-control" name="tileStck" id="tileStck" value="<%=tileStck%>">
			</div>
		</div>
	</div>	
</div>
<!--  Tile Seller Retailer End  -->
<%
	}
%>
<div class="col-xl-12">
	<div class="card card-xl-stretch p-6">
		<div class="">
			<div class="row">
				<div class="col-lg-12 col-xs-12 col-sm-12 p-4" align="center">
<%
//union select '04', 'Other'
if(mobilApp)
{
%>
        <button type="button" id="saveButnA" onClick="return submitValid('A')" class="m-1 btn btn-secondary">Submit & Add</button>
        <button type="button" id="saveButnE" onClick="return submitValid('E')" class="m-1 btn btn-primary">Submit & Exit</button>
        <button type="button" id="saveButnE"  onclick="return getLocation()" class="m-1 btn btn-primary">Capture Location</button>

<%
}
else
{
%>
      <div class="btn-group" role="group" aria-label="Basic example">
        <button type="button" id="saveButnA" onClick="return submitValid('A')" class="m-1 btn btn-light">Add Another Activity</button>
        <button type="button" id="saveButnE" onClick="return submitValid('E')" class="m-1 btn btn-primary">Submit & Exit</button>
		<a class="m-1 btn btn-light" style='cursor:pointer' onclick = "openClickWind('/BirlaWhite/Reports/General/DSRActvRepSelf.jsp?createId=<%=loginIdM%>&strtDate=<%=strtDate%>&endgDate=<%=sysDateOnly%>&emplName=<%=log.getUserName()%>')">Click to See Submitted Data</a>
	  </div>
<%
}
%>
			</div>
		  </div>
		</div>
	  </div>
	</div>
<script language="javascript">
enabDisb();
 //mrktMisPrc_Row('', '', '0','0');
function hgtSlgSkuCp(currObjt)
{
	$('#hgstSlg' + currObjt).show();
}
	$('#cityNameDiv').hide();
/*

//$('#hgstSlgBW').hide();
$('#hgstSlgJK').hide();
$('#hgstSlgOth').hide();
$('#hgstSlgASIAN').hide();
$('#hgstSlgBERGER').hide();
*/

var map = null;
var latLonAr = new Array();
var features = new Array();

//var iconBase = 'https://google-maps-icons.googlecode.com/files/';
var iconBase = '/Stat/images/icons-png/';

var icons = 
{
	C: 
	{
		name: 'Self',
		icon: iconBase + 'custm.png'
	},
	R: 
	{
		name: 'Shop',
		icon: iconBase + 'rtmMapIcon.png'
	}
}

function dispLoca(i,lgti, logti, messge, typeFl) 
{
	//latLonArAr = latLonAr[i].split(splitChrGet());

	features[i] = 
	{
		position: new google.maps.LatLng(lgti, logti),
		type: typeFl,
		title: messge
	};
	console.log(features[i]);
	var marker = new google.maps.Marker(
	{
		position: features[i].position,
		title: features[i].title,
		icon: icons[features[i].type].icon,
		map: map
	});      
	map.setZoom(8);
	map.setCenter(marker.getPosition());
}


//Ravindra 21-02-2023
function mapView(geoLatit,geoLongt,latitute,lgtitute)
{
/*alert("geoLatit :"+geoLatit);
alert("geoLongt :"+geoLongt);
alert("latitute :"+latitute);
alert("lgtitute :"+lgtitute);*/
	var map = L.map('map').setView([51.505, -0.09], 13);

	var tiles = L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', 
	{
		maxZoom: 18,
		attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, ' +
			'Imagery � <a href="https://www.mapbox.com/">Mapbox</a>',
		id: 'mapbox/streets-v11',
		tileSize: 512,
		zoomOffset: -1
	}).addTo(map);

	var marker1 = L.marker([geoLatit, geoLongt]).addTo(map)
		.bindPopup('<b>Hello world!</b><br />I am a popup.').openPopup();

	var circle1 = L.circle([geoLatit, geoLongt], {
		color: 'red',
		fillColor: '#f03',
		fillOpacity: 0.5,
		radius: 100
	}).addTo(map).bindPopup('I am a circle.');

		var popup1 = L.popup()
		.setLatLng([geoLatit, geoLongt])
		.setContent('Your Curent Location.')
		.openOn(map);

/*	var polygon = L.polygon([
		[51.509, -0.08],
		[51.503, -0.06],
		[51.51, -0.047]
	]).addTo(map).bindPopup('I am a polygon.'); */

	var marker2 = L.marker([latitute, lgtitute]).addTo(map)
	.bindPopup('<b>Hello world!</b><br />I am a popup.').openPopup();

	var circle2 = L.circle([latitute, lgtitute], {
		color: 'red',
		fillColor: '#f03',
		fillOpacity: 0.5,
		radius: 100
	}).addTo(map).bindPopup('I am a square.');

		var popup2 = L.popup()
		.setLatLng([latitute, lgtitute])
		.setContent('Purchaser Location.')
		.openOn(map);

	function onMapClick(e) {
		popup
			.setLatLng(e.latlng)
			.setContent('You clicked the map at ' + e.latlng.toString())
			.openOn(map);
	}
}


//google.maps.event.addDomListener(window, 'load', initMap);

/*function initMap() 
{
	var mapOptions = 
	{
		center: new google.maps.LatLng(23.25, 77.4167),
		zoom: 10,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};

	map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
	//dispLoca("1","23.25", "77.4167", "Self", "C");

	var legend = document.getElementById('legend');

	for (var key in icons) 
	{
		var type = icons[key];
		var name = type.name;
		var icon = type.icon;
		var div = document.createElement('div');
		div.innerHTML = '<img src="' + icon + '"> ' + name;
		legend.appendChild(div);
	}

	map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend);
}*/

</script>
<%
}
}
else
{
	if(rtlTrgFl)
	{
%>
<div class="col-xl-12">
	<div class="card card-xl-stretch p-6">
		<div class="">
			<div class="row">
				<div class="displErr displErr-danger" role="displErr">
					<font size="3" color="red">
						<strong> Dear User, <br> You are not Aurthorized to Enter DSR Without Entering Retailer Target Entry.
						<br> 
							First You complete 100% retailers target for Cement, VAP & Putty and then submit DSR. 
						<br>	
						<div class="card">
							<table>
								<tr>
									<th>Total Mapped Retailers</th><td><%=ttlMpdRt%></td> <td></td>
								</tr>
								<tr>
									<th>Product</th><td>No Of Retailers Target Entered</td> <td> % (Target Enter Vs Total Mapped)</td>
								</tr>
								<tr class=<%=trgCmtPr < 100 ? "table-danger" : "table-success" %>>
									<th>Cement </th><td><%=targtCmt%></td><td><%=trgCmtPr%></td>
								</tr>
								<tr class=<%=trgPtyPr < 100 ? "table-danger" : "table-success" %>>
									<th>Putty </th><td><%=targtPty%></td>	<td><%=trgPtyPr%></td>
								</tr>
								<tr class=<%=trgVapPr < 100 ? "table-danger" : "table-success" %>>
									<th>VAP </th><td><%=targtVAP%></td><td><%=trgVapPr%></td>
								</tr>
							</table>
						</div>
							<br>	Please <a href="/BirlaWhite/Mobile/RetailerTrgt.jsp">Click Here </a>for  <font size="3" color="black">Enter Retailer Target Entry</font>
							<br>	Please <a href="/BirlaWhite/Reports/MIS/BidVsTrgtSl.jsp?repoType=T">Click Here </a>for  <font size="3" color="black">Enter Retailer Target Download</font>
						</strong>
					</font>
				</div>
			</div>
		</div>
	</div>
</div>
<%
	}
	else if(snopFrAl.equals("Pending"))
	{
%>
	<blockquote>
		<div class="displErr displErr-danger" role="displErr">
			<font size="3" color="red">
			<br>	
			Please	<a href="/BirlaWhite/Mobile/salesNdOpr.jsp">Click Here </a>for  <font size="3" color="black">Enter SnOP Entry <br>
			
				<strong> Dear User, <br> You are not Aurthorized to Enter DSR Without submit SnOP.

				<div class="card">
					<table>
						<tr>
							<th>Type</th>
							<th>UOM</th>
							<th>Sales Area</th>
							<th>Status</th>
						</tr>
<%
	sql = "	select  'SnOP', nwMtKgLt, areaDesc, count(distinct case when noOfEntry > 0 then areaCode else null end), count(distinct areaCode), " 
		+ "			case when sum(noOfEntry) > 0 then 'Done' else 'Pending' end "
		+ "From  "
		+ "( "
		+ "	selecT  c.stLgcCod, c.retlStHd, a.areaCode, b.areaDesc, d.nwMtKgLt, count(*) as noOfEntry "
		+ "	From	dptAreaDemd a with (nolock), bkmAreaMast b with (nolock), bkmStateLgc c with (nolock), bkmCatgPack d with (nolock) "
		+ "	where	a.areaCode = b.areaCode "
		+ "	and		b.stLgcCod = c.stLgcCod	"
		+ "	and		a.mnthYear = dbo.cofNextYrMn(convert(varchar(6), getdate(), 112)) "
		+ "	and		a.catPckCd = d.catPckCd "
		+ "	and     a.statFlag not in ('C','R') "
		+ "	group   by c.stLgcCod, c.retlStHd, a.areaCode, b.areaDesc, d.nwMtKgLt "
		+ "	union all "
		+ "	selecT  c.stLgcCod, c.retlStHd, b.areaCode, b.areaDesc, d.nwMtKgLt, 0 "
		+ "	From	bkmAreaMast b with (nolock), bkmStateLgc c with (nolock), bkmCatgPack d with (nolock) "
		+ "	where	b.stLgcCod = c.stLgcCod "
		+ "	and     d.isActive = 'Y' "
		+ "	and     b.isActive = 'Y' "
		+ "	and     d.prodCdDs is not null and  b.areaCode not in ('EXB','EXC','EXE','EXG','EXN','EXR','EXT','EXR','EXT','EXR','KKR', 'KAT', 'DLC','PNY','BKM','NAT','KAT','JPF','KGR') "
		+ "	group   by c.stLgcCod, c.retlStHd, b.areaCode, b.areaDesc, d.nwMtKgLt "
		+ ")x "
		+ "where retlStHd = '" + loginIdM + "' "
		+ "and   day(getdate()) >= 19 "
		+ "group by stLgcCod,  nwMtKgLt, areaDesc "	;
	rset = WebSessBean.selectRecord(sql);
	
	while(rset.next())
	{
%>
		<tr>
			<td><%=rset.getString(1)%></td> 
			<td><%=rset.getString(2)%></td> 
			<td><%=rset.getString(3)%></td> 
			<td><%=rset.getString(6)%></td> 
		</tr>
<%
		snopFrAl = rset.getString(5);
	}
				
%>
			</table>
				</div>
		</div>
	<blockquote> 
<%
	}
	else
	{
%>
<div class="col-xl-12">
	<div class="card card-xl-stretch p-6">
		<div class="">
			<div class="row">
				<div class="displErr displErr-danger" role="displErr">
					<font size="3" color="red">
						<strong> Dear User, <br> You are not Aurthorized to Enter DSR Without Entering Market MIS Entry And Stockiest Target Entry.<br> First You complete Both entries and then submit DSR. 
							<br>	Please <a href="/BirlaWhite/Mobile/SFAEnt01.jsp">Click Here </a>for Enter Market MIS Entry <font size="3" color="black"><%=dsrEntAl ? " Complete" : " Pending"%></font>
							<br>	Please <a href="/BirlaWhite/Mobile/StcktTrgtDt.jsp">Click Here </a>for Enter Stockiest Target Entry <font size="3" color="black"><%=dsrStkAl ? " Complete" : " Pending"%></font>
						</strong>
					</font>
					<div >
							<strong>You Belogns to Given Area : <%=areaDesc%>.<br> If there is any wrong mapping Please Contact to Your State Head Or Zonal Head</strong>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%
	}
}	
}
catch (Exception e)
{
	throw new Exception("Error while fetching records in " + pageAddress + e.toString() + sql);
}
rset = WebSessBean.closeRset(rset);
%>

<script src="/tmp/geoTag/js/geoPosition.js" type="text/javascript" charset="utf-8"></script>


<script language="javascript">
if("<%=dsrParam%>" != "" || "<%=procType%>" != "" )
{
 	setTimeout(function()
	{
		$('input[name=procType][value=<%=procType%>]').attr('checked', 'checked');
		if("<%=prtDsCnt%>" != "")
			$('input[name=prtDsCnt][value=<%=prtDsCnt%>]').attr('checked', 'checked');
		else
			$('input[name=prtDsCnt][value=N]').attr('checked', 'checked');

	//	if("<%=dsrParam%>" != "")
	//		$('input[name=dsrParam][value=<%=dsrParam%>]').attr('checked', 'checked');
	
		if("<%=pendIsue%>" != "")
			$('input[name=pendIsue][value=<%=pendIsue%>]').attr('checked', 'checked');

		if("<%=procType%>" != "A" )
		{
			var i = 0, j = 0;
			var brndSlWc = "<%=brndSlWc%>";
			var brndSlWcarr = brndSlWc.split(",");
			var brndSlWp = "<%=brndSlWp%>";
			var brndSlWparr = brndSlWp.split(",");
						   //displErr(brndSlWcarr[0]);
			for (i = 0; i< brndSlWcarr.length ; i++)
			{
				$('input[name=brndSlWc][value=' + brndSlWcarr[i] + ']').attr('checked', 'checked');
			}
			for (j = 0; j< brndSlWparr.length ; j++)
			{
				$('input[name=brndSlWp][value=' + brndSlWparr[j] + ']').attr('checked', 'checked');
			}

			if(document.<%=formName%>.pendIsue.value == "Y")
			{
				enableDisable("pndIsuDt", "E", false, true);
				enableDisable("isuDetal", "E", false, true);
			}
		}
	}, 500);  
}
//brndSlWc
 var isAndroid =  /Android/.test(navigator.userAgent);

	function  showHideRtl()
	{
		if(document.<%=formName%>.cusRtlFl.value == "R" || document.<%=formName%>.cusRtlFl.value == "RR")
			$("#retlClas").show();
		else
			$("#retlClas").hide();
	}



function MessgView()
{	
	var imgeView="";
	imgeView = "All DIC will have to enter Market MIS at month end then only he would be able to enter DSR for next month.";
//	document.getElementById("myModalLabel" ).innerText = "Important Message";
	imgeView = "/Envr/JSP/AtchFileShow.jsp?docuNumb=&atchNmId=0&filSeqNo=0&attFilTy=00";
	document.getElementById("modeliframe" ).src = imgeView;
}
/**/

function cusRtlCdHlpLoc(rqstType)
{
	var srcFldNm = "cusRtlCd";
	var cusRtlFl = document.<%=formName%>.cusRtlFl;
	var wherList = "";
	var cusTypFl = "";


	if(cusRtlFl.value == "")
	{
		displErr("Please select User Type");
		cusRtlFl.value = "";
		cusRtlFl.focus();
		return false;
	}

	if(document.<%=formName%>.areaCode.value == "")
	{
		alert("Please select Area");
		return false;
	}
	//alert(cusRtlFl.value);
	if(cusRtlFl.value == "C" || cusRtlFl.value == "D" || cusRtlFl.value == "RD" || cusRtlFl.value == "AD" || cusRtlFl.value == "UR")
	{
		if("<%=deptCode%>" == "KKR118") 
		{
			//wherList = whereAdd(wherList, "SW_28", "BL"); // Bulder Segment
			wherList = whereAdd(wherList, "SW_05", "");
		}
		else
		{
			wherList = whereAdd(wherList, "SW_04", ""); // All Trade Segment
		}

		if(cusRtlFl.value == "C" && "<%=deptCode%>" != "KKR118")
			cusTypFl = "T";
		else if(cusRtlFl.value == "AD")
		{
			wherList = whereAdd(wherList, "SW_28", "AD");
			cusTypFl = "T";
		}
		else if(cusRtlFl.value == "UR")
		{
			wherList = whereAdd(wherList, "SW_28", "UR");
			cusTypFl = "T";
		}
		else if(cusRtlFl.value == "DD")
		{
			wherList = whereAdd(wherList, "SW_28", "DD");
			cusTypFl = "T";
		}
		else if(cusRtlFl.value == "RD")
			cusTypFl = "R";

		custCodeHlp('<%=formName%>', 'areaCode', srcFldNm, rqstType, 'O', cusTypFl, wherList);
	}
	else if(cusRtlFl.value == "R" || cusRtlFl.value == "RR")
	{
		if(cusRtlFl.value == "R")
			wherList = whereAdd(wherList, "SW_06", ""); // Exclude Subdistributor 
		else if(cusRtlFl.value == "RR")
			wherList = whereAdd(wherList, "SW_06", "S"); // Exclude Subdistributor 

		retlCodeHlp('<%=formName%>', srcFldNm, 'areaCode', 'A', rqstType, 'Y', wherList);
	}
	else
	{
		wherList = whereAdd(wherList, "SW_01", "Y");
		//wherList = whereAdd(wherList, "SW_04", "");
		wherList = whereAdd(wherList, "SW_07", document.<%=formName%>.areaCode.value);
		wherList = whereAdd(wherList, "SW_03", cusRtlFl.value);

		dataLook("<%=formName%>", srcFldNm, 'MK_00045', 'L', 'DN', wherList);
	
	}
	return true;
}

var custCdRtArr = "",
	cusRtlCdArr = "";

function cusRtlCdHlpget(rqstType)
{
	if(rqstType == "A")
	{
		var srcFldNm = "custCdRt",
			tgtFldNm = "custCdRtDiv",
			newCustS = "Y";
		if(!(document.<%=formName%>.cusRtlFl.value == "R" || document.<%=formName%>.cusRtlFl.value == "RR"))	
		{
			displErr("Nearest Stokiest Code Not require");
			return false;
		}
	}
	else
	{
		var srcFldNm = "cusRtlCd",
			newCustS = "",
			tgtFldNm = "cusRtlCdDiv";
	}

	var wherList = "",
		rtnValue = false,
		rqstType = "G";
		queryCod = "MK_01083";
	var cusRtlFl = document.<%=formName%>.cusRtlFl;

	wherList = whMasAdd(wherList, "Y");

//	wherList = whereAdd(wherList, "SW_04", "AGR");
	wherList = whereAdd(wherList, "SW_04", document.<%=formName%>.areaCode.value);

	if(cusRtlFl.value == "")
	{
		displErr("Please select User Type");
		cusRtlFl.value = "";
		cusRtlFl.focus();
		return false;
	}

	if(document.<%=formName%>.areaCode.value == "")
	{
		displErr("Please select Area");
		document.<%=formName%>.areaCode.focus();
		return false;
	}

	if(cusRtlFl.value == "C")
	{
		wherList = whereAdd(wherList, "SW_08", "'ST'");
	}
	else if(cusRtlFl.value == "RD")
	{
		wherList = whereAdd(wherList, "SW_08", "'RD'");
	}
	else if(cusRtlFl.value == "AD")
	{
		wherList = whereAdd(wherList, "SW_08", "'AD'");
	}
	else if(cusRtlFl.value == "UR")
	{
		wherList = whereAdd(wherList, "SW_08", "'UR'");
	}
	else if(cusRtlFl.value == "D")
	{
		if((document.<%=formName%>.areaCode.value == "DEL" || document.<%=formName%>.areaCode.value == "CAL" || document.<%=formName%>.areaCode.value == "GUW" || document.<%=formName%>.areaCode.value == "PNY" || document.<%=formName%>.areaCode.value == "KAN" || document.<%=formName%>.areaCode.value == "GRG" || document.<%=formName%>.areaCode.value == "PNA" || document.<%=formName%>.areaCode.value == "VAD" || document.<%=formName%>.areaCode.value == "DLS" || document.<%=formName%>.areaCode.value == "RTK" || document.<%=formName%>.areaCode.value == "PAT" ))
		{
		//	return true
		}
		else 
		{
			document.<%=formName%>.cusRtlCd.value = "";
			displErr("DD Modal not applicable for your Sales Area");
			return false;
		}
		wherList = whereAdd(wherList, "SW_08", "'DD'");
	}
	else if(cusRtlFl.value == "R")
	{
		wherList = whereAdd(wherList, "SW_06", "'R'");
	}
	else if(cusRtlFl.value == "RR")
	{
		wherList = whereAdd(wherList, "SW_07", "'R'");
	}
//	wherList = whereAdd(wherList, "SW_05", "<%=loginIdM%>");
	
//	displErr(wherList);
	rtnValue = setPrmNew("<%=formName%>", srcFldNm, queryCod, rqstType, "DN", wherList, tgtFldNm);
	if (!rtnValue)
		return false;
//	displErr(rtnValue);
	if(newCustS == "Y")
	{
		custCdRtArr = document.getElementById(tgtFldNm).innerText.split("~~");
		document.getElementById(tgtFldNm).innerText = "";

		$("#custCdRt").autocomplete(
		{
			source: custCdRtArr
		});
	}
	else
	{
		cusRtlCdArr = document.getElementById(tgtFldNm).innerText.split("~~");
		document.getElementById(tgtFldNm).innerText = "";

		$("#cusRtlCd").autocomplete(
		{
			source: cusRtlCdArr
		});
	}
//	cusRtlCdHlpChng(cusRtlCdArr);
	return true;
}

function cusRtCdChng()
{
	var wherList = "",
		rtnValue = false,
		rqstType = "G";
		queryCod = "MK_01083";
	var srcFldNm = "cusRtlCd",
		newCustS = "",
		tgtFldNm = "cusRtlCdDiv";
		
		wherList = whMasAdd(wherList, "Y");
		wherList = whereAdd(wherList, "SW_04", document.<%=formName%>.areaCode.value);
		wherList = whereAdd(wherList, "SW_09", currObjc.value);

	var rtnVal01 = setPrmNew('<%=formName%>', srcFldNm, queryCod, rqstType, 'DN', wherList, tgtFldNm);
	/*
	wherList = whereAdd(wherList, "@__01", document.<%=formName%>.appRtlCd.value); 

	rtnKycFl = setPrmNew('<%=formName%>', document.<%=formName%>.appRtlCd.name, 'MK_01096', 'G', 'DN', wherList, 'rtnKycFlDiv');
	displErr(rtnVal01);
	*/

	if (!rtnVal01)
		return false;
}

function cusRtlCdHlpChng(currObjc)
{
//	displErr(isAndroid.matches);
	var rqstLnth = currObjc.value.split("~");
//	displErr(rqstLnth.length);

	if(rqstLnth.length == "1")
	{
//		displErr(currObjc.value);
		if(document.<%=formName%>.cusRtlFl.value  == "07" || document.<%=formName%>.cusRtlFl.value  == "08")
		{
		   document.<%=formName%>.cusRtlCd.value = currObjc.value;
		}
		else 
		{
			var wherList = "",
				rtnValue = false,
				rqstType = "G";
				queryCod = "MK_01083";
			var srcFldNm = "cusRtlCd",
				newCustS = "",
				tgtFldNm = "cusRtlCdDiv";
				
				wherList = whMasAdd(wherList, "Y");
				wherList = whereAdd(wherList, "SW_04", document.<%=formName%>.areaCode.value);
				wherList = whereAdd(wherList, "SW_09", currObjc.value);

			var rtnVal01 = setPrmNew('<%=formName%>', srcFldNm, queryCod, rqstType, 'DN', wherList, tgtFldNm);
/*
			wherList = whereAdd(wherList, "@__01", document.<%=formName%>.appRtlCd.value); 
			
			rtnKycFl = setPrmNew('<%=formName%>', document.<%=formName%>.appRtlCd.name, 'MK_01096', 'G', 'DN', wherList, 'rtnKycFlDiv');
			displErr(rtnVal01);
*/

			if (!rtnVal01)
				return false;

			custCdRtArr = document.getElementById("cusRtlCdDiv").innerText;
			
			document.getElementById("cusRtlCdDiv").innerText = "";
		///	currObjc	= custCdRtArr;
		//	document.<%=formName%>.cusRtlCd.value = "";
			//	return false;
			document.<%=formName%>.kycVerFl.value = custCdRtArr.split("~")[8];
			document.<%=formName%>.lgtitute.value = custCdRtArr.split("~")[7];
			document.<%=formName%>.latitute.value = custCdRtArr.split("~")[6];
			document.<%=formName%>.locaCapr.value = custCdRtArr.split("~")[5];
			document.getElementById("cusRtlCdDiv").innerText = custCdRtArr.split("~")[1];
			document.<%=formName%>.cusRtlCd.value = custCdRtArr.split("~")[0];
		}
	}
	else
	{
		document.<%=formName%>.lgtitute.value = currObjc.value.split("~")[7];
		document.<%=formName%>.latitute.value = currObjc.value.split("~")[6];
		document.<%=formName%>.locaCapr.value = currObjc.value.split("~")[5];
		document.getElementById("cusRtlCdDiv").innerText = currObjc.value.split("~")[1];
		document.<%=formName%>.cusRtlCd.value = currObjc.value.split("~")[0];
	}

	document.getElementById("cusRtlCdDiv1").innerText = document.getElementById("cusRtlCdDiv").innerText;
	var alValChk = "5";

//	   displErr(compareDateNew(document.<%=formName%>.docuDate.value, "17/05/2020"));
	if(compareDateNew( document.<%=formName%>.docuDate.value, "16/05/2020") > 0  && parseInt(withAlNm) <= parseInt(alValChk))
	{
		if(document.getElementById("lgtitute").value != "NA" && isAndroid && document.getElementById("latitute").value != "NA" && document.<%=formName%>.dsrParam.value == "01")
		{
			var distCalc = distanceCalDsr(document.getElementById("latitute").value, document.getElementById("lgtitute").value, document.getElementById("geoLatit").value, document.getElementById("geoLongt").value, "M");
			if(parseInt(distCalc) < 500)
				return true;
			else
			{
				displErr("You are not at Customer`s Shop. Please Go to Purchaser Shop and retry. Your Distance from Purchaser's shop : " + distCalc);
	
				document.getElementById("cusRtlCd").value = "";
				
//				withAlNm += 1;

			//	 displErr(withAlNm);
				if(isAndroid)
					getLocation();
				else
					initialise();

				return false;
			}
		}
		else if (document.<%=formName%>.dsrParam.value == "01" && isAndroid)
		{
			displErr("Dear User Please capture retailer / Purchaser's Address First Other wise it is not allowing to update DSR Entry.");

			var openUrln = "/BirlaWhite/Mobile/LatLogCusCp.jsp?popupWin=Y&cusRtlCd=" + document.getElementById("cusRtlCd").value + "&areaCode="+document.<%=formName%>.areaCode.value + "&cusRtlFl=" + document.<%=formName%>.cusRtlFl.value;
			//createModal('Purchaser Location Capture', openUrln);
			location.href = openUrln;
			document.getElementById("cusRtlCdDiv").innerText = "";
			document.getElementById("cusRtlCd").value = "";
		}
	}
}
//displErr( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent));
function distancChk()
{
	if (document.<%=formName%>.dsrParam.value == "05" && document.<%=formName%>.cusRtlCd.value != "")
	{
		//return true;
	}
	else
	{
		return false;
	}

	withAlNm ++;
	var alValChk = "4";
	//displErr(withAlNm);
	if(parseInt(withAlNm) <= parseInt(alValChk))
	{
//		displErr("if 1");
		if(document.getElementById("lgtitute").value != "NA" && document.getElementById("latitute").value != "NA" && document.<%=formName%>.dsrParam.value == "05")
		{
			var distCalc = distanceCalDsr(document.getElementById("latitute").value, document.getElementById("lgtitute").value, document.getElementById("geoLatit").value, document.getElementById("geoLongt").value, "M");

			//dispLoca("0","23.25", "77.4167", "Shop", "R");
		//	dispLoca("1","23.25", "77.4167", "Self", "C");
			mapView(document.getElementById("geoLatit").value,document.getElementById("geoLongt").value,document.getElementById("latitute").value,document.getElementById("lgtitute").value);

			//dispLoca("0",document.getElementById("latitute").value, document.getElementById("lgtitute").value, "Shop", "R");
			//dispLoca("1", document.getElementById("geoLatit").value, document.getElementById("geoLongt").value, "Self", "C");
			if(parseInt(distCalc) <= 500)
			{
				return true;
			}
			else
			{
				displErr("You are not at Customer`s Shop. Please Go to Purchaser Shop and retry. Your Distance from Purchaser's shop : " + distCalc + " Meters.");

			//	document.getElementById("cusRtlCd").value = "";
				
		//				withAlNm += 1;

			//	 displErr(withAlNm);
				if(isAndroid)
					getLocation();
				else
					initialise();

				return false;
			}
		}
		else if (document.<%=formName%>.dsrParam.value == "05")
		{
			displErr("Dear User Please capture retailer / Purchaser's Address First Other wise it is not allowing to update DSR Entry.");

			var openUrln = "/BirlaWhite/Mobile/LatLogCusCp.jsp?cusRtlCd=<%=cusRtlCd%>&areaCode=" + document.<%=formName%>.areaCode.value + "&cusRtlFl=" + document.<%=formName%>.cusRtlFl.value;
			//createModal('Purchaser Location Capture', openUrln);
			location.href = openUrln;
			//document.getElementById("cusRtlCdDiv").innerText = "";
			//document.getElementById("cusRtlCd").value = "";
			return false;
		}
		/*
		else if (document.<%=formName%>.dsrParam.value == "05")
		{
			displErr("Please Enter reason why you are not using Mobile Devices. This Entry goes to approval for your supervisor. Without approving this Entry You cannot fill your attendace. ");
			$('#cityNameDiv').show();
			document.<%=formName%>.dsrExcpA.value = "Y";
			window.clearInterval(myVar);
			return true;
		}
		*/
	}
	else if (document.<%=formName%>.dsrParam.value == "05" && document.getElementById("lgtitute").value == "")
	{
		mapView(document.getElementById("geoLatit").value,document.getElementById("geoLongt").value,document.getElementById("latitute").value,document.getElementById("lgtitute").value);
		//dispLoca("0",document.getElementById("latitute").value, document.getElementById("lgtitute").value, "Shop", "R");
		//dispLoca("1", document.getElementById("geoLatit").value, document.getElementById("geoLongt").value, "Self", "C");
		displErr("We have not found location. This DSR Entry should be approved by your supervisor either you not submit attendance also.");
//		displErr("2");
		$('#cityNameDiv').show();
		document.<%=formName%>.dsrExcpA.value = "Y";
		if(isAndroid)
			getLocation();
		else
			initialise();
		window.clearInterval(myVar);
		return true;
	}
	else if(document.<%=formName%>.dsrParam.value == "05" && document.getElementById("lgtitute").value != "")
	{
		mapView(document.getElementById("geoLatit").value,document.getElementById("geoLongt").value,document.getElementById("latitute").value,document.getElementById("lgtitute").value);
		//dispLoca("0",document.getElementById("latitute").value, document.getElementById("lgtitute").value, "Shop", "R");
		//dispLoca("1", document.getElementById("geoLatit").value, document.getElementById("geoLongt").value, "Self", "C");
		var distCalc = distanceCalDsr(document.getElementById("latitute").value, document.getElementById("lgtitute").value, document.getElementById("geoLatit").value, document.getElementById("geoLongt").value, "M");
		
		if(parseInt(distCalc) <= 500)
		{
			return true;
		}
		else
		{
			displErr("You are not at Customer`s Shop. Please Go to Purchaser Shop and retry. Your Distance from Purchaser's shop : " + parseInt(distCalc) + " Meters.");

		//	document.getElementById("cusRtlCd").value = "";
			
					withAlNm += 1;

			if(parseInt(withAlNm) > 10)
			{
				document.<%=formName%>.dsrExcpA.value = "Y";
				window.clearInterval(myVar);
				$('#cityNameDiv').show();
			}
				//  myVar = setInterval(distancChk, 0);
		//	 displErr(withAlNm);
			if(isAndroid)
				getLocation();
			else
				initialise();

			return false;
		}
	}
	if(parseInt(withAlNm) > 10)
	{
		document.<%=formName%>.dsrExcpA.value = "Y";
		window.clearInterval(myVar);
		$('#cityNameDiv').show();
	}
}

function distanceCalDsr(lat1, lon1, lat2, lon2, unit) 
{
	if ((lat1 == lat2) && (lon1 == lon2)) 
	{
		return 0;
	}
	else 
	{
		var radlat1 = Math.PI * lat1/180;
		var radlat2 = Math.PI * lat2/180;
		var theta = lon1-lon2;
		var radtheta = Math.PI * theta/180;
		var dist = "";
			dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
		if (dist > 1) {
			dist = 1;
		}
		dist = Math.acos(dist);
		dist = dist * 180/Math.PI;
		dist = dist * 60 * 1.1515;
		if (unit=="K") { dist = dist * 1.609344 }
		if (unit=="M") { dist = dist * 1.609344 * 1000}
		if (unit=="N") { dist = dist * 0.8684 }
		
		return dist;
	}
}  


function docuDateChkLoc()
{
	if(!isDate(document.<%=formName%>.docuDate, true, "<=today"))
	{
		document.<%=formName%>.docuDate.value = "";
		document.<%=formName%>.docuDate.focus();
		return false;
	}

	var wherList = "";

	wherList = whereAdd(wherList, "@__01", "<%=loginIdM%>"); 
	wherList = whereAdd(wherList, "@__02", dmyTOdmmmy(document.<%=formName%>.docuDate.value)); 
	wherList = whereAdd(wherList, "@__03", "D"); // D for DSR

	var dataRecd = dataLook("<%=formName%>", "docuDate", "MK_02008", 'G', "DN", wherList);
	 

	if(document.getElementById("docuDateDiv").innerText != "OK")
	{
		displErr("Please Put Valid DSR Date. You Can submit DSR only Last Three Days. If You want to submit back date entry Please enter Exception entry(Path : Transcation --> DSR Exception Entry). Take Approval from concerned and Fill DSR Within 3 days after approval.");
		document.getElementById("docuDateDiv").innerHTML = "Please Put Valid DSR Date. You Can submit DSR only Last Three Days. If You want to submit back date entry Please enter Exception entry(Path : <a href='/BirlaWhite/Trans/GenExcp.jsp'>Click Here</a>). Take Approval from concerned and Fill DSR Within 3 days after approval.";
	//	document.<%=formName%>.docuDate.value = "";
		return false;
	}

	return document.getElementById("docuDateDiv").innerText;
}


function customerValidDsr()
{

	if(!textValidApp(document.<%=formName%>.cusRtlFl, '<%=custLabl%> Flag', false))
		return false;
	
	if(!textValidApp(document.<%=formName%>.areaCode, 'Area Code', false))
		return false;

	if(<%=cusCodRq%> && !textValidApp(document.<%=formName%>.cusRtlCd, '<%=custLabl%> Code', false))  
		return false;

	return true;
}


function submitValid(submMthd)
{
 	
	if(document.<%=formName%>.cusRtlFl.value == "R" || document.<%=formName%>.cusRtlFl.value == "RR"  || document.<%=formName%>.cusRtlFl.value == "D"  || document.<%=formName%>.cusRtlFl.value == "AD"  || document.<%=formName%>.cusRtlFl.value == "UR")
	{
		if(!textValidApp(document.<%=formName%>.isTilRtl, 'Tile Adhesives', false))
		return false;
	}
	
	
	document.<%=formName%>.submMthd.value = submMthd;

	if(document.<%=formName%>.procType.value != "D")
	{
		var docuDtMs = docuDateChkLoc();

		if(docuDtMs != "OK")
		{
			displErr(docuDtMs);
			document.<%=formName%>.docuDate.focus();
			return false;
		}
	}
	if(!textValidApp(document.<%=formName%>.dsrParam, 'Activity Type', false))
		return false;
	if(!textValidApp(document.<%=formName%>.procType, 'Process Type', false))
		return false;

	if(document.<%=formName%>.procType.value != "D")
	{
		if(!textValidApp(document.<%=formName%>.docuDate, 'Report Date', false))
			return false;
		if(!textValidApp(document.<%=formName%>.cusRtlFl, 'Purchaser / Retailer Type', false))
			return false;
		if(!textValidApp(document.<%=formName%>.areaCode, 'Area Code', false))
			return false;
		if(!textValidApp(document.<%=formName%>.cusRtlCd, 'Purchaser / Retailer Code', false))
			return false;
		if(!textValidApp(document.<%=formName%>.prtDsCnt, 'Participation of Display Contest', false))
			return false;
		if(!textValidApp(document.<%=formName%>.mrktName, 'Market Name', false))
			return false;
		if(!textValidApp(document.<%=formName%>.pendIsue, 'Any Pending Issues(Yes /No) ', false))
			return false;
		if(document.<%=formName%>.pendIsue.value == "Y")
		{
			if(!textValidApp(document.<%=formName%>.pndIsuDt, 'if Yes, pending issue details', false))
				return false;
			if(!textValidApp(document.<%=formName%>.isuDetal, 'if Yes, Specify Issue', false))
				return false;
		}
		if(!textValidApp(document.<%=formName%>.wcErlSlb, 'Enrolment Slab (in MT) WC', false))
			return false;
		if(!textValidApp(document.<%=formName%>.wpErlSlb, 'Enrolment Slab (in MT) WCP', false))
			return false;
		if(!textValidApp(document.<%=formName%>.vpErlSlb, 'Enrolment Slab (in MT) VAP', false))
			return false;

		if (!isNumApp(eval("document.<%=formName%>.wcErlSlb"), "PZ"))
			return false;
		if (!isNumApp(eval("document.<%=formName%>.wpErlSlb"), "PZ"))
			return false;
		if (!isNumApp(eval("document.<%=formName%>.vpErlSlb"), "PZ"))
			return false;

		if(document.<%=formName%>.cusRtlFl.value == "ST" || document.<%=formName%>.cusRtlFl.value == "RD")
		{
			//return true;
		}
		else
		{
			if(!textValidApp(document.<%=formName%>.bwStkWcc, 'BW Stocks Availability (in MT) WC', false))
				return false;
			if(!textValidApp(document.<%=formName%>.bwStkWcp, 'BW Stocks Availability (in MT) WCP', false))
				return false;
			if(!textValidApp(document.<%=formName%>.bwStkVap, 'BW Stocks Availability (in MT) VAP', false))
				return false;
		}
	//	if(!textValidApp(document.<%=formName%>.areaCode, 'Area Code', false))
	//		return false;
	//	if(!textValidApp(document.<%=formName%>.areaCode, 'Area Code', false))
	//		return false;
	//	if (!isDate(document.<%=formName%>.docuDate, true, "<=today"))
	//		return false;


	//	displErr(rtnValue);
		var msgeText = "";
		if(document.<%=formName%>.dsrExcpA.value == "Y" || (document.<%=formName%>.dsrParam.value == "05" && document.<%=formName%>.geoLatit.value == ""))
		{
			//displErr("");
			$('#cityNameDiv').show();
			if(!textValidApp(document.<%=formName%>.cityName, 'Exception Reason', false))
				return false;

			msgeText = "Current DSR Entry exception apporval goes to your supervisor. Still Do you want to submit. Without approving this Entry You cannot fill your attendace.";
		}

		if(document.<%=formName%>.dsrParam.value == "05")
			document.<%=formName%>.ltLgDist.value = distanceCalDsr(document.getElementById("latitute").value, document.getElementById("lgtitute").value, document.getElementById("geoLatit").value, document.getElementById("geoLongt").value, "M");

		var distLoca = document.<%=formName%>.ltLgDist.value;

		if(distLoca == "NaN")
		{
			document.<%=formName%>.ltLgDist.value = "9999";
			distLoca = "9999";
		}
//	document.getElementById("latitute").value, document.getElementById("lgtitute").value, document.getElementById("geoLatit").value, document.getElementById("geoLongt").value
		if(parseFloat(distLoca) > 500)
		{
			$('#cityNameDiv').show();
			if(!textValidApp(document.<%=formName%>.cityName, 'Exception Reason', false))
				return false;
		}
		if(document.getElementById("geoLatit").value != "" && document.getElementById("geoLongt").value != "")
		{
			 if(document.<%=formName%>.cityName.value == "04")
			 {
				alert("Location Captured by App but location not matched with Purchaser Shop. Please select Correct reason.");
				return false;
			 }
		}
	}
  	if (!subValidCom("<%=formName%>"))
		return false;

	if(msgeText == "")
		msgeText = "";

	displSav(msgeText);
	return false;
}

function frmSubmt(val) // For Common Submit Function 
{
	if (val)
	{
		enbDisAll('AE');
		document.<%=formName%>.method = "POST";
		document.<%=formName%>.action = "DSRActvNewS.jsp"; 
		document.<%=formName%>.submit();
	}
} 

function enbDisAll(currObjt)
{
	if(currObjt == "AE")
	{
		//enableDisable("dsrParam1", "E", false, false);
		//enableDisable("dsrParam2", "E", false, false);
		enableDisable("procType", "E", false, false);
		enableDisable("cusRtlFl", "E", false, false);
		enableDisable("areaCode", "E", false, false);
		enableDisable("cusRtlCd", "E", false, false);
		enableDisable("docuDate", "E", false, false);
		enableDisable("mrktName", "E", false, false);
		enableDisable("pndIsuDt", "E", false, false);
		enableDisable("isuDetal", "E", false, false);
		enableDisable("bwStkWcc", "E", false, false);
		enableDisable("bwStkWcp", "E", false, false);
		enableDisable("bwStkVap", "E", false, false);
		enableDisable("bwAvgWcc", "E", false, false);
		enableDisable("bwAvgWcp", "E", false, false);
		enableDisable("bwAvgVap", "E", false, false);
	}
	else if(currObjt == "AD")
	{
		//enableDisable("dsrParam1", "D", false, false);
		//enableDisable("dsrParam2", "D", false, false);
		enableDisable("procType", "D", false, false);
		enableDisable("cusRtlFl", "D", false, false);
		enableDisable("areaCode", "D", false, false);
		enableDisable("cusRtlCd", "D", false, false);
		enableDisable("docuDate", "D", false, false);
		enableDisable("bwAvgWcc", "D", false, false);
		enableDisable("bwAvgWcp", "D", false, false);
		enableDisable("bwAvgVap", "D", false, false);
	}
}
if("<%=procType%>" == "U" || "<%=procType%>" == "D")
{
	enbDisAll("AD");
}

if(("<%=cusRtlFl%>" == "R" || "<%=cusRtlFl%>" == "RT" || "<%=cusRtlFl%>" == "RR"))
{
	$('#lstThrAvg').show();
	$('#wcpIndustry').show();
	$('#mrktWcpHgstSlSKU').show();
	$('#wcIndustry').show();
}
else
{
	$('#lstThrAvg').hide();
	$('#mrktWcpHgstSlSKU').hide();
	$('#wcpIndustry').hide();
	$('#wcIndustry').hide();
}
var lat, lng, address;

function initiate_geolocation() 
{
	navigator.geolocation.getCurrentPosition(handle_geolocation_query);
}

function handle_geolocation_query(position)
{
	lat = position.coords.latitude;	//To
	document.getElementById("geoLatit").value = lat; 
	lng = position.coords.longitude;
	document.getElementById("geoLongt").value = lng;
}

function GetAddress() 
{
var latlng = new google.maps.LatLng(lat, lng);
var geocoder = geocoder = new google.maps.Geocoder();

geocoder.geocode({ 'latLng': latlng }, function (results, status) 
{
	if (status == google.maps.GeocoderStatus.OK) 
	{
		if (results[1]) 
		{
			address = results[1].formatted_address;
			document.getElementById("FinlRslt").value = address; 
			$("#finlRsltDiv").show();
		}
	}
	else 
	{
		$("#finlRsltDiv").hide();
	//	displErr("Geocoder failed due to: " + status + " Please Enable Location");
	}

});
}

if(<%=mobilApp%>  == true)
{
	$(function()
	{
	initiate_geolocation();

	setTimeout(function(){
	  GetAddress();
	}, 3000);

	});	
}
 /*
function initMap() 
{
var map = new google.maps.Map(document.getElementById('map'), 
{
  zoom: 15,
  center: {lat: 40.731, lng: -73.997}
});
var geocoder = new google.maps.Geocoder;
var infowindow = new google.maps.InfoWindow;

  (geocoder, map, infowindow);

}
*/
var mylatlng = "";

async function getValuFrmAnd()
{
	return new Promise(resolve => 
	{
		var getLocan = Android.trunOnGPSLoca();
		resolve(getLocan);
	});
}
async function getLocation() 
{
	withAlNm = withAlNm + 1;
	var a1 = getValuFrmAnd();
	// alert("<%=loginIdM%>");
	setTimeout(function()
	{
			//alert("getLocan " + getLocan);
	//		var AndroidVL = getValuFrmAnd(); //Android.setLatLong();
			var AndroidVL = Android.setLatLong();
		//	alert("AndroidVL : " + AndroidVL);
			document.getElementById("latlng").innerText = AndroidVL;
			
		//	alert(isAndroid.matches);
			
			if(document.getElementById("latlng").innerText == "" && !isAndroid)
			{
			//	initialiseMap();initialise();
			}
	//		alert(AndroidVL);
			var latlng = AndroidVL.split(",");
		//	var latlng = "";
			
	//		alert("latlng[0] " + latlng[0]);
	//		alert("latlng[1] " + latlng[1]);
			document.getElementById("geoLatit").value = latlng[0];
			document.getElementById("geoLongt").value = latlng[1];

		//	mylatlng = 	{lat: 26.6062318, lng: 73.6853633};
		//	document.getElementById("latlng").value = "26.6062318,73.6853633";
			//mylatlng = 	{lat: parseFloat(latlng[0]), lng: parseFloat(latlng[1])};
//	   });
//		var map = new google.maps.Map(document.getElementById("map"), 
//		{
//			zoom: 18,
//	//	    center = bounds.getCenter(),
//
//			center: mylatlng
//		});
//		var geocoder = new google.maps.Geocoder;
//		var infowindow = new google.maps.InfoWindow;
//		var marker = new google.maps.Marker({position: mylatlng, map: map});
//		var infoWindow = new google.maps.InfoWindow(
//		//        {content: '', position: mylatlng}
//		);
//		geocodeLatLng(geocoder, map, infowindow);
			// Configure the click listener.
	}, 5000);
}

function showPosition(position) 
{
	document.getElementById("latlng").value = position.coords.latitude + "," + position.coords.longitude;
	document.getElementById("geoLatit").value =     position.coords.latitude;
	document.getElementById("geoLongt").value = 	position.coords.longitude;

		mylatlng = 	{lat: position.coords.latitude, lng: position.coords.longitude};

	var map = new google.maps.Map(document.getElementById("map"), 
	{
		zoom: 18,
//	    center = bounds.getCenter(),

		center: mylatlng
	});
	var geocoder = new google.maps.Geocoder;
	var infowindow = new google.maps.InfoWindow;
	var marker = new google.maps.Marker({position: mylatlng, map: map});
	var infoWindow = new google.maps.InfoWindow(
    //        {content: '', position: mylatlng}
	);

		infoWindow.open(map);
				map.addListener('click', function(mapsMouseEvent) 
				{
				  // Close the current InfoWindow.
				  infoWindow.close();

				  // Create a new InfoWindow.
				  infoWindow = new google.maps.InfoWindow({position: mapsMouseEvent.latLng});
				  infoWindow.setContent(mapsMouseEvent.latLng.toString());
				
				  document.getElementById("googleValue").innerHTML = mapsMouseEvent.latLng.toString();
					
				   maulValuAsn(mapsMouseEvent.latLng.toString());

				  infoWindow.open(map);
				});	
		geocodeLatLng(geocoder, map, infowindow);
        // Configure the click listener.             
}

		function initialiseMap()
		{
			/*
			var myOptions = {
			      zoom: 4,
			      mapTypeControl: true,
			     // mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
			      navigationControl: true,
			    //  navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
//			      mapTypeId: google.maps.MapTypeId.ROADMAP      
			    }	
			map = new google.maps.Map(document.getElementById("map"), myOptions);
			*/
		}
		function initialise()
		{
			//displErr("1");
			withAlNm = withAlNm + 1;
			if(geoPosition.init() && document.getElementById("geoLatit").value == "")
			{
				document.getElementById('current').innerHTML="Receiving...";
				geoPosition.getCurrentPosition(showPositionNew,function(){document.getElementById('current').innerHTML="Couldn't get location"},{enableHighAccuracy:true});
			}
			else if(document.getElementById("geoLatit").value != "")
			{
				document.getElementById('current').innerHTML = "latitude=" + document.getElementById("geoLatit").value + " longitude=" + document.getElementById("geoLongt").value;
			}
			else 
			{
				document.getElementById('current').innerHTML="Functionality not available";
			}
		}

		function showPositionNew(p)
		{
			var latitude = parseFloat( p.coords.latitude );
			var longitude = parseFloat( p.coords.longitude );
			document.getElementById('current').innerHTML="latitude=" + latitude + " longitude=" + longitude;

			document.getElementById("geoLatit").value = latitude;
			document.getElementById("geoLongt").value = longitude;
			  /*
			var pos=new google.maps.LatLng( latitude , longitude);
			map.setCenter(pos);
			map.setZoom(14);
			
			var infowindow = new google.maps.InfoWindow({
			    content: "<strong>yes</strong>"
			});

			var marker = new google.maps.Marker({
			    position: pos,
			    map: map,
			    title:"You are here"
			});
			  */
			//displMap();
			  /*
			google.maps.event.addListener(marker, 'click', function() {
			  infowindow.open(map,marker);
			});
			*/
		}

if(isAndroid)
{
	 getLocation();
}
else
{
	 initialiseMap();initialise();
}

if("<%=mobilApp%>" == "true")
{
	$(function()
	{
		setTimeout(function()
		{
//			if(document.getElementById('geoLatit').value == "" || document.getElementById('geoLongt').value == "") 
			if(isAndroid == true && document.getElementById('latlng').value == "")
				getLocation();
			else if(document.getElementById('latlng').value == "") 
				initialiseMap();initialise();
		}, 6000);

	});	
}


function geocodeLatLng(geocoder, map, infowindow) 
{
	var input = document.getElementById('latlng').value;
	var latlngStr = input.split(',', 2);
	var latlng = {lat: parseFloat(latlngStr[0]), lng: parseFloat(latlngStr[1])};
	geocoder.geocode({'location': latlng}, function(results, status) 
	{
	  if (status === 'OK') 
	  {
		if (results[0]) 
		{
		  map.setZoom(19);
		  var marker = new google.maps.Marker({
			position: latlng,
			map: map
		  });
		  infowindow.setContent(results[0].formatted_address);
		  infowindow.open(map, marker);
		}
		else 
		{
	//	  window.displErr('No results found');
		}
  } 
	else 
	{
//		window.displErr('Geocoder failed due to: ' + status);
	}
});
}

</script>

<input type="hidden" name="custName" id="custName" value="<%=custName%>">
<input type="hidden" name="ltLgDist" id="ltLgDist" value="">
<div id="custNameDiv"></div>
</div>
</div>
</div>
</div>
</div>

<!-- Form footer Starts --->
<jsp:include page="/Envr/JSP/FooterCom.jsp" flush="true"/>
<!-- Form footer Ends --->
<script>
//alert("<%=rplNwScF%>");
if("<%=rplNwScF%>" == "" && "<%=rplNwAlF%>" == "Y" && "<%=cusRtlCd%>" != "")
{
	setTimeout(function()
	{
	//	createModal("RPL 5 & New Product", "/BirlaWhite/Mobile/RplnNwSchmEl.jsp?popupWin=Y&dsrPgEFl=Y&cusRtlCd=<%=cusRtlCd%>");
	//	$("#clsBtn").hide();
	}, 5000);  
}/**/
function locationChk()
{
	setTimeout(function()
	{
		var distCalc = distanceCalDsr(document.getElementById("latitute").value, document.getElementById("lgtitute").value, document.getElementById("geoLatit").value, document.getElementById("geoLongt").value, "M");
		if(distCalc < 520)
			return true;
		else
		{
			displErr("You are not at Customer`s Shop. Please Go to Purchaser Shop and retry. Your Distance from Purchaser's shop : " + distCalc);

			document.getElementById("cusRtlCd").value = "";
			
			if(isAndroid)
				getLocation();
			else
				initialise();

			return false;
		}
	}, 9000);  
}

	document.<%=formName%>.areaCode.value = "<%=areaCode%>";
if("<%=cusRtlCd%>" != "")	
	myVar = setInterval(distancChk, 5000);

</script>
<style>
.card1 {
    background: #fff;
    padding-left: 14px;
    /* margin-bottom: 5px; */
    padding-top: 5px;
}
.card1 {
    z-index: 0;
    border: none;
    border-radius: 0.3rem;
    position: relative;
}
.card1 {

    box-shadow: 0 5px 15px -5px rgb(0 0 0 / 15%);
}

#lstmntAvg .form-control
{
	max-width:80px;
	min-width: 70px !important;
}

.child_div {
    border: 1px solid #e5e2e2;
}	
</style>
