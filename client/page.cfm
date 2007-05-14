<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : page.cfm
	Author       : Raymond Camden 
	Created      : July 8, 2006
	Last Updated : July 15, 2006
	History      : New logic to get path (rkc 7/15/06)
	Purpose		 : Page render
--->

<cfset pageAlias = listLast(cgi.path_info, "/")>

<cfif not len(pageAlias)>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfset page = application.page.getPageByAlias(pageAlias)>

<cfif structIsEmpty(page)>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfmodule template="tags/layout.cfm" title="#page.title#">

	<cfoutput>
	<div class="date"><b>#page.title#</b></div>
	<div class="body">
	#application.blog.renderEntry(page.body)#
	</div>
	</cfoutput>

</cfmodule>