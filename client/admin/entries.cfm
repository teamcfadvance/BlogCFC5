<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\entries.cfm
	Author       : Raymond Camden 
	Created      : 04/07/06
	Last Updated : 
	History      : 
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.blog.deleteEntry(u)>
	</cfloop>
	<!--- clear cache --->
	<cfmodule template="../tags/scopecache.cfm" scope="application" clearall="true">
</cfif>


<cfparam name="url.keywords" default="">
<cfparam name="form.keywords" default="#url.keywords#">
<cfparam name="url.start" default="1">

<cfset params = structNew()>
<cfset params.mode = "short">
<cfif len(trim(form.keywords))>
	<cfset params.searchTerms = form.keywords>
	<cfset params.dontlogsearch = true>
</cfif>
<cfset params.maxEntries = application.maxEntries>
<cfset params.startRow = url.start>

<cfset entryData = application.blog.getEntries(params)>
<cfset entries = entryData.entries>

<!--- modify to add a proper view col --->
<!--- todo: only do rows in current view --->
<cfset queryAddColumn(entries,"viewurl",arrayNew(1))>
<cfloop query="entries">
	<cfset vu = application.blog.makeLink(id)>
	<cfset querySetCell(entries, "viewurl", vu & "?adminview=true", currentRow)>
</cfloop>

<cfmodule template="../tags/adminlayout.cfm" title="Entries">

	<cfoutput>
	<p>
	<cfif len(trim(form.keywords))>
	Your filtered search returned
	<cfelse>
	Your blog currently has 
	</cfif>
	<cfif entryData.totalEntries>
	#entryData.totalEntries# entries.
	<cfelseif entryData.totalEntries is 1>
	1 entry.
	<cfelse>
	0 entries.
	</cfif>
	</p>
	
	<p>
	<form action="entries.cfm" method="post">
	<input type="text" name="keywords" value="#form.keywords#"> <input type="submit" value="Filter by Keyword">
	</form>
	</p>
	</cfoutput>

	<cfmodule template="../tags/datatablenew.cfm" data="#entries#" editlink="entry.cfm" label="Entries"
			  linkcol="title" defaultsort="posted" defaultdir="desc" queryString="keywords=#urlencodedformat(form.keywords)#" totalRows="#entryData.totalEntries#">
		<cfmodule template="../tags/datacolnew.cfm" colname="title" label="Title" />
		<cfmodule template="../tags/datacolnew.cfm" colname="released" label="Released" format="yesno"/>
		<cfmodule template="../tags/datacolnew.cfm" colname="posted" label="Posted" format="datetime" />
		<cfmodule template="../tags/datacolnew.cfm" colname="views" label="Views" format="number" />
		<cfmodule template="../tags/datacolnew.cfm" label="View" data="<a href=""$viewurl$"">View</a>"  sort="false" />
	</cfmodule>
	
</cfmodule>


<cfsetting enablecfoutputonly=false>