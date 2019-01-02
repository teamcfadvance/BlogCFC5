<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Author       : Jeffry Houser (Probably, I think this is all me)
	Created      : 07/09/08
	Last Updated : 12/30/2018
	History      : reference downloadTracker.cfc instead of the methods in Blog.cfc; make the year dynamic
--->

<cfset fromDate = createDate(2006, 1, 1)>
<cfset toDate = Now()>


<cfparam name="form.startmonth" default="1" >
<cfparam name="form.startDay" default="1" >
<cfparam name="form.startYear" default="#year(fromDate)#" >
<cfparam name="form.endmonth" default="1" >
<cfparam name="form.endDay" default="1" >
<cfparam name="form.endYear" default="#year(toDate)#" >

<cfmodule template="../tags/adminlayout.cfm" title="Reports">
<!--- if submitted create the dates --->
<cfif IsDefined('form.submit')>
	<cfset StartDate = CreateDate(form.startyear,form.startmonth,form.startday)>
	<cfset EndDate = CreateDate(form.Endyear,form.Endmonth,form.Endday)>
	
	<cfset DownloadReport =  application.downloadTracker.generateDownloadReport(startdate,enddate)>
	<cfset ImpressionReport =  application.downloadTracker.generateImpressionReport(startdate,enddate)>


	
	<Cfoutput>
		<Cfdump var="#createodbcdate(StartDate)#"><Br/>
		<Cfdump var="#createodbcdate(EndDate)#"><Br/>
		Warning: Doesn't differentiate between listened to on-line and downloaded [yet] we did start collecting the data.<Br/>
	    Warning 2: This stuff was lots more performant when I Created specific indexes, but the specifics are lost in time.
	</Cfoutput>

</cfif>
<!--- 
		Warning: Doesn't differentiate between listened to on-line and downloaded [yet] we did start collecting the data.

But, here ish ow to do it 

SELECT     TOP 100 PERCENT dbo.#application.tableprefix#tblBlogEntries.id, dbo.#application.tableprefix#tblBlogEntries.title, dbo.#application.tableprefix#tblblogenclosuredownloads.online, COUNT(dbo.#application.tableprefix#tblblogenclosuredownloads.entryid) AS TotalDownloads
FROM         dbo.#application.tableprefix#tblBlogEntries INNER JOIN
                      dbo.#application.tableprefix#tblblogenclosuredownloads ON dbo.#application.tableprefix#tblBlogEntries.id = dbo.#application.tableprefix#tblblogenclosuredownloads.entryid
where dbo.#application.tableprefix#tblblogenclosuredownloads.downloaddate between {d '2008-06-01'} and {d '2008-06-30'} 
GROUP BY dbo.#application.tableprefix#tblBlogEntries.id, dbo.#application.tableprefix#tblBlogEntries.title, dbo.#application.tableprefix#tblblogenclosuredownloads.online
ORDER BY dbo.#application.tableprefix#tblBlogEntries.title

