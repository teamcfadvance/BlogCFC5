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

<cfmodule template="tags/layout.cfm" title="#rb("stats")#">
	
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
		from	tblblogsubscribers
		where 	tblblogsubscribers.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
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
		select	count(tblblogcomments.id) as totalcomments
		from	tblblogcomments, tblblogentries
		where	tblblogcomments.entryidfk = tblblogentries.id
		and		tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif application.commentmoderation>
		and		tblblogcomments.moderated = 1
		</cfif>
	</cfquery>
	
	<cfif application.blog.getProperty("allowtrackbacks")>
		<!--- RBB: 1/20/2006: get trackbacks --->
		<cfquery name="getTotalTrackbacks" datasource="#dsn#" username="#username#" password="#password#">
			select count(tblblogtrackbacks.id) as totaltrackbacks
			from	tblblogtrackbacks, tblblogentries
			where	tblblogtrackbacks.entryid = tblblogentries.id
			and		tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		</cfquery>
	</cfif>
		
	<!--- gets num of entries per category --->
	<cfquery name="getCategoryCount" datasource="#dsn#" username="#username#" password="#password#">
		select	categoryid, categoryname, count(categoryidfk) as total
		from	tblblogcategories, tblblogentriescategories
		where	tblblogentriescategories.categoryidfk = tblblogcategories.categoryid
		and		tblblogcategories.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		group by tblblogcategories.categoryid, tblblogcategories.categoryname
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
		tblblogentries.id, tblblogentries.title, count(tblblogcomments.id) as commentcount
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
						tblblogcategories.categoryid, 
						tblblogcategories.categoryname, 
						count(tblblogcomments.id) as commentcount
		from			tblblogcategories, tblblogcomments, tblblogentriescategories
		where			tblblogcomments.entryidfk = tblblogentriescategories.entryidfk
		<cfif dbtype is "oracle">
		and		rownum <= 10
		</cfif>		
		and				tblblogentriescategories.categoryidfk = tblblogcategories.categoryid
		and				tblblogcategories.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif application.commentmoderation>
		and				tblblogcomments.moderated = 1
		</cfif>		
		group by		tblblogcategories.categoryid, tblblogcategories.categoryname
		<cfif dbtype is not "msaccess">
			order by	commentcount desc
		<cfelse>
			order by	count(tblblogcomments.id) desc
		</cfif>
		<cfif dbtype is "mysql">limit 10</cfif>
	</cfquery>
	
	<cfif application.blog.getProperty("allowtrackbacks")>
		<!--- RBB 1/20/2006: gets num of trackbacks per entry, top 10 --->
		<cfquery name="topTrackbackedEntries" datasource="#dsn#" username="#username#" password="#password#">
			select 
			<cfif not listFindNoCase("mysql,oracle",dbtype)>top 10 </cfif>
			tblblogentries.id, tblblogentries.title, count(tblblogtrackbacks.id) as trackbackcount
			from			tblblogentries, tblblogtrackbacks
			where			tblblogtrackbacks.entryid = tblblogentries.id
			and				tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
			<cfif dbtype is "oracle">
            and		rownum <= 10
            </cfif>	
			group by		tblblogentries.id, tblblogentries.title
			<cfif dbtype is not "msaccess">
				order by	trackbackcount desc
			<cfelse>
				order by 	count(tblblogtrackbacks.id) desc
			</cfif>
			<cfif dbtype is "mysql">limit 10</cfif>
		</cfquery>	
	</cfif>
		
	<cfquery name="topSearchTerms" datasource="#dsn#" username="#username#" password="#password#">
		select		
		<cfif not listFindNoCase("mysql,oracle",dbtype)>top 10 </cfif>
					searchterm, count(searchterm) as total
		from		tblblogsearchstats
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
	<div class="date"><b>#rb("contents")#</b></div>
	<div class="body">
	<a href="##generalstats">#rb("generalstats")#</a><br>
	<a href="##topviews">#rb("topviews")#</a><br>
	<a href="##categorystats">#rb("categorystats")#</a><br>
	<a href="##topentriesbycomments">#rb("topentriesbycomments")#</a><br>
	<a href="##topcategoriesbycomments">#rb("topcategoriesbycomments")#</a><br>
	<cfif application.blog.getProperty("allowtrackbacks")><a href="##topentriesbytrackbacks">#rb("topentriesbytrackbacks")#</a><br></cfif>
	<a href="##topsearchterms">#rb("topsearchterms")#</a><br>
	<a href="##topcommenters">#rb("topcommenters")#</a><br>

	</div>
	
	<p />
	
	<div class="date"><a name="generalstats"></a><b>#rb("generalstats")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<tr>
			<td width="50%"><b>#rb("totalnumentries")#:</b></td>
			<td align="right">#getTotalEntries.totalEntries#</td>
		</tr>
		<tr>
			<td width="50%"><b>#rb("last30")#:</b></td>
			<td align="right">#last30.totalEntries#</td>
		</tr>
		<tr>
			<td width="50%"><b>#rb("last30avg")#:</b></td>
			<td align="right"><cfif last30.totalentries gt 0>#numberFormat(last30.totalEntries/30,"999.99")#<cfelse>&nbsp;</cfif></td>
		</tr>				
		<tr>
			<td width="50%"><b>#rb("firstentry")#:</b></td>
			<td align="right"><cfif len(getTotalEntries.firstEntry)>#dateFormat(getTotalEntries.firstEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td width="50%"><b>#rb("lastentry")#:</b></td>
			<td align="right"><cfif len(getTotalEntries.lastEntry)>#dateFormat(getTotalEntries.lastEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td width="50%"><b>#rb("bloggingfor")#:</b></td>
			<td align="right"><cfif isDefined("dur")>#dur# #rb("days")#<cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td width="50%"><b>#rb("totalcomments")#:</b></td>
			<td align="right">#getTotalComments.totalComments#</td>
		</tr>
		<tr>
			<td width="50%"><b>#rb("avgcommentsperentry")#:</b></td>
			<td align="right">#numberFormat(averageCommentsPerEntry,"999.99")#</td>
		</tr>
		<cfif application.blog.getProperty("allowtrackbacks")>
		<!--- RBB: 1/20/06: Added total trackbacks --->
		<tr>
			<td width="50%"><b>#rb("totaltrackbacks")#:</b></td>
			<td align="right">#getTotalTrackbacks.totalTrackbacks#</td>
		</tr>		
		</cfif>
		<tr>
			<td width="50%"><b>#rb("totalviews")#:</b></td>
			<td align="right">#getTotalViews.total#</td>
		</tr>
		<tr>
			<td width="50%"><b>#rb("avgviews")#:</b></td>
			<td align="right">
				<cfif gettotalentries.totalentries gt 0 and gettotalviews.total gt 0>
				#numberFormat(gettotalviews.total/gettotalentries.totalentries,"999.99")#
				<cfelse>
				0
				</cfif>
			</td>
		</tr>
		<tr>
			<td width="50%"><b>#rb("totalsubscribers")#:</b></td>
			<td align="right">#getTotalSubscribers.totalsubscribers#</td>
		</tr>
		
	</table>
	</div>

	<p />
	
	<div class="date"><a name="topviews"></a><b>#rb("topviews")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="getTopViews">
		<tr>
			<td width="50%"><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
			<td align="right">#views#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	<p />
	
	<div class="date"><a name="categorystats"></a><b>#rb("categorystats")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="getCategoryCount">
		<tr>
			<td width="50%"><a href="#application.blog.makeCategoryLink(categoryid)#">#categoryname#</a></td>
			<td align="right">#total#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	<p />
	
	<div class="date"><a name="topentriesbycomments"></a><b>#rb("topentriesbycomments")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="topCommentedEntries">
		<tr>
			<td width="50%"><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
			<td align="right">#commentCount#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	<p />
	
	<div class="date"><a name="topcategoriesbycomments"></a><b>#rb("topcategoriesbycomments")#</b></div>
	<div class="body">
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
				<td width="50%"><b><a href="index.cfm?mode=cat&catid=#categoryid#" rel="nofollow">#categoryname#</a></b></td>
				<td align="right">#commentCount# (#rb("avgcommentperentry")#: #avg#)</td>
			</tr>
		</cfloop>
	</table>
	</div>

	<p />
	
	<cfif application.blog.getProperty("allowtrackbacks")>
	<!--- RBB 1/20/2006: Added top entriex by trackbacks --->
	<div class="date"><a name="topentriesbytrackbacks"></a><b>#rb("topentriesbytrackbacks")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="topTrackbackedEntries">
		<tr>
			<td width="50%"><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
			<td align="right">#trackbackCount#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	<p />
	</cfif>
	
	<div class="date"><a name="topsearchterms"></a><b>#rb("topsearchterms")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="topSearchTerms">
		<tr>
			<td width="50%"><b><a href="#application.rooturl#/index.cfm?mode=search&search=#urlEncodedFormat(searchterm)#" rel="nofollow">#searchterm#</a></b></td>
			<td align="right">#total#</td>
		</tr>
		</cfloop>
	</table>
	</div>

	<p />
	<div class="date"><a name="topcommenters"></a><b>#rb("topcommenters")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="topCommenters">
		<tr>
			<td width="50%"><b>#name#</b></td>
			<td align="right">#emailcount#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>