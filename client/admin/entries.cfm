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
</cfif>


<cfparam name="url.keywords" default="">
<cfparam name="form.keywords" default="#url.keywords#">

<cfset params = structNew()>
<cfset params.mode = "short">
<cfif len(trim(form.keywords))>
	<cfset params.searchTerms = form.keywords>
	<cfset params.dontlogsearch = true>
</cfif>
<cfset entries = application.blog.getEntries(params)>

<cfmodule template="../tags/adminlayout.cfm" title="Entries">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif entries.recordCount>
		#entries.recordcount# entries
		<cfelseif entries.recordCount is 1>
		1 entry
		<cfelse>
		0 entries
		</cfif>.
	</p>
	
	<p>
	<form action="entries.cfm" method="post">
	<input type="text" name="keywords" value="#form.keywords#"> <input type="submit" value="Filter by Keyword">
	</form>
	</p>
	
	</cfoutput>

	<cfmodule template="../tags/datatable.cfm" data="#entries#" editlink="entry.cfm" label="Entries"
			  linkcol="title" defaultsort="posted" defaultdir="desc" queryString="keywords=#urlencodedformat(form.keywords)#">
		<cfmodule template="../tags/datacol.cfm" colname="title" label="Title" />
		<cfmodule template="../tags/datacol.cfm" colname="released" label="Released" format="yesno"/>
		<cfmodule template="../tags/datacol.cfm" colname="posted" label="Posted" format="datetime" />
		<cfmodule template="../tags/datacol.cfm" colname="views" label="Views" format="number" />
		<cfmodule template="../tags/datacol.cfm" label="View" data="<a href=""#application.rooturl#/index.cfm?mode=entry&entry=$id$"">View</a>" sort="false"/>
	</cfmodule>
	
</cfmodule>


<cfsetting enablecfoutputonly=false>