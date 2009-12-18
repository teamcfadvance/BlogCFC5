<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : search.cfm
	Author       : Raymond Camden 
	Created      : February 9, 2007
	Last Updated : November 17, 2007
	History      : Small changes to search display (rkc 4/19/07)
				 : Fix by Dan S to block unreleased entries (rkc 11/17/07)
	Purpose		 : Search Logic
--->

<!--- allow for /xxx shortcut --->
<cfif cgi.path_info is not "/search.cfm">
	<cfset searchAlias = listLast(cgi.path_info, "/")>
<cfelse>
	<cfset searchAlias = "">
</cfif>

<cfif structKeyExists(url, "search")>
	<cfset form.search = url.search>
</cfif>
<cfif structKeyExists(url, "category")>
	<cfset form.category = url.category>
</cfif>
<cfparam name="url.start" default="1">
<cfparam name="form.search" default="#searchAlias#">
<cfparam name="form.category" default="">

<cfif not len(trim(form.search)) or not isNumeric(url.start) or url.start lt 1 or round(url.start) neq url.start>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfset form.search = left(htmlEditFormat(trim(form.search)),255)>

<cfset cats = application.blog.getCategories()>

<cfset params = structNew()>
<cfset params.searchTerms = form.search>
<cfif form.category is not "">
	<cfset params.byCat = form.category>
</cfif>
<cfset params.startrow = url.start>
<cfset params.maxEntries = application.maxEntries>
<!---// dgs: only get released items //--->
<cfset params.releasedonly = true />
<cfset results = application.blog.getEntries(params)>

<cfset title = rb("search")>

<cfmodule template="tags/layout.cfm" title="#title#">

	<cfoutput>
	<div class="date"><b>#title#</b></div>
	<div class="body">
	<form action="#application.rooturl#/search.cfm" method="post">
	<p>
	You searched for <input type="text" name="search" value="#form.search#" /> in 
	<select name="category">
	<option value="" <cfif form.category is "">selected="selected"</cfif>>all categories</option>
	<cfloop query="cats">
	<option value="#categoryid#" <cfif form.category is categoryid>selected="selected"</cfif>>#categoryname#</option>
	</cfloop>
	</select><br/>
	There  
		<cfif results.totalEntries is 1>was one result<cfelse>were #results.totalEntries# results</cfif>.
	<input type="submit" value="Search Again" /> 	
	</p>
	</form>
	<cfif results.entries.recordCount>
		<cfloop query="results.entries">
			<!--- remove html from result. --->
			<cfset newbody = rereplace(body, "<.*?>", "", "all")>
			<!--- highlight search terms --->
			<!--- before we "highlight" our matches in the body, we need to find the first match.
			We will create an except that begins 250 before and ends 250 after. This will give us slightly
			different sized excerpts, but between you, me, and the door, I think thats ok. It is also possible
			the match isn't in the entry but just the title. --->
			<cfset match = findNoCase(form.search, newbody)>
			<cfif match lte 250>
				<cfset match = 1>
			</cfif>
			<cfset end = match + len(form.search) + 500>

			<cfif len(newbody) gt 500>
				<cfif match gt 1>
					<cfset excerpt = "..." & mid(newbody, match-250, end-match)>
				<cfelse>
					<cfset excerpt = left(newbody,end)>
				</cfif>
				<cfif len(newbody) gt end>
					<cfset excerpt = excerpt & "...">
				</cfif>
			<cfelse>
				<cfset excerpt = newbody>
			</cfif>	

			<!---
			We switched to regular expressions to highlight our search terms. However, it is possible for someone to search 
			for a string that isn't a valid regex. So if we fail, we just don't bother highlighting.
			--->
			<cftry>
				<cfset excerpt = reReplaceNoCase(excerpt, "(#form.search#)", "<span class='highlight'>\1</span>","all")>
				<cfset newtitle = reReplaceNoCase(title, "(#form.search#)", "<span class='highlight'>\1</span>","all")>
				<cfcatch>
					<!--- only need to set newtitle, excerpt already exists. --->
					<cfset newtitle = title>
				</cfcatch>
			</cftry>			
			<p>
			<b><a href="#application.blog.makeLink(id)#">#newtitle#</a></b> (#application.localeUtils.dateLocaleFormat(posted)# #application.localeUtils.timeLocaleFormat(posted)#)<br />
			<br />
			#excerpt#
			<cfif currentRow neq recordCount>
			<hr />
			</cfif>
		</p>
		</cfloop>
		<cfif results.totalEntries gte url.start + application.maxEntries>
			<p align="right">
			<cfif url.start gt 1>
				<a href="search.cfm?search=#urlEncodedFormat(form.search)#&amp;category=#form.category#&amp;start=#url.start-application.maxEntries#">Previous Results</a>
			<cfelse>
				Previous Entries
			</cfif>
			-
			<cfif (url.start + application.maxEntries-1) lt results.totalEntries>
				<a href="search.cfm?search=#urlEncodedFormat(form.search)#&amp;category=#form.category#&amp;start=#url.start+application.maxEntries#">Next Results</a>
			<cfelse>
				Next Entries
			</cfif>
			</p>
		</cfif>
	</cfif>
	
	</div>
	</cfoutput>

</cfmodule>