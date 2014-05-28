<cfcomponent output="false">
	
	<cfset this.name = "Utopia" & right(reReplace(hash(getCurrentTemplatePath()),"[^a-zA-Z0-9]","","all"),50)>

	<cfset this.applicationTimeout = createTimeSpan(0,2,0,0)>
	<cfset this.sessionManagement = true>
	<cfset this.scriptProtect = false>
	<cfset this.mappings["/org"] = getDirectoryFromPath(getCurrentTemplatePath()) & "org">
	<cfset this.mappings["/root"] = getDirectoryFromPath(getCurrentTemplatePath())>
	<cfset this.customtagpaths = getDirectoryFromPath(getCurrentTemplatePath()) & "tags">

	<cffunction name="loadSettings" returnType="struct" output="false">
		<cfset var settings = "">
		<cfset var settingsxml = "">
		<cfset var myxmlfile = "">
		<cfset var setting = "">
		<cfset var result = structNew()>
		<cfset var getSettings = "">
		<cfset var col = "">
		
		<!--- todo: are we overwriting at runtime? --->
		<!--- what is my setting file? --->
		<cfset myxmlfile = expandPath("./settings.xml.cfm")>
		
		<!--- read it in --->
		<cffile action="read" file="#myxmlfile#" variable="settings">
		
		<!--- remove comments --->
		<cfset settings = replace(settings, "<!---","")>
		<cfset settings = trim(replace(settings, "--->",""))>
		
		<!--- parse to xml --->
		<cfset settingsxml = xmlParse(settings)>
		<cfloop item="setting" collection="#settingsxml.settings#">
			<!--- for now we assume simple strings, todo: support complex --->
			<cfset result[setting] = settingsxml.settings[setting].xmltext>
		</cfloop>
		
		<!--- get root folder --->
		<cfset result.rootfolder = getDirectoryFromPath(getCurrentTemplatePath())>
		
		<!--- Some defaults for virgin installs --->
		<cfif not structKeyExists(result, "reloadKey")>
			<cfset result.reloadkey = "init">
		</cfif>
		
		<!--- This is where we hit the DB for it's settings - To Be Done Better --->
		<cfquery name="getSettings" datasource="#result.dsn#" username="#result.username#" password="#result.password#">
		select	*
		from	tblblogsettings
		where	blog = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#result.blog#">
		</cfquery>
		<cfloop index="col" list="#getSettings.columnList#">
			<cfset result[col] = getSettings[col][1]>
		</cfloop>
					
		<cfreturn result>
	</cffunction>
	
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<cfset application.settings = loadSettings()>
		
		<!--- begin to load components --->
		<cfset application.factory = createObject("component", "org.camden.blog.factory").init(application.settings)>
		<cfset application.entryService = application.factory.get("entryService")>
		<cfset application.themeService = application.factory.get("themeService")>
		<cfset application.pageService = application.factory.get("page")>
	
		<cfreturn true>
	</cffunction>

	<cffunction name="onRequestStart" returnType="boolean" output="false">
		<cfargument name="thePage" type="string" required="true">
		
		<cfif structKeyExists(url, application.settings.reloadkey) or 1>
			<cfset onApplicationStart()>
		</cfif>	
		<cfreturn true>
	</cffunction>

	<cffunction name="onError" returnType="void" output="false">
		<cfargument name="exception" required="true">
		<cfargument name="eventname" type="string" required="true">
		<cfdump var="#arguments#"><cfabort>
	</cffunction>

	<cffunction name="onSessionStart" returnType="void" output="false">
	</cffunction>

</cfcomponent>