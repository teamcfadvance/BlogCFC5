<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : search.cfm
	Author       : Raymond Camden 
	Created      : February 9, 2007
	Last Updated : April 19, 2007
	History      : Small changes to search display (rkc 4/19/07)
	Purpose		 : Search Logic
--->

<!--- allow for /xxx shortcut --->
<cfset searchAlias = listLast(cgi.path_info, "/")>
<cfparam name="form.search" default="#searchAlias#">
<cfparam name="form.category" default="">

<cfif not len(trim(form.search))>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfset form.search = htmlEditFormat(trim(form.search))>

<cfset cats = application.blog.getCategories()>

<cfset params = structNew()>
<cfset params.searchTerms = form.search>
<cfif form.category is not "">
	<cfset params.byCat = form.category>
</cfif>
<cfset params.maxEntries = 100>
<cfset results = application.blog.getEntries(params)>

<cfset title = rb("search")>

<cfmodule template="tags/layout.cfm" title="#title#">

	<cfoutput>
	<div class="date"><b>#title#</b></div>
	<div class="body">
	<form action="#application.rooturl#/search.cfm" method="post">
	<p>
	You searched for <input type="text" name="search" value="#form.search#"> in 
	<select name="category">
	<option value="" <cfif form.category is "">selected</cfif>>all categories</option>
	<cfloop query="cats">
	<option value="#categoryid#" <cfif form.category is categoryid>selected</cfif>>#categoryname#</option>
	</cfloop>
	</select>
	There  
		<cfif results.recordCount is 1>was one result<cfelse>were #results.recordCount# results</a></cfif>.
	<input type="submit" value="Search Again"> 	
	</p>
	</form>
	<style>
	.highlight { background-color: yellow; }
	</style>
	<cfif results.recordCount>
		<cfloop query="results">
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

			<!---<cfoutput><b>debug: #match#, end=#end#, len new #len(newbody)#<P></b></cfoutput>--->

			<cfif len(newbody) gt 500>
				<cfif match gt 1>
					<cfoutput>mid on #match-250#, #end-match#<P></cfoutput>
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

			<cfset excerpt = replaceNoCase(excerpt,form.search,"<span class='highlight'>#form.search#</span>","all")>
			<cfset newtitle = replaceNoCase(title,form.search,"<span class='highlight'>#form.search#</span>","all")>
			<p>
			<b><a href="#application.blog.makeLink(id)#">#newtitle#</a></b> (#application.localeUtils.dateLocaleFormat(posted)# #application.localeUtils.timeLocaleFormat(posted)#)<br />
			<br />
			#excerpt#
		</p>
		</cfloop>
	</cfif>
	
	</div>
	</cfoutput>

</cfmodule>