<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\pages.cfm
	Author       : Raymond Camden 
	Created      : 07/07/06
	Last Updated : 
	History      : 
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.page.deletePage(u)>
	</cfloop>
</cfif>

<cfset pages = application.page.getPages()>

<!--- Kind of a hack, but lets add a new col for our url --->
<cfset queryAddColumn(pages, "url", arrayNew(1))>
<cfloop query="pages">
	<cfset querySetCell(pages, "url", "#application.rootURL#/page.cfm/#alias#", currentRow)>
</cfloop>

<cfmodule template="../tags/adminlayout.cfm" title="Pages">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif pages.recordCount gt 1>
		#pages.recordcount# pages
		<cfelseif pages.recordCount is 1>
		1 page
		<cfelse>
		0 pages
		</cfif>.
	</p>
	</cfoutput>

	<cfmodule template="../tags/datatable.cfm" data="#pages#" editlink="page.cfm" label="Pages"
			  linkcol="title" defaultsort="title" defaultdir="asc">
		<cfmodule template="../tags/datacol.cfm" colname="title" label="Title" />
		<cfmodule template="../tags/datacol.cfm" colname="url" label="URL" format="url" />
	</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>