---->
<cfoutput>
<form action="downloads.cfm" method="post">
<table>
	<tr>
		<td><strong>Start Date</strong></td>
		<td><strong>End Date</strong></td>
	</tr>
	<tr>
		<td>
			<select name="StartMonth">
				<option value="1" <cfif form.startmonth is 1>selected</cfif>>January</option>
				<option value="2" <cfif form.startmonth is 2>selected</cfif>>February</option>
				<option value="3" <cfif form.startmonth is 3>selected</cfif>>March</option>
				<option value="4" <cfif form.startmonth is 4>selected</cfif>>April</option>
				<option value="5" <cfif form.startmonth is 5>selected</cfif>>May</option>
				<option value="6" <cfif form.startmonth is 6>selected</cfif>>June</option>
				<option value="7" <cfif form.startmonth is 7>selected</cfif>>July</option>
				<option value="8" <cfif form.startmonth is 8>selected</cfif>>August</option>
				<option value="9" <cfif form.startmonth is 9>selected</cfif>>September</option>
				<option value="10" <cfif form.startmonth is 10>selected</cfif>>October</option>
				<option value="11" <cfif form.startmonth is 11>selected</cfif>>November</option>
				<option value="12" <cfif form.startmonth is 12>selected</cfif>>December</option>
			</select>
			<select name="StartDay">
				<option value="1" <cfif form.StartDay is 1>selected</cfif>>1</option>
				<option value="2" <cfif form.StartDay is 2>selected</cfif>>2</option>
				<option value="3" <cfif form.StartDay is 3>selected</cfif>>3</option>
				<option value="4" <cfif form.StartDay is 4>selected</cfif>>4</option>
				<option value="5" <cfif form.StartDay is 5>selected</cfif>>5</option>
				<option value="6" <cfif form.StartDay is 6>selected</cfif>>6</option>
				<option value="7" <cfif form.StartDay is 7>selected</cfif>>7</option>
				<option value="8" <cfif form.StartDay is 8>selected</cfif>>8</option>
				<option value="9" <cfif form.StartDay is 9>selected</cfif>>9</option>
				<option value="10" <cfif form.StartDay is 10>selected</cfif>>10</option>
				<option value="11" <cfif form.StartDay is 11>selected</cfif>>11</option>
				<option value="12" <cfif form.StartDay is 12>selected</cfif>>12</option>
				<option value="13" <cfif form.StartDay is 13>selected</cfif>>13</option>
				<option value="14" <cfif form.StartDay is 14>selected</cfif>>14</option>
				<option value="15" <cfif form.StartDay is 15>selected</cfif>>15</option>
				<option value="16" <cfif form.StartDay is 16>selected</cfif>>16</option>
				<option value="17" <cfif form.StartDay is 17>selected</cfif>>17</option>
				<option value="18" <cfif form.StartDay is 18>selected</cfif>>18</option>
				<option value="19" <cfif form.StartDay is 19>selected</cfif>>19</option>
				<option value="20" <cfif form.StartDay is 20>selected</cfif>>20</option>
				<option value="21" <cfif form.StartDay is 21>selected</cfif>>21</option>
				<option value="22" <cfif form.StartDay is 22>selected</cfif>>22</option>
				<option value="23" <cfif form.StartDay is 23>selected</cfif>>23</option>
				<option value="24" <cfif form.StartDay is 24>selected</cfif>>24</option>
				<option value="25" <cfif form.StartDay is 25>selected</cfif>>25</option>
				<option value="26" <cfif form.StartDay is 26>selected</cfif>>26</option>
				<option value="27" <cfif form.StartDay is 27>selected</cfif>>27</option>
				<option value="28" <cfif form.StartDay is 28>selected</cfif>>28</option>
				<option value="29" <cfif form.StartDay is 29>selected</cfif>>29</option>
				<option value="30" <cfif form.StartDay is 30>selected</cfif>>30</option>
				<option value="31" <cfif form.StartDay is 31>selected</cfif>>31</option>
			</select>
			<select name="StartYear">
				<cfloop from="#fromDate#" to="#toDate#" index="i" step="#CreateTimeSpan(365,0,0,0)#">
					<cfset year = year(i)>
					<cfoutput><option value="#year#" <cfif form.StartYear is year>selected</cfif>>#year#</option></cfoutput>
				</cfloop>
			</select>
		</td>
		<td>
			<select name="EndMonth">
				<option value="1" <cfif form.endmonth is 1>selected</cfif>>January</option>
				<option value="2" <cfif form.endmonth is 2>selected</cfif>>February</option>
				<option value="3" <cfif form.endmonth is 3>selected</cfif>>March</option>
				<option value="4" <cfif form.endmonth is 4>selected</cfif>>April</option>
				<option value="5" <cfif form.endmonth is 5>selected</cfif>>May</option>
				<option value="6" <cfif form.endmonth is 6>selected</cfif>>June</option>
				<option value="7" <cfif form.endmonth is 7>selected</cfif>>July</option>
				<option value="8" <cfif form.endmonth is 8>selected</cfif>>August</option>
				<option value="9" <cfif form.endmonth is 9>selected</cfif>>September</option>
				<option value="10" <cfif form.endmonth is 10>selected</cfif>>October</option>
				<option value="11" <cfif form.endmonth is 11>selected</cfif>>November</option>
				<option value="12" <cfif form.endmonth is 12>selected</cfif>>December</option>
			</select>
			<select name="EndDay">
				<option value="1" <cfif form.endDay is 1>selected</cfif>>1</option>
				<option value="2" <cfif form.endDay is 2>selected</cfif>>2</option>
				<option value="3" <cfif form.endDay is 3>selected</cfif>>3</option>
				<option value="4" <cfif form.endDay is 4>selected</cfif>>4</option>
				<option value="5" <cfif form.endDay is 5>selected</cfif>>5</option>
				<option value="6" <cfif form.endDay is 6>selected</cfif>>6</option>
				<option value="7" <cfif form.endDay is 7>selected</cfif>>7</option>
				<option value="8" <cfif form.endDay is 8>selected</cfif>>8</option>
				<option value="9" <cfif form.endDay is 9>selected</cfif>>9</option>
				<option value="10" <cfif form.endDay is 10>selected</cfif>>10</option>
				<option value="11" <cfif form.endDay is 11>selected</cfif>>11</option>
				<option value="12" <cfif form.endDay is 12>selected</cfif>>12</option>
				<option value="13" <cfif form.endDay is 13>selected</cfif>>13</option>
				<option value="14" <cfif form.endDay is 14>selected</cfif>>14</option>
				<option value="15" <cfif form.endDay is 15>selected</cfif>>15</option>
				<option value="16" <cfif form.endDay is 16>selected</cfif>>16</option>
				<option value="17" <cfif form.endDay is 17>selected</cfif>>17</option>
				<option value="18" <cfif form.endDay is 18>selected</cfif>>18</option>
				<option value="19" <cfif form.endDay is 19>selected</cfif>>19</option>
				<option value="20" <cfif form.endDay is 20>selected</cfif>>20</option>
				<option value="21" <cfif form.endDay is 21>selected</cfif>>21</option>
				<option value="22" <cfif form.endDay is 22>selected</cfif>>22</option>
				<option value="23" <cfif form.endDay is 23>selected</cfif>>23</option>
				<option value="24" <cfif form.endDay is 24>selected</cfif>>24</option>
				<option value="25" <cfif form.endDay is 25>selected</cfif>>25</option>
				<option value="26" <cfif form.endDay is 26>selected</cfif>>26</option>
				<option value="27" <cfif form.endDay is 27>selected</cfif>>27</option>
				<option value="28" <cfif form.endDay is 28>selected</cfif>>28</option>
				<option value="29" <cfif form.endDay is 29>selected</cfif>>29</option>
				<option value="30" <cfif form.endDay is 30>selected</cfif>>30</option>
				<option value="31" <cfif form.endDay is 31>selected</cfif>>31</option>
			</select>
			<select name="EndYear">
				<cfloop from="#fromDate#" to="#toDate#" index="i" step="#CreateTimeSpan(365,0,0,0)#">
					<cfset year = year(i)>
					<cfoutput><option value="#year#" <cfif form.EndYear is year>selected</cfif>>#year#</option></cfoutput>
				</cfloop>
			</select>
		</td>
		<td>
			<input type="submit" name="Submit" value="Submit">
		</td>
	</tr>
</table>
</form>

<cfif IsDefined("DownloadReport")>
	<h1>Download Report</h1>
	<table>
		<tr>
			<td><strong>Release Date</strong></td>
			<td><strong>Title</strong></td>
			<td><strong>Total Downloads</strong></td>
		</tr>
		<cfloop query="DownloadReport">
			<tr>
				<td>#DateFormat(DownloadReport.posted,"mm/dd/yyyy")#</td>
				<td>#DownloadReport.Title#</td>
				<td>#DownloadReport.TotalDownloads#</td>
			</tr>
		</cfloop>
	</table>

</cfif>
<cfif IsDefined("ImpressionReport")>
	<h1>Impression Report</h1>
	<table>
		<tr>
			<td><strong>Media</strong></td>
			<td><strong>Total Impressions</strong></td>
		</tr>
		<cfloop query="ImpressionReport">
			<tr>
				<td>#ImpressionReport.MediaText#</td>
				<td>#ImpressionReport.Description#</td>
				<td>#ImpressionReport.totalViews#</td>
			</tr>
		</cfloop>
	</table>

</cfif>



</cfoutput>


</cfmodule>