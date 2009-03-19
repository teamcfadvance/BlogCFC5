<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : recent.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : June 1, 2007
	History      : added processingdir (rkc 11/10/03)
				   New link code (rkc 7/12/05)
				   Hide future entries (rkc 6/1/07)
	Purpose		 : Display recent entries
--->

<cfmodule template="../../tags/scopecache.cfm" cachename="pod_recententries" scope="application" timeout="#application.timeout#">

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("recententries")#">

	<cfset params = structNew()>
	<cfset params.maxEntries = 5>
	<cfset params.releasedonly = true>
	<cfset entryData = application.blog.getEntries(duplicate(params))>
	<cfset entries = entryData.entries>
	<cfloop query="entries">
		<cfoutput><a href="#application.blog.makeLink(id)#">#title#</a><br></cfoutput>
	</cfloop>
	<cfif not entries.recordCount>
		<cfoutput>#application.resourceBundle.getResource("norecententries")#</cfoutput>
	</cfif>
	
</cfmodule>

</cfmodule>
	
<cfsetting enablecfoutputonly=false>
