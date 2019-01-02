<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : comment.cfm
	Author       : Raymond Camden
	Created      : 04/07/06
	Last Updated : 12/07/06
	History      : Support for moderation (tr 12/7/06)
--->

<cftry>
	<cfset comment = application.blog.getComment(url.id)>
	<cfif comment.recordCount is 0>
		<cflocation url="comments.cfm" addToken="false">
	</cfif>
	<cfcatch>
		<cflocation url="comments.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="comments.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>

	<cfif not len(trim(form.name))>
		<cfset arrayAppend(errors, "The name cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.email)) or not application.utils.isEmail(form.email)>
		<cfset arrayAppend(errors, "The email cannot be blank and must be a valid email address.")>
	</cfif>
	<cfif len(form.website) and not application.utils.isURL(form.website)>
		<cfset arrayAppend(errors, "Website must be a valid URL.")>
	</cfif>
	<cfif not len(trim(form.comment))>
		<cfset arrayAppend(errors, "The comment cannot be blank.")>
	</cfif>

	<cfif not arrayLen(errors)>
		<cfset application.blog.saveComment(url.id, left(form.name,50), left(form.email,50), left(form.website,255), form.comment, form.subscribe, form.moderated)>
		<cflocation url="comments.cfm" addToken="false">
	</cfif>

</cfif>

<cfparam name="form.name" default="#comment.name#">
<cfparam name="form.email" default="#comment.email#">
<cfparam name="form.website" default="#comment.website#">
<cfparam name="form.comment" default="#comment.comment#">
<cfparam name="form.subscribe" default="#comment.subscribe#">
<cfparam name="form.moderated" default="#comment.moderated#">

<cfmodule template="../tags/adminlayout.cfm" title="Comment Editor">

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
	<form action="comment.cfm?id=#comment.id#" method="post">
	<table>
		<tr>
			<td align="right">posted:</td>
			<td>#application.localeUtils.dateLocaleFormat(comment.posted)# #application.localeUtils.timeLocaleFormat(comment.posted)#</td>
		</tr>
		<tr>
			<td align="right">name:</td>
			<td><input type="text" name="name" value="#form.name#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">email:</td>
			<td><input type="text" name="email" value="#form.email#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">website:</td>
			<td><input type="text" name="website" value="#form.website#" class="txtField"></td>
		</tr>
		<tr valign="top">
			<td align="right">comment:</td>
			<td><textarea name="comment" class="txtArea">#form.comment#</textarea></td>
		</tr>
		<tr>
			<td align="right">subscribed:</td>
			<td>
			<select name="subscribe">
			<option value="yes" <cfif form.subscribe>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.subscribe>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right">moderated:</td>
			<td>
			<select name="moderated">
			<option value="yes" <cfif form.moderated>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.moderated>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="cancel" value="Cancel"> <input type="submit" name="save" value="Save"> <input type="button" name="approve" value="Approve" onclick="location.href='#application.rooturl#/admin/moderate.cfm?approve=#comment.id#'" /></td>
		</tr>
	</table>
	</form>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly=false>
