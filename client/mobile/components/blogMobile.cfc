<cfcomponent displayName="blogMobile" output="false" hint="BlogCFC Mobile">

	<!--- Load utils immidiately. --->
	<cfset variables.utils = createObject("component", "org.camden.blog.utils")>
	
	<!--- cfg file --->
	<cfset variables.cfgFile = "#getDirectoryFromPath(GetCurrentTemplatePath())#../config/mobile.ini.cfm">

	<!--- used for settings --->
	<cfset variables.instance = "">

	<cffunction name="init" access="public" returnType="blogMobile" output="false"
				hint="Initialize the blog mobile settings">

		<cfargument name="name" type="string" required="false" default="default" hint="Blog name, defaults to default">
		
		<cfset var renderDir = "">
		<cfset var renderCFCs = "">
		<cfset var cfcName = "">
		<cfset var md = "">

		<cfif not listFindNoCase(structKeyList(getProfileSections(variables.cfgFile)),name)>
			<cfset variables.utils.throw("#arguments.name# isn't registered as a valid blog.")>
		</cfif>
		<cfset instance = structNew()>
		<cfset instance.title = variables.utils.configParam(variables.cfgFile,arguments.name,"title")>
		<cfset instance.shortTitle = variables.utils.configParam(variables.cfgFile,arguments.name,"shortTitle")>
		<cfset instance.iconLabel = variables.utils.configParam(variables.cfgFile,arguments.name,"iconLabel")>
		<cfset instance.appVersion = variables.utils.configParam(variables.cfgFile,arguments.name,"appVersion")>
		<cfset instance.theme = variables.utils.configParam(variables.cfgFile,arguments.name,"theme")>
		<cfset instance.mobileRoot = variables.utils.configParam(variables.cfgFile,arguments.name,"mobileRoot")>
		
		
		<!--- Name the blog --->
		<cfset instance.name = arguments.name & "_mobile">
		
		<cfreturn this>

	</cffunction>
	
	<cffunction name="getProperties" access="public" returnType="struct" output="false">
		<cfreturn duplicate(instance)>
	</cffunction>

	<cffunction name="getProperty" access="public" returnType="any" output="false">
		<cfargument name="property" type="string" required="true">

		<cfif not structKeyExists(instance,arguments.property)>
			<cfset variables.utils.throw("#arguments.property# is not a valid property.")>
		</cfif>

		<cfreturn instance[arguments.property]>

	</cffunction>
	
</cfcomponent>
