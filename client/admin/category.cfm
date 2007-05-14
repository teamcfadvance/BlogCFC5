<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : category.cfm
	Author       : Raymond Camden 
	Created      : 04/07/06
	Last Updated : 
	History      : 
--->

<cftry>
	<cfif url.id neq 0>
		<cfset cat = application.blog.getCategory(url.id)>
		<cfparam name="form.name" default="#cat.categoryname#">
		<cfparam name="form.alias" default="#cat.categoryalias#">
	<cfelse>
		<cfparam name="form.name" default="">
		<cfparam name="form.alias" default="">
	</cfif>
	<cfcatch>
		<cflocation url="categories.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="categories.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>
	
	<cfif not len(trim(form.name))>
		<cfset arrayAppend(errors, "The name cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.alias))>
		<cfset form.alias = application.blog.makeTitle(form.name)>
	<cfelseif reFind("[^[:alnum:] -]", form.alias)>
		<cfset arrayAppend(errors, "Your alias may only contain letters, numbers, spaces, or hyphens.")>
	</cfif>
	<cfif not arrayLen(errors)>
		<cftry>
		<cfif url.id neq 0>
			<cfset application.blog.saveCategory(url.id, left(form.name,50), left(form.alias, 50))>
		<cfelse>
			<cfset application.blog.addCategory(left(form.name,50), left(form.alias,50))>
		</cfif>
		<cfcatch>
			<cfif findNoCase("already exists as a category", cfcatch.message)>
				<cfset arrayAppend(errors, "A category with this name already exists.")>
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
		</cftry>

		<cfif not arrayLen(errors)>
			<!--- clear the archive pod cache --->
			<cfmodule template="../tags/scopecache.cfm" action="clear" scope="application" cachename="pod_archives" />
			<cflocation url="categories.cfm" addToken="false">
		</cfif>
	</cfif>
	
</cfif>


<cfmodule template="../tags/adminlayout.cfm" title="Category Editor">

	<cfif structKeyExists(variables, "errors") and arrayLen(errors)>
		<cfoutput>
		<div class="errors">
		Please correct the following error(s):
		<ul>
		<cfloop index="x" from="1" to="#arrayLen(errors)#">
		<li>#errors[x]#</li>
		</cfloop>
		</ul>
		</div>
		</cfoutput>
	</cfif>
	
	<cfoutput>
	<p>
	Use the form below to edit your category. The alias field is used when creating SES (Search Engine Safe) URLs.
	If you leave the field blank, one will be generated for you. If wish to create it yourself, do not use any non-alphanumeric characters
	in the alias. Spaces should be replaced with dashes.
	</p>
	
	<form action="category.cfm?id=#url.id#" method="post">
	<table>
		<tr>
			<td align="right">name:</td>
			<td><input type="text" name="name" value="#form.name#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">alias:</td>
			<td><input type="text" name="alias" value="#form.alias#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="cancel" value="Cancel"> <input type="submit" name="save" value="Save"></td>
		</tr>
	</table>
	</form>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly=false>
