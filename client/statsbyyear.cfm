<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Stats
	Author       : Raymond Camden 
	Created      : November 19, 2004
	Last Updated : December 31, 2008 (by Aaron S. West)
	History      : reset for 5.0
				 : gettopviews didnt filter by blog. gettotalviews added (rkc 7/17/06)
				 : rb use, and subscriber count wsn't filtering by verified (rkc 8/20/06)
				 : comment mod support (rkc 12/7/06)
	Purpose		 : Stats
--->

<cfmodule template="tags/layout.cfm" title="#rb("stats")#">
	
	<cfset dsn = application.blog.getProperty("dsn")>
	<cfset dbtype = application.blog.getProperty("blogdbtype")>
	<cfset blog = application.blog.getProperty("name")>
	<cfset username = application.blog.getProperty("username")>
	<cfset password = application.blog.getProperty("password")>
	<cfif isDefined("URL.statsYear") AND isNumericDate(URL.statsYear)>
		<cfset statsYear = URL.statsYear>
	<cfelse>
		<cfset statsYear = year(now())>
	</cfif>
	
	<!--- get a bunch of crap --->
	<cfquery name="getTotalEntries" datasource="#dsn#" username="#username#" password="#password#">
		select	count(id) as totalentries, 
				min(posted) as firstentry,
				max(posted) as lastentry
		from	tblblogentries
		where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and		year(posted) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">
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
		and		year(posted) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">
	</cfquery>

	<cfquery name="getTopViews" datasource="#dsn#" username="#username#" password="#password#">
		select		<cfif dbtype is not "mysql">top 10</cfif> id, title, views
		from		tblblogentries
		where 	tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and		year(posted) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">
		order by	views desc
		<cfif dbtype is "mysql">limit 10</cfif>		
	</cfquery>
	
	<cfquery name="getTotalComments" datasource="#dsn#" username="#username#" password="#password#">
		select	count(tblblogcomments.id) as totalcomments
		from	tblblogcomments, tblblogentries
		where	tblblogcomments.entryidfk = tblblogentries.id
		and		tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif application.commentmoderation>
		and		tblblogcomments.moderated = 1
		</cfif>
		and		year(tblblogcomments.posted) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">
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
		from	tblblogcategories, tblblogentriescategories, tblblogentries
		where	tblblogentriescategories.categoryidfk = tblblogcategories.categoryid
		and		tblblogcategories.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and 	tblblogentriescategories.entryidfk = tblblogentries.id
		and		year(tblblogentries.posted) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">
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
		<cfif dbtype is not "mysql">top 10</cfif>
		tblblogentries.id, tblblogentries.title, count(tblblogcomments.id) as commentcount
		from			tblblogentries, tblblogcomments
		where			tblblogcomments.entryidfk = tblblogentries.id
		and				tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		<cfif application.commentmoderation>
		and				tblblogcomments.moderated = 1
		</cfif>
		and		year(tblblogcomments.posted) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">
		
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
		<cfif dbtype is not "mysql">top 10</cfif>
						tblblogcategories.categoryid, 
						tblblogcategories.categoryname, 
						count(tblblogcomments.id) as commentcount
		from			tblblogcategories, tblblogcomments, tblblogentriescategories
		where			tblblogcomments.entryidfk = tblblogentriescategories.entryidfk
		and				tblblogentriescategories.categoryidfk = tblblogcategories.categoryid
		and				tblblogcategories.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and				year(tblblogcomments.posted) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">
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
			<cfif dbtype is not "mysql">top 10</cfif>
			tblblogentries.id, tblblogentries.title, count(tblblogtrackbacks.id) as trackbackcount
			from			tblblogentries, tblblogtrackbacks
			where			tblblogtrackbacks.entryid = tblblogentries.id
			and				tblblogentries.blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
			and				year(tblblogtrackbacks.created) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">
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
		<cfif dbtype is not "mysql">top 10</cfif>
					searchterm, count(searchterm) as total
		from		tblblogsearchstats
		where		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#blog#">
		and			year(searched) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#statsYear#">

		group by	searchterm
		<cfif dbtype is not "msaccess">
			order by	total desc
		<cfelse>
			order by	count(searchterm) desc
		</cfif>
		<cfif dbtype is "mysql">limit 10</cfif>
	</cfquery>
		
	<cfset averageCommentsPerEntry = 0>	
	<cfif getTotalEntries.totalEntries>
		<cfset dur = dateDiff("d",getTotalEntries.firstEntry, now())>
		<cfset averageCommentsPerEntry = getTotalComments.totalComments / getTotalEntries.totalEntries>
	</cfif>
	
	<cfoutput>
	<div class="date"><b>Stats for #statsYear#</b></div>
	<div class="body">
	<a href="##generalstats">#rb("generalstats")#</a><br />
	<a href="##topviews">#rb("topviews")#</a><br />
	<a href="##categorystats">#rb("categorystats")#</a><br />
	<a href="##topentriesbycomments">#rb("topentriesbycomments")#</a><br />
	<a href="##topcategoriesbycomments">#rb("topcategoriesbycomments")#</a><br />
	<cfif application.blog.getProperty("allowtrackbacks")><a href="##topentriesbytrackbacks">#rb("topentriesbytrackbacks")#</a><br /></cfif>
	<a href="##topsearchterms">#rb("topsearchterms")#</a><br />
	</div>
	
	<p />
	
	<div class="date"><a name="generalstats"></a><b>#rb("generalstats")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<tr>
			<td><b>#rb("totalnumentries")#:</b></td>
			<td>#getTotalEntries.totalEntries#</td>
		</tr>			
		<tr>
			<td><b>#rb("firstentry")#:</b></td>
			<td><cfif len(getTotalEntries.firstEntry)>#dateFormat(getTotalEntries.firstEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td><b>#rb("lastentry")#:</b></td>
			<td><cfif len(getTotalEntries.lastEntry)>#dateFormat(getTotalEntries.lastEntry,"mm/dd/yy")#<cfelse>&nbsp;</cfif></td>
		</tr>
		<tr>
			<td><b>#rb("totalcomments")#:</b></td>
			<td>#getTotalComments.totalComments#</td>
		</tr>
		<tr>
			<td><b>#rb("avgcommentsperentry")#:</b></td>
			<td>#numberFormat(averageCommentsPerEntry,"999.99")#</td>
		</tr>
		<cfif application.blog.getProperty("allowtrackbacks")>
		<!--- RBB: 1/20/06: Added total trackbacks --->
		<tr>
			<td><b>#rb("totaltrackbacks")#:</b></td>
			<td>#getTotalTrackbacks.totalTrackbacks#</td>
		</tr>		
		</cfif>
		<tr>
			<td><b>#rb("totalviews")#:</b></td>
			<td>#getTotalViews.total#</td>
		</tr>
		<tr>
			<td width="50%"><b>Average Views:</b></td>
			<td>
				<cfif gettotalentries.totalentries gt 0 and gettotalviews.total gt 0>
				#numberFormat(gettotalviews.total/gettotalentries.totalentries,"999.99")#
				<cfelse>
				0
				</cfif>
			</td>
		</tr>
		<tr>
			<td><b>#rb("totalsubscribers")#:</b></td>
			<td>#getTotalSubscribers.totalsubscribers#</td>
		</tr>
		
	</table>
	</div>

	<p />
	
	<div class="date"><a name="topviews"></a><b>#rb("topviews")#</b></div>
	<div class="body">
	<table border="1" width="100%">
		<cfloop query="getTopViews">
		<tr>
			<td><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
			<td>#views#</td>
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
			<td>#categoryname#</td>
			<td>#total#</td>
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
			<td><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
			<td>#commentCount#</td>
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
			<cftry>
			<cfif getTotalForThisCat.total neq 0 and getTotalForThisCat.total neq "">
				<cfset avg = commentCount / getTotalForThisCat.total>
				<cfset avg = numberFormat(avg,"___.___")>
			<cfelse>
				<cfset avg = 0>
			</cfif>
			<tr>
				<td><b><a href="index.cfm?mode=cat&catid=#categoryid#" rel="nofollow">#categoryname#</a></b></td>
				<td>#commentCount# (#rb("avgcommentperentry")#: #avg#)</td>
			</tr>
			<cfcatch><cfdump var="#getTotalForThisCat#"></cfcatch>
			</cftry>
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
			<td><b><a href="#application.blog.makeLink(id)#" rel="nofollow">#title#</a></b></td>
			<td>#trackbackCount#</td>
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
			<td><b><a href="#application.rooturl#/index.cfm?mode=search&search=#urlEncodedFormat(searchterm)#" rel="nofollow">#searchterm#</a></b></td>
			<td>#total#</td>
		</tr>
		</cfloop>
	</table>
	</div>
	
	</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>