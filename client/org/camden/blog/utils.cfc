<!---
	Name         : utils
	Author       : Raymond Camden 
	Created      : A long time ago in a galaxy far, far away
	Last Updated : January 14, 2008
	History      : Reset history for version 4.0
				 : Added this header, and moved coloredCode in (rkc 9/22/05)
				 : Added Mail (rkc 7/7/06)
				 : Added getResource (rkc 8/20/06)
				 : fix in the comment area, not from me, but I forget who did it (rkc 1/18/08)
	Purpose		 : Utilities
--->
<cfcomponent displayName="Utils" output="false" hint="Utility functions for the Blog">
	
	<cffunction name="configParam" output="false" returnType="string" access="public"
				hint="Basically says, try to get name.key in ini file, and if not, default to default.key. Also support %default% expansion, which just means replace with default value">
		<cfargument name="iniFile" type="string" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="key" type="string" required="true">
		
		<cfset var result = getProfileString(inifile,name,key)>
		
		<cfif result eq "">
			<cfset result = getProfileString(inifile,"Default",key)>
		</cfif>
		
		<cfreturn result>
				
	</cffunction>

	<cffunction name="getResource" access="public" returnType="string" output="false"
				hint="A utility wrapper for RB">
		<cfargument name="str" type="string" required="true">
		<cfreturn application.resourceBundle.getResource(arguments.str)>
	</cffunction>
	
	<cffunction name="mail" access="public" returnType="void" output="false"
				hint="This function handles the funky auth mail versus non auth mail. All mail ops for app should eventually go through this.">
		<cfargument name="to" type="string" required="true">
		<cfargument name="from" type="string" required="true">
		<cfargument name="subject" type="string" required="true">
		<cfargument name="body" type="string" required="true">
		<cfargument name="cc" type="string" required="false" default="">
		<cfargument name="bcc" type="string" required="false" default="">		
		<cfargument name="type" type="string" required="false" default="text">		
		<cfargument name="mailserver" type="string" required="false" default="">
		<cfargument name="mailusername" type="string" required="false" default="">
		<cfargument name="mailpassword" type="string" required="false" default="">
		
		<cfif arguments.mailserver is "">
			<cfmail to="#arguments.to#" from="#arguments.from#" cc="#arguments.cc#" bcc="#arguments.bcc#" subject="#arguments.subject#" type="#arguments.type#">#arguments.body#</cfmail>
		<cfelse>
			<cfmail to="#arguments.to#" from="#arguments.from#" cc="#arguments.cc#" bcc="#arguments.bcc#" subject="#arguments.subject#" type="#arguments.type#"
					server="#arguments.mailserver#" username="#arguments.mailusername#" password="#arguments.mailpassword#">#arguments.body#</cfmail>
		</cfif>
	
	</cffunction>
	
	<cffunction name="throw" access="public" returnType="void" output="false"
				hint="Throws errors.">
		<cfargument name="message" type="string" required="false" default="">
		<cfthrow type="blog.cfc" message="#arguments.message#">
		
	</cffunction>

	<cffunction name="htmlToPlainText" access="public" returnType="string" output="false"
				hint="Sanitizes a string from having HTML by replacing common entites and remove the others.">
		<cfargument name="input" type="string" required="true">

		<!---// remove html tags (do this first to avoid issues after replacing < & >) //--->
		<cfset arguments.input = reReplace(arguments.input, "<[^>]+>", "", "all") />
		<!---// replace the ellipse entity with three periods //--->
		<cfset arguments.input = replace(arguments.input, "&hellip;", "...", "all") />
		<!---// replace the em-dashes with two dashes //--->
		<cfset arguments.input = reReplace(arguments.input, "(&mdash;)|(&##8212;)|(&##151;)", "--", "all") />
		<!---// replace the < entity with the real character //--->
		<cfset arguments.input = replace(arguments.input, "&lt;", "<", "all") />
		<!---// replace the > entity with the real character //--->
		<cfset arguments.input = replace(arguments.input, "&gt;", ">", "all") />
		<!---// replace the & entity with the real character //--->
		<cfset arguments.input = replace(arguments.input, "&amp;", "&", "all") />
		<!---// remove all other html entities //--->
		<cfset arguments.input = reReplace(arguments.input, "(&##[0-9]+;)|(&[A-Za-z]+;)", "", "all") />
		
		<cfreturn arguments.input />
	</cffunction>
	
	
	<cffunction name="fixUrl" access="public" returntype="string" output="false" hint="Ensures a URL is properly formatted.">
		<cfargument name="url" type="string" required="true" />
		
		<cfreturn reReplace(arguments.url, "\/{2,}", "/", "all")>
	</cffunction>
</cfcomponent>