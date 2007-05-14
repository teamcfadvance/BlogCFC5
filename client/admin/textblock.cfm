<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/page.cfm
	Author       : Raymond Camden 
	Created      : 07/07/06
	Last Updated : 
	History      : 
--->

<cfparam name="url.id" default="0">

<cfif url.id is not 0>
	<cftry>
	<cfset tb = application.textblock.getTextblock(id=url.id)>
	<cfif structIsEmpty(tb)>
		<cflocation url="textblocks.cfm" addToken="false">
	</cfif>
	<cfcatch>
		<cflocation url="textblocks.cfm" addToken="false">
	</cfcatch>
	</cftry>
	<cfparam name="form.label" default="#tb.label#">
	<cfparam name="form.body" default="#tb.body#">
<cfelse>
	<cfparam name="form.label" default="">
	<cfparam name="form.body" default="">
</cfif>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="textblocks.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>
	
	<cfif not len(trim(form.label))>
		<cfset arrayAppend(errors, "The label cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.body))>
		<cfset arrayAppend(errors, "The body cannot be blank.")>
	</cfif>
	
	<cfif not arrayLen(errors)>
		<cfset application.textblock.saveTextblock(url.id, left(form.label,255), form.body)>
		<cflocation url="textblocks.cfm" addToken="false">
	</cfif>
	
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="Textblock Editor">

	<cfoutput>
	<p>
	Use the form below to edit a textblock. Textblocks are random blocks of text that you can use in your site. These would
	be useful for pods or footer text that you need to update often.
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
	<form action="textblock.cfm?id=#url.id#" method="post">
	<table>
		<tr>
			<td align="right">label:</td>
			<td><input type="text" name="label" value="#form.label#" class="txtField" maxlength="255"></td>
		</tr>
		<tr valign="top">
			<td align="right">body:</td>
			<td><textarea name="body" class="txtArea">#form.body#</textarea></td>
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
