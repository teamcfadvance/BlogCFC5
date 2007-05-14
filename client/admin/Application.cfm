<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/Application.cfm
	Author       : Raymond Camden 
	Created      : 04/06/06
	Last Updated : 3/9/07
	History      : Shlomy Gantz suggested a 'pause' on badlogin to help prevent brute force attacks (rkc 3/9/07)
--->

<cfinclude template="../Application.cfm">

<cflogin>
	<cfif isDefined("form.username") and isDefined("form.password") and len(trim(form.username)) and len(trim(form.password))>
		<cfif application.blog.authenticate(left(trim(form.username),50),left(trim(form.password),50))>
			<cfloginuser name="#trim(username)#" password="#trim(password)#" roles="admin">
			<!--- 
				  This was added because CF's built in security system has no way to determine if a user is logged on.
				  In the past, I used getAuthUser(), it would return the username if you were logged in, but
				  it also returns a value if you were authenticated at a web server level. (cgi.remote_user)
				  Therefore, the only say way to check for a user logon is with a flag. 
			--->  
			<cfset session.loggedin = true>
		<cfelse>
			<!--- Suggested by Shlomy Gantz to slow down brute force attacks --->
			<cfset createObject("java", "java.lang.Thread").sleep(500)>
		</cfif>
	</cfif>
</cflogin>

<!--- Security Related --->
<cfif isDefined("url.logout") and isLoggedIn()>
	<cfset structDelete(session,"loggedin")>
	<cflogout>
</cfif>

<cfif findNoCase("/admin", cgi.script_name) and not isLoggedIn() and not findNoCase("/admin/notify.cfm", cgi.script_name)>
	<cfsetting enablecfoutputonly="false">
	<cfinclude template="login.cfm">
	<cfabort>
</cfif>

<cfsetting enablecfoutputonly=false>
