<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : user.cfm
	Author       : Raymond Camden 
	Created      : 07/15/09
	Last Updated : 01/26/2011
	History      : RBB: Updated to account for hashed passwords.
--->

<cfif not application.blog.isBlogAuthorized('ManageUsers')>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfset allroles = application.blog.getBlogRoles()>

<cftry>
	<cfif url.id neq 0>
		<cfset user = application.blog.getUser(url.id)>
		<cfparam name="form.name" default="#user.name#">
		<cfparam name="form.username" default="#user.username#">
		<cfparam name="form.password" default="#user.password#">
		<cfset roles = application.blog.getUserBlogRoles(user.username)>
		<cfif not structKeyExists(form, "save")>
			<cfparam name="form.roles" default="#roles#">
		<cfelse>
			<cfparam name="form.roles" default="">
		</cfif>
	<cfelse>
		<cfparam name="form.name" default="">
		<cfparam name="form.username" default="">
		<cfparam name="form.password" default="">
		<cfparam name="form.roles" default="">
	</cfif>
	<cfcatch>
		<cflocation url="users.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="users.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>

	<cfif not len(trim(form.username))>
		<cfset arrayAppend(errors, "The username cannot be blank.")>
	</cfif>	
	<cfif not len(trim(form.name))>
		<cfset arrayAppend(errors, "The name cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.password))>
		<cfset arrayAppend(errors, "The password cannot be blank.")>
	</cfif>

	<cfif not arrayLen(errors)>
		<cftry>
		<cfif url.id neq 0>
			<!--- RBB 1/17/11: if the password value from the db is the same as the value submitted by form, don't update the password --->
			<cfif form.passwordCheck is form.password>
				<cfset application.blog.saveUser(url.id, left(form.name,50))>
			<cfelse>
				<cfset application.blog.saveUser(url.id, left(form.name,50), left(form.password, 256))>
			</cfif>
		<cfelse>
			<cfset application.blog.addUser(left(form.username,50),left(form.name,50), left(form.password,50))>
		</cfif>
		<cfset application.blog.setUserBlogRoles(form.username, form.roles)>
		<cfcatch>
			<cfif findNoCase("already exists as a user", cfcatch.message)>
				<cfset arrayAppend(errors, "A user with this username already exists.")>
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
		</cftry>

		<cfif not arrayLen(errors)>
			<cflocation url="users.cfm" addToken="false">
		</cfif>
	</cfif>
	
</cfif>


<cfmodule template="../tags/adminlayout.cfm" title="User Editor">

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
	Use the form below to edit the user. Existing users cannot have their usernames changed. Note that changing the roles for a user who is currently logged in will <b>not</b>
	change their access until they log in again.
	</p>
	
	<form action="user.cfm?id=#url.id#" method="post">
	<cfif structKeyExists(form, "password")>
	<input type="hidden" name="passwordCheck" value="#form.password#">
	</cfif>
	<table>
		<tr>
			<td align="right">username:</td>
			<td>
			<cfif url.id eq 0>
				<input type="text" name="username" value="#form.username#" class="txtField" maxlength="50">
			<cfelse>
				#form.username#
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">name:</td>
			<td><input type="text" name="name" value="#form.name#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">password:</td>
			<td><input type="password" name="password" value="#form.password#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">roles:</td>
			<td>
				<select name="roles" multiple="true" size="5">
				<cfloop query="allroles">
					<option value="#id#" <cfif listFind(form.roles,id)>selected</cfif>>#role# (#description#)</option>
				</cfloop>
				</select>
			</td>			
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="save" value="Save"> <input type="submit" name="cancel" value="Cancel"></td>
		</tr>
	</table>
	</form>
	</cfoutput>
</cfmodule>

<cfsetting enablecfoutputonly=false>
