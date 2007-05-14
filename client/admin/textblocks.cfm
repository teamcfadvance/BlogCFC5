<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\pages.cfm
	Author       : Raymond Camden 
	Created      : 07/07/06
	Last Updated : 7/16/06
	History      : Typo, wrong title (rkc 7/16/06)
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.textblock.deleteTextblock(u)>
	</cfloop>
</cfif>

<cfset tbs = application.textblock.getTextblocks()>


<cfmodule template="../tags/adminlayout.cfm" title="Textblocks">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif tbs.recordCount gt 1>
		#tbs.recordcount# textblocks.
		<cfelseif tbs.recordCount is 1>
		1 textblock.
		<cfelse>
		0 textblocks.
		</cfif>
	</p>
	</cfoutput>

	<cfmodule template="../tags/datatable.cfm" data="#tbs#" editlink="textblock.cfm" label="Textblocks"
			  linkcol="label" defaultsort="label" defaultdir="asc">
		<cfmodule template="../tags/datacol.cfm" colname="label" label="Label" />
		<cfmodule template="../tags/datacol.cfm" colname="body" label="Body" left="50" />
	</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>