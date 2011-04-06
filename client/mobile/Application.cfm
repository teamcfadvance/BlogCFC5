
<cfsetting showdebugoutput="false">

<!---prevent load of config file--->
<cfif listlast(cgi.script_name, "/") is "mobile.ini.cfm">
	<cfabort>
</cfif>

<!---include primary application--->
<cfinclude template="../Application.cfm">

<cfif not isDefined('application.blogMobile') or isDefined('url.reinit')>
	<cfset application.blogMobile = createObject("component","components.blogMobile").init(application.blog.getProperty("name"))>
</cfif>

<cfset application.primaryTheme = "b"><!---application.blogMobile.getProperty("theme")--->
<cfset application.mobilePageMax = 15>

