<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/entries.cfm
	Author       : Raymond Camden 
	Created      : 04/26/06
	Last Updated : 
	History      : 
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.blog.deleteTrackback(u)>
	</cfloop>
</cfif>

<cfset tbs = application.blog.getTrackbacks(sortdir="desc")>

<cfmodule template="../tags/adminlayout.cfm" title="Trackbacks">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif tbs.recordCount>
		#tbs.recordcount# trackbacks
		<cfelseif tbs.recordCount is 1>
		1 trackback
		<cfelse>
		0 trackbacks
		</cfif>.
	</p>
	</cfoutput>
	
	<cfmodule template="../tags/datatable.cfm" data="#tbs#" editlink="trackback.cfm" label="Trackbacks"
			  linkcol="" defaultsort="created" defaultdir="desc" showAdd="false">
		<cfmodule template="../tags/datacol.cfm" colname="title" label="Title" width="300" />
		<cfmodule template="../tags/datacol.cfm" colname="blogname" label="Blog Name" width="250" />
		<cfmodule template="../tags/datacol.cfm" colname="created" label="Posted" format="datetime" width="150" />
		<cfmodule template="../tags/datacol.cfm" colname="excerpt" label="Excerpt" left="75"/>
	</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>
