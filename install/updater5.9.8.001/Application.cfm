<cfset prefix = hash(getCurrentTemplatePath())>
<cfset prefix = reReplace(prefix, "[^a-zA-Z]","","all")>
<cfset prefix = right(prefix, 64)>
<cfapplication name="#prefix#" sessionManagement="true" loginStorage="session">

<cfif not structKeyExists(application, "init")>

	<!--- See if we can find the ini file, if not, we abort --->
	<cfif fileExists(expandPath("../org/camden/blog/blog.ini.cfm"))>
		<cfset application.iniFile = expandPath("../org/camden/blog/blog.ini.cfm")>
	<cfelseif fileExists(expandPath("/org/camden/blog/blog.ini.cfm"))>
		<cfset application.iniFile = expandPath("/org/camden/blog/blog.ini.cfm")>
	<cfelseif fileExists(expandPath("/client/org/camden/blog/blog.ini.cfm"))>
		<cfset application.iniFile = expandPath("/client/org/camden/blog/blog.ini.cfm")>
	<cfelse>
		<cfoutput>
		<p>
		Unfortunately, I had a problem finding your config file. I looked for this path: #expandPath("../org/camden/blog/blog.ini.cfm")# and this path: #expandPath("/org/camden/blog/blog.ini.cfm")#.
		I was not able to find either of these files. This means BlogCFC may be "stuck" trying to run the installer. Please contact Raymond Camden (ray@camdenfamily.com) for support.
		</p>
		</cfoutput>
		<cfabort>
	</cfif>
	
	<!--- Store and remember all of the blog names configured in the ini file --->
	<cfset application.blognames = structKeyList(GetProfileSections(application.iniFile))>
	<cfset application.init = true>
</cfif>




