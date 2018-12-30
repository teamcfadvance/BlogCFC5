<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Stats
	Author       : Raymond Camden 
	Created      : November 19, 2004
	Last Updated : April 13, 2007
	History      : reset for 5.0
				 : gettopviews didnt filter by blog. gettotalviews added (rkc 7/17/06)
				 : rb use, and subscriber count wsn't filtering by verified (rkc 8/20/06)
				 : comment mod support (rkc 12/7/06)
				 : top commenters support (rkc 2/28/07)
				 : fix MS Access (rkc 3/2/07)
				 : just formatting (rkc 4/13/07)
	Purpose		 : Stats
--->

<cfmodule template="../tags/adminlayout.cfm" title="Stats">
	
	<cfset dsn = application.blog.getProperty("dsn")>
	<cfset dbtype = application.blog.getProperty("blogdbtype")>
	<cfset blog = application.blog.getProperty("name")>
	<cfset username = application.blog.getProperty("username")>
	<cfset password = application.blog.getProperty("password")>
	
	<!--- get a bunch of crap --->
	<cfquery name="getTotalEntries" datasource="#dsn#" username="#username#" password="#password#">
		select	count(id) as totalentries, 
				min(posted) as firstentry,
				max(posted) as lastentry
		from	tblblogentries
		where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	</cfquery>

	<cfquery name="getTotalSubscribers" datasource="#dsn#" username="#username#" password="#password#">
		select	count(email) as totalsubscribers 
		from	#application.tableprefix#tblBlogSubscribers
		where 	#application.tableprefix#tblBlogSubscribers.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and		verified = 1
	</cfquery>

	<cfquery name="getTotalViews" datasource="#dsn#" username="#username#" password="#password#">
		select		sum(views) as total
		from		tblblogentries
		where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	</cfquery>

	<cfquery name="getTopViews" datasource="#dsn#" username="#username#" password="#password#">
		select		<cfif not listFindNoCase("mysql,oracle",dbtype)>top 10 </cfif> id, title, views
		from		tblblogentries
		where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif dbtype is "oracle">
		and		rownum <= 10
		</cfif>
		order by	views desc
		<cfif dbtype is "mysql">limit 10</cfif>		
	</cfquery>
	
	<!--- get last 30 --->
	<cfset thirtyDaysAgo = dateAdd("d", -30, now())>
	<cfquery name="last30" datasource="#dsn#" username="#username#" password="#password#">
		select	count(id) as totalentries
		from	tblblogentries
		where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and		posted >= <cfqueryparam cfsqltype="cf_sql_date" value="#thirtyDaysAgo#">
	</cfquery>
	
	<cfquery name="getTotalComments" datasource="#dsn#" username="#username#" password="#password#">
		select	count(#application.tableprefix#tblBlogComments.id) as totalcomments
		from	#application.tableprefix#tblBlogComments, tblblogentries
		where	#application.tableprefix#tblBlogComments.entryidfk = tblblogentries.id
		and		tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif application.commentmoderation>
		and		#application.tableprefix#tblBlogComments.moderated = 1
		</cfif>
	</cfquery>
	
	<!--- gets num of entries per category --->
	<cfquery name="getCategoryCount" datasource="#dsn#" username="#username#" password="#password#">
		select	categoryid, categoryname, count(categoryidfk) as total
		from	#application.tableprefix#tblBlogCategories, #application.tableprefix#tblBlogEntriesCategories
		where	#application.tableprefix#tblBlogEntriesCategories.categoryidfk = #application.tableprefix#tblBlogCategories.categoryid
		and		#application.tableprefix#tblBlogCategories.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		group by #application.tableprefix#tblBlogCategories.categoryid, #application.tableprefix#tblBlogCategories.categoryname
		<cfif dbtype is not "msaccess">
			order by total desc
		<cfelse>
			order by count(categoryidfk) desc
		</cfif>
	</cfquery>
	
	<!--- gets num of comments per entry, top 10 --->
	<cfquery name="topCommentedEntries" datasource="#dsn#" username="#username#" password="#password#">
		select 
		<cfif not listFindNoCase("mysql,oracle",dbtype)>top 10 </cfif>
		tblblogentries.id, tblblogentries.title, count(#application.tableprefix#tblBlogComments.id) as commentcount
		from			tblblogentries, tblblogcomments
		where			tblblogcomments.entryidfk = tblblogentries.id
		<cfif dbtype is "oracle">
		and		rownum <= 10
		</cfif>		
		and				tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif application.commentmoderation>
		and				tblblogcomments.moderated = 1
		</cfif>

		group by		tblblogentries.id, tblblogentries.title
		<cfif dbtype is not "msaccess">
			order by	commentcount desc
		<cfelse>
			order by 	count(tblblogcomments.id) desc
		</cfif>
		<cfif dbtype is "mysql">limit 10</cfif>
	</cfquery>

	<!--- gets num of comments per category, top 10 --->
	<cfquery name="topCommentedCategories" datasource="#dsn#" username="#username#" password="#password#">
		select 
		<cfif not listFindNoCase("mysql,oracle",dbtype)>top 10 </cfif>
						#application.tableprefix#tblBlogCategories.categoryid,
						#application.tableprefix#tblBlogCategories.categoryname,
						count(tblblogcomments.id) as commentcount
		from			#application.tableprefix#tblBlogCategories, tblblogcomments, #application.tableprefix#tblBlogEntriesCategories
		where			tblblogcomments.entryidfk = #application.tableprefix#tblBlogEntriesCategories.entryidfk
		<cfif dbtype is "oracle">
		and		rownum <= 10
		</cfif>		
		and				#application.tableprefix#tblBlogEntriesCategories.categoryidfk = #application.tableprefix#tblBlogCategories.categoryid
		and				#application.tableprefix#tblBlogCategories.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif application.commentmoderation>
		and				tblblogcomments.moderated = 1
		</cfif>		
		group by		#application.tableprefix#tblBlogCategories.categoryid, #application.tableprefix#tblBlogCategories.categoryname
		<cfif dbtype is not "msaccess">
			order by	commentcount desc
		<cfelse>
			order by	count(tblblogcomments.id) desc
		</cfif>
		<cfif dbtype is "mysql">limit 10</cfif>
	</cfquery>
		
	<cfquery name="topSearchTerms" datasource="#dsn#" username="#username#" password="#password#">
		select		
		<cfif not listFindNoCase("mysql,oracle",dbtype)>top 10 </cfif>
					searchterm, count(searchterm) as total
		from		#application.tableprefix#tblBlogSearchStats
		where		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif dbtype is "oracle">
		and		rownum <= 10
		</cfif>	
        group by	searchterm
		<cfif dbtype is not "msaccess">
			order by	total desc
		<cfelse>
			order by	count(searchterm) desc
		</cfif>
		<cfif dbtype is "mysql">limit 10</cfif>
	</cfquery>
	
	<cfquery name="topCommenters" datasource="#dsn#" username="#username#" password="#password#" maxrows="10">
	select	count(tblblogcomments.email) as emailCount, email, tblblogcomments.name
	from	tblblogcomments, tblblogentries
	where	tblblogcomments.entryidfk = tblblogentries.id
	and 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
	group by tblblogcomments.email, tblblogcomments.name
	<cfif dbtype is not "msaccess">
	order by emailCount desc
	<cfelse>
	order by count(tblblogcomments.email) desc
	</cfif>
	</cfquery>
				
	<cfset averageCommentsPerEntry = 0>	
	<cfif getTotalEntries.totalEntries>
		<cfset dur = dateDiff("d",getTotalEntries.firstEntry, now())>
		<cfset averageCommentsPerEntry = getTotalComments.totalComments / getTotalEntries.totalEntries>
	</cfif>

	<cfoutput>
	<script type="text/javascript">
	$(document).ready(function() {
		
		//create tabs
		$("##statstabs").tabs();
		
	});
	</script>
			
	<div id="statstabs">
	
		<ul>
			<li><a href="##generalstats">#rb("generalstats")#</a></li>
			<li><a href="##topviews">#rb("topviews")#</a></li>
			<li><a href="##categorystats">#rb("categorystats")#</a></li>
			<li><a href="##topentriesbycomments">#rb("topentriesbycomments")#</a></li>
			<li><a href="##topcategoriesbycomments">#rb("topcategoriesbycomments")#</a></li>
			<li><a href="##topsearchterms">#rb("topsearchterms")#</a></li>
			<li><a href="##topcommenters">#rb("topcommenters")#</a></li>
		</ul>
		
		<div id="generalstats">
		
			<table border="1" width="100%">
				<tr>
					<td width="50%">#rb("totalnumentries")#:</td>
					<td align="right">#numberFormat(getTotalEntries.totalEntries)#</td>
				</tr>
				<tr>
					<td width="50%">#rb("last30")#:</td>
					<td align="right">#numberFormat(last30.totalEntries)#</td>
				</tr>
				<tr>
					<td width="50%">#rb("last30avg")#:</td>
					<td align="right"><cfif last30.totalentries gt 0>#numberFormat(last30.totalEntries/30,"999.99")#<cfelse>&nbsp;</cfif></td>
				</tr>				
				<tr>
					<td width="50%">#rb("firstentry")#:</td>
					<td align="right"><cfif len(getTotalEntries.firstEntry)>#dateFormat(getTotalEntries.firstEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
				</tr>
				<tr>
					<td width="50%">#rb("lastentry")#:</td>
					<td align="right"><cfif len(getTotalEntries.lastEntry)>#dateFormat(getTotalEntries.lastEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
				</tr>
				<tr>
					<td width="50%">#rb("bloggingfor")#:</td>
					<td align="right"><cfif structKeyExists(variables, "dur")>#numberFormat(variables.dur)# #rb("days")#<cfelse>&nbsp;</cfif></td>
				</tr>
				<tr>
					<td width="50%">#rb("totalcomments")#:</td>
					<td align="right">#numberFormat(getTotalComments.totalComments)#</td>
				</tr>
				<tr>
					<td width="50%">#rb("avgcommentsperentry")#:</td>
					<td align="right">#numberFormat(averageCommentsPerEntry,"999.99")#</td>
				</tr>
				<tr>
					<td width="50%">#rb("totalviews")#:</td>
					<td align="right">#numberFormat(getTotalViews.total)#</td>
				</tr>
				<tr>
					<td width="50%">#rb("avgviews")#:</td>
					<td align="right">
						<cfif gettotalentries.totalentries gt 0 and gettotalviews.total gt 0>
						#numberFormat(gettotalviews.total/gettotalentries.totalentries,"999.99")#
						<cfelse>
						0
						</cfif>
					</td>
				</tr>
				<tr>
					<td width="50%">#rb("totalsubscribers")#:</td>
					<td align="right">#getTotalSubscribers.totalsubscribers#</td>
				</tr>
				
			</table>
	
		</div>

		<div id="topviews">
	
			<table border="1" width="100%">
				<cfloop query="getTopViews">
				<tr>
					<td width="50%"><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></td>
					<td align="right">#numberFormat(views)#</td>
				</tr>
				</cfloop>
			</table>

		</div>

		<div id="categorystats">
			<table border="1" width="100%">
				<cfloop query="getCategoryCount">
				<tr>
					<td width="50%"><a href="#application.blog.makeCategoryLink(categoryid)#">#categoryname#</a></td>
					<td align="right">#numberFormat(total)#</td>
				</tr>
				</cfloop>
			</table>
		</div>

		<div id="topentriesbycomments">
			
			<table border="1" width="100%">
				<cfloop query="topCommentedEntries">
				<tr>
					<td width="50%"><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></td>
					<td align="right">#numberFormat(commentCount)#</td>
				</tr>
				</cfloop>
			</table>
	
		</div>
	
		<div id="topcategoriesbycomments">
			
			<table border="1" width="100%">
				<cfloop query="topCommentedCategories">
					<!--- 
						This is ugly code.
						I want to find the avg number of posts
						per entry for this category.
					--->
					<cfquery name="getTotalForThisCat" dbtype="query">
						select	total
						from	getCategoryCount
						where	categoryid = '#categoryid#'
					</cfquery>
					<cfset avg = commentCount / getTotalForThisCat.total>
					<cfset avg = numberFormat(avg,"___.___")>
					<tr>
						<td width="50%"><a href="index.cfm?mode=cat&amp;catid=#categoryid#" rel="nofollow">#categoryname#</a></td>
						<td align="right">#commentCount# (#rb("avgcommentperentry")#: #avg#)</td>
					</tr>
				</cfloop>
			</table>
	
		</div>

		<div id="topsearchterms">
		
			<table border="1" width="100%">
				<cfloop query="topSearchTerms">
				<tr>
					<td width="50%"><a href="#application.rooturl#/index.cfm?mode=search&amp;search=#urlEncodedFormat(searchterm)#" rel="nofollow">#searchterm#</a></td>
					<td align="right">#numberFormat(total)#</td>
				</tr>
				</cfloop>
			</table>
			
		</div>

		<div id="topcommenters">
	
			<table border="1" width="100%">
				<cfloop query="topCommenters">
				<tr>
					<td width="50%">#name#</td>
					<td align="right">#numberFormat(emailcount)#</td>
				</tr>
				</cfloop>
			</table>
	
		</div>
	
	</div>
	</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>