<cfcomponent output="false" extends="RootApplication">

	<cffunction name="onApplicationStart" returntype="boolean" output="false">
		<Cfset super.onApplicationStart()>
		<cfreturn true>
	</cffunction>

 	<cffunction name="onRequestStart" returntype="boolean" output="false"> 
		<cfargument name="thePage"type="string"required="true">

		<Cfset super.onRequestStart(thePage)>
		<!--- no idea why this isn't loading in memory --->
		<cfif not isDefined('application.utils.getResource')>
			<cfset onApplicationStart()>
		</cfif>
		<cfset request.rb = application.utils.getResource>

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
					<!---
					While we use roles above based on CF's built in stuff, I plan on moving away from that, and the role here
					is more a high level role. We need to add a blog user's specific roles to the session scope.
					--->
					<cfset session.roles = application.blog.getUserBlogRoles(username)>

				<cfelse>
					<!--- Suggested by Shlomy Gantz to slow down brute force attacks --->
					<cfset createObject("java", "java.lang.Thread").sleep(500)>
				</cfif>
			</cfif>
		</cflogin>
		
		<!--- Security Related --->
		<cfif isDefined("url.logout") and application.utils.isLoggedIn()>
			<cfset structDelete(session,"loggedin")>
			<cflogout>
		</cfif>
		
		<cfif findNoCase("/admin", cgi.script_name) and not application.utils.isLoggedIn() and not findNoCase("/admin/notify.cfm", cgi.script_name)>
			<cfsetting enablecfoutputonly="false">
			<cfinclude template="login.cfm">
			<cfabort>
		</cfif>

		<cfreturn true>
	</cffunction>

	<cffunction name="onSessionStart" returntype="void" output="false">
		<Cfset super.onSessionStart(onSessionStart)>
	</cffunction>

</cfcomponent>