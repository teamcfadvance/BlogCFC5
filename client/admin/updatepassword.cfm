<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/updatepassword.cfm
	Author       : Raymond Camden 
	Created      : 09/14/06
	Last Updated : 
	History      : 
--->

<cfif structKeyExists(form, "cancel")>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "update")>
	<cfset errors = arrayNew(1)>
	
	<cfif not len(trim(form.oldpassword))>
		<cfset arrayAppend(errors, "You must enter your old password.")>
	</cfif>
	<cfif not len(trim(form.newpassword))>
		<cfset arrayAppend(errors, "Your new password cannot be blank.")>
	</cfif>
	<cfif form.newpassword neq form.newpassword2>
		<cfset arrayAppend(errors, "Your new password and the confirmation did not match.")>
	</cfif>
	
	<cfif not arrayLen(errors)>
		<cfset result = application.blog.updatePassword(form.oldpassword, form.newpassword)>
		<cfif result>
			<cfset goodFlag = true>
		<cfelse>
			<cfset errors[1] = "You entered the wrong old password.">
		</cfif>
	</cfif>
	
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="Update Password">

	<cfoutput>
	<p>
	Use the form below to update your password. You must enter your old password first.
	</p>
	</cfoutput>
	
	<cfif structKeyExists(variables, "goodFlag")>
		<cfoutput>
		<p>
		Your password was updated.
		</p>
		</cfoutput>
	</cfif>
	
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
	<form action="updatepassword.cfm" method="post">
	<table>
		<tr>
			<td align="right">old password:</td>
			<td><input type="password" name="oldpassword" value="" class="txtFieldShort" maxlength="255"></td>
		</tr>
		<tr>
			<td align="right">new password:</td>
			<td><input type="password" name="newpassword" value="" class="txtFieldShort" maxlength="255"></td>
		</tr>
		<tr>
			<td align="right">confirm password:</td>
			<td><input type="password" name="newpassword2" value="" class="txtFieldShort" maxlength="255"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="cancel" value="Cancel"> <input type="submit" name="update" value="Update"></td>
		</tr>
	</table>	
	</form>
	</p>	
	</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>