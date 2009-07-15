<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\categories.cfm
	Author       : Raymond Camden 
	Created      : 04/07/06
	Last Updated : 
	History      : 
--->

<cfif not application.blog.isBlogAuthorized('ManageCategories')>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.blog.deleteCategory(u)>
	</cfloop>
</cfif>


<cfset categories = application.blog.getCategories()>

<cfmodule template="../tags/adminlayout.cfm" title="Categories">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif categories.recordCount>
		#categories.recordcount# categories
		<cfelseif categories.recordCount is 1>
		1 category
		<cfelse>
		0 categories
		</cfif>.
	</p>
	</cfoutput>

	<cfmodule template="../tags/datatable.cfm" data="#categories#" editlink="category.cfm" label="Categories"
			  linkcol="categoryname" linkval="categoryid">
		<cfmodule template="../tags/datacol.cfm" colname="categoryname" label="Category" />
		<cfmodule template="../tags/datacol.cfm" colname="entrycount" label="Entries" />
	</cfmodule>
	
</cfmodule>


<cfsetting enablecfoutputonly=false>