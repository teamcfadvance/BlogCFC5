<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/page.cfm
	Author       : Raymond Camden
	Created      : 07/07/06
	Last Updated : 07/12/06
	History      : Mention code, textblock support (rkc 7/12/06)
--->

<cfparam name="url.id" default="0">

<cfif url.id is not 0>
	<cftry>
	<cfset page = application.page.getPage(url.id)>
	<cfif structIsEmpty(page)>
		<cflocation url="pages.cfm" addToken="false">
	</cfif>
	<cfcatch>
		<cflocation url="pages.cfm" addToken="false">
	</cfcatch>
	</cftry>
	<cfparam name="form.title" default="#page.title#">
	<cfparam name="form.body" default="#page.body#">
	<cfparam name="form.alias" default="#page.alias#">
	<cfparam name="form.showlayout" default="#page.showlayout#">
	<cfif not isBoolean(form.showlayout)>
		<cfset form.showlayout = true>
	</cfif>
<cfelse>
	<cfparam name="form.title" default="">
	<cfparam name="form.body" default="">
	<cfparam name="form.alias" default="">
	<cfparam name="form.showlayout" default="1">
</cfif>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="pages.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>

	<cfif not len(trim(form.title))>
		<cfset arrayAppend(errors, "The title cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.body))>
		<cfset arrayAppend(errors, "The body cannot be blank.")>
	</cfif>
	<cfif len(form.title) and not len(form.alias)>
		<cfset form.alias = application.blog.makeTitle(form.title)>
	</cfif>

	<cfif not arrayLen(errors)>
		<cfset application.page.savePage(url.id, left(form.title,255), left(form.alias,50), form.body, form.showlayout)>
		<cflocation url="pages.cfm" addToken="false">
	</cfif>

</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="Page Editor">

	<cfoutput>
	<p>
	Use the form below to create a page for your blog. The alias will be auto-generated if left blank, which is recommended.
	Aliases must be unique per page. If you change your page title, you may want to remove the alias so it will be auto-generated again.
	A page set to not show layout will be displayed "plain" with no blog UI around the content. The title of the page will <b>not</b> be displayed. Only the body.
	</p>

	<p>
	You can use &lt;code&gt;....&lt;/code&gt; to add formatting to code blocks.<br />
	You can dynamically include textblocks using &lt;textblock label="..."&gt;.
	</p>
	</cfoutput>

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
	<form action="page.cfm?id=#url.id#" method="post">
	<table>
		<tr>
			<td align="right">title:</td>
			<td><input type="text" name="title" value="#form.title#" class="txtField" maxlength="255"></td>
		</tr>
		<tr>
			<td align="right">alias:</td>
			<td><input type="text" name="alias" value="#form.alias#" class="txtField" maxlength="100"></td>
		</tr>
		<tr valign="top">
			<td align="right">body:</td>
			<td></cfoutput><cfmodule template="../tags/textarea.cfm" fieldname="body" value="#htmlEditFormat(form.body)#" class="txtArea" style="width:500px" /><cfoutput></td>
		</tr>
		<cfif len(form.alias)>
		<tr valign="top">
			<td align="right">url:</td>
			<td><a href="#application.rooturl#/page.cfm/#form.alias#">#application.rooturl#/page.cfm/#form.alias#</a></td>
		</tr>
		</cfif>
		<tr valign="top">
			<td align="right">show layout:</td>
			<td><select name="showlayout">
			<option value="1" <cfif form.showlayout>selected</cfif>>Yes</option>
			<option value="0" <cfif not form.showlayout>selected</cfif>>No</option>
			</select>

			</td>
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
