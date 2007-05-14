<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\slideshows.cfm
	Author       : Raymond Camden 
	Created      : 9/2/06
	Last Updated : 12/14/06
	History      : handle deletes (rkc 9/6/06)
			 	 : handle getting folder from cfc (rkc 12/14/06)
--->

<cfset dir = application.slideshow.getSlideShowDir()>

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<!--- empty the directory --->
		<cfset slideshowdir = dir & "/" & u>
		<cfdirectory action="list" directory="#slideshowdir#" name="oldfiles">

		<cfloop query="oldfiles">
			<cffile action="delete" file="#slideshowdir#/#name#">
		</cfloop>
		<cfdirectory action="delete" directory="#slideshowdir#">
	</cfloop>
</cfif>

<cfdirectory directory="#dir#" name="slideshows">
<cfset queryAddColumn(slideshows, "formalname", arrayNew(1))>
<cfset queryAddColumn(slideshows, "pictures", arrayNew(1))>

<cfloop query="slideshows">
	<!--- get images --->
	<cfdirectory directory="#dir#/#name#" name="images">
	<cfquery name="images" dbtype="query">
	select	name
	from	images
	where	lower(name) like '%.jpg'
	or		lower(name) like '%.gif'
	</cfquery>
	<cfset querySetCell(slideshows, "pictures", images.recordCount, currentRow)>
</cfloop>

<cfmodule template="../tags/adminlayout.cfm" title="Slideshows">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif slideshows.recordCount gt 1>#slideshows.recordcount# slideshows<cfelseif slideshows.recordCount is 1>1 slideshow<cfelse>0 slideshows</cfif>. 
	</p>
	</cfoutput>
	
	<cfmodule template="../tags/datatable.cfm" data="#slideshows#" editlink="slideshow.cfm" label="Slideshows"
			  linkcol="name"  linkval="name" defaultsort="name">
		<cfmodule template="../tags/datacol.cfm" colname="name" label="Name" />
		<cfmodule template="../tags/datacol.cfm" colname="pictures" label="Pictures" />		
		<cfmodule template="../tags/datacol.cfm" label="View" data="<a href=""#application.rooturl#/slideshow.cfm/$name$"">View</a>" sort="false"/>
	</cfmodule>
	
</cfmodule>


<cfsetting enablecfoutputonly=false>