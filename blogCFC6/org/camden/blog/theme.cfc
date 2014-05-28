<cfcomponent displayName="Theme CFC" hint="Handles themes." output="false">

<cffunction name="init" access="public" returnType="theme" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="renderEntry" access="public" returnType="string" output="false" hint="I render blog entry.">
	<cfargument name="entriesStruct" type="struct" required="true" hint="Structure of entry data, we will parse it down">

	<!--- These will be available to theme --->
	<cfset var settings = variables.settings>
	<cfset var themeurl = variables.themeurl>
	<cfset var entry = {}>
	<cfset var postcommenturl = "">
	<cfset var commentadded = false>
	<cfset var commenterrors = []>
	<cfset var comments = []>
	<cfset var categories = "">
	<cfset var commentsAllowed = true>
	<cfset var categoryids = "">
	<cfset var body = "">
	<cfset var result = "">
	<cfset var key = "">
	<cfset var hasComments = false>
	
	<cfloop index="key" list="#arguments.entriesStruct.entries.columnList#">
		<cfset entry[key] = arguments.entriesStruct.entries[key][1]>
	</cfloop>
	<cfset entry.link = renderEntryLink(entry.id)>
	<cfset qCategories = application.entryService.getCategoriesForEntry(entry.id)>
	<cfset categories = valueList(qCategories.categoryname)>
	<cfset categoryids = valueList(qCategories.categoryid)>
	<cfset comments = application.entryService.getComments(entry.id)>
	<cfif comments.recordCount>
		<cfset hasComments = true>
	</cfif>
	<cfset body = entry.body & entry.morebody>
	
	<!---	
	<cfset entry.body = variables.entryService.renderEntry(entry.body & entry.morebody)>
	--->
	
	<cfsavecontent variable="result">	
		<cfinclude template="#variables.thememapping#/entry.cfm" />
	</cfsavecontent>

	<cfreturn result>
	
</cffunction>

<cffunction name="renderEntries" access="public" returnType="string" output="false" hint="I render blog entries.">
	<cfargument name="entriesStruct" type="struct" required="true" hint="Structure of entry data">
	<cfargument name="startPos" type="numeric" required="true" hint="Tells us where we are row wise.">
	<cfargument name="previousLinkStr" type="string" required="true" hint="URL of link to go back, blank if not needed">
	<cfargument name="nextLinkStr" type="string" required="true" hint="URL of link to go forward, blank if not needed">

	<!--- These will be available to theme --->
	<cfset var entries = arguments.entriesStruct.entries>
	<cfset var settings = variables.settings>
	<cfset var totalentries = arguments.entriesStruct.totalentries>
	<cfset var start = arguments.startPos>
	<cfset var previousLink = arguments.previousLinkStr>
	<cfset var nextLink = arguments.nextLinkStr>
	<cfset var themeurl = variables.themeurl>

	<cfset var result = "">

	<cfsavecontent variable="result">	
		<cfinclude template="#variables.thememapping#/entries.cfm" />
	</cfsavecontent>

	<cfreturn result>
	
</cffunction>

<cffunction name="renderLayout" access="public" returnType="string" output="true" hint="I render the main page layout.">
	<cfargument name="title" type="string" required="true">
	<cfargument name="content" type="string" required="true">

	<!--- variables for our theme --->
	<cfset var themeurl = variables.themeurl>
	<cfset var settings = variables.settings>
	<cfset var rssurl = "">
	<cfset var result = "">

	<cfsavecontent variable="result">	
		<cfinclude template="#variables.thememapping#/layout.cfm" />
	</cfsavecontent>

	<cfreturn result>
</cffunction>

<!--- Will be used by theme files --->
<cffunction name="renderCategoryLink" access="public" returnType="string" output="false" hint="Given a label, I make a category link.">
	<cfargument name="label" type="string" required="true">
	<cfset var catid = variables.entryservice.getCategoryByName(arguments.label)>
	<cfset var link = variables.entryservice.makeCategoryLink(catid)>
	<cfreturn "<a href=""#link#"">#arguments.label#</a>">
</cffunction>

<cffunction name="renderCategoryListLink" access="public" returnType="string" output="false" hint="Given a label, I make a category link.">
	<cfargument name="catlist" type="string" required="true">
	<cfset var r = "">
	<cfset var cat = "">
	<cfset var catid = "">
	<cfset var x = "">
	
	<cfloop index="x" from="1" to="#listLen(arguments.catlist)#">
		<cfset cat = listGetAt(arguments.catlist, x)>
		<cfset catid = variables.entryservice.getCategoryByName(cat)>
		<cfset link = variables.entryservice.makeCategoryLink(catid)>

		<cfset r &= "<a href=""#link#"">#cat#</a>">
		<cfif x lt listLen(arguments.catlist)>
			<cfset r &= ", ">
		</cfif>
	</cfloop>

	<cfreturn r>	
</cffunction>

<cffunction name="renderDefaultPodLayout" access="private" returnType="string" output="false" hint="Default pod layouts.">
	<cfargument name="content" type="string" required="true">
	<cfargument name="title" type="string" required="false" default="">
	<cfset var result = "">

	<cfsavecontent variable="result">
	<cfoutput>
	<div class="pod">
	<div class="podTitle">#arguments.title#</div>
	<div class="podBody">
	#arguments.content#
	</div>
	</div>
	</cfoutput>
	</cfsavecontent>

	<cfreturn result>
</cffunction>

<cffunction name="renderEnclosureLink" access="public" returnType="string" output="false" hint="Abstract links to enclosures.">
	<cfargument name="enclosure" type="string" required="true">
	<cfreturn "#variables.settings.rooturl#/enclosures/#urlEncodedFormat(getFileFromPath(arguments.enclosure))#">
</cffunction>

<cffunction name="renderEntryLink" access="public" returnType="string" output="false" hint="Get URL for entry.">
	<cfargument name="id" type="uuid" required="true">
	<cfreturn variables.entryservice.makeLink(arguments.id)>
</cffunction>

<cffunction name="renderPod" access="public" returnType="string" output="false" hint="Handle pod layout">
	<cfargument name="pod" type="string" required="true">
	<cfargument name="title" type="string" required="false" default="">
	<cfargument name="cached" type="boolean" required="false" default="false">
	<cfargument name="cachetimeout" type="numeric" required="false" default="60">
	
	<cfset var content = "">
	<cfset var result = "">
	<cfset var cachekey = "">
	<cfset var cachestruct = "">
	
	<!--- check the pod content cache, if desired --->
	<cfif arguments.cached>
		<cfset cachekey = arguments.pod & "|" & arguments.title>
		<cfif structKeyExists(variables.podcontentcache, cachekey)>
			<!--- is the cache fresh --->
			<cfif dateCompare(now(), variables.podcontentcache[cachekey].expirationdate) is -1>
				<cfreturn variables.podcontentcache[cachekey].content>
			</cfif>
		</cfif>
	</cfif>

	<!--- Check the pod (loc) cache - if not there, it isn't valid --->
	<cfif not structKeyExists(variables.podcache, arguments.pod)>
		<cfthrow message="The pod, #arguments.pod#, is not valid. It must exist in the theme pods dir or in the core BlogCFC pods dir.">
	</cfif>

	<cfsavecontent variable="content">	
		<cfinclude template="#variables.podcache[arguments.pod]#" />
	</cfsavecontent>
	
	<!--- Ok, we have our content now. If the theme has a specific pod layout, run it, otherwise do a generic --->
	<cfif variables.custompodlayout>
		<cfthrow message="poo custom">
	<cfelse>
		<cfset result = renderDefaultPodLayout(content,arguments.title)>
	</cfif>

	<cfif arguments.cached>
		<cfset cachestruct = {}>
		<cfset cachestruct.content = result>
		<cfset cachestruct.expirationdate = dateAdd("n", arguments.cachetimeout, now())>
		<cfset variables.podcontentcache[cachekey] = cachestruct>
	</cfif>	
	
	<cfreturn result>
</cffunction>

<cffunction name="renderPrintLink" access="public" returnType="string" output="false" hint="Abstract link to print service.">
	<cfargument name="id" type="uuid" required="true">
	<cfreturn "#variables.settings.rooturl#/print.cfm?id=#arguments.id#">
</cffunction>

<cffunction name="renderSendLink" access="public" returnType="string" output="false" hint="Abstract link to send.">
	<cfargument name="id" type="uuid" required="true">
	<cfreturn "#variables.settings.rooturl#/send.cfm?id=#arguments.id#">
</cffunction>

<!--- Injected --->
<cffunction name="setEntryService" access="public" returnType="void" output="false">
	<cfargument name="entryservice" type="any" required="true">
	<cfset variables.entryservice = arguments.entryservice>
</cffunction>

<cffunction name="setSettings" access="public" returnType="void" output="false">
	<cfargument name="settings" type="struct" required="true">
	<cfset var buffer = "">
	<cfset var poddir = "">
	
	<cfset variables.settings = arguments.settings>

	<!--- One setting is rootfolder, which is our core root, so let's get the template folder --->
	<cfset variables.themesfolder = variables.settings.rootfolder & "/themes">

	<!--- die if no templates folder --->
	<cfif not directoryExists(variables.themesfolder)>
		<cfthrow message="Templates folder, #variables.themesfolder#, does not exist.">
	</cfif>
	
	<!--- If no theme, use default --->
	<cfif not structKeyExists(variables.settings, "theme")>
		<cfset variables.settings.theme = "default">
	</cfif>
	
	<!--- now find the template --->
	<cfset variables.themefolder = variables.themesfolder & "/" & variables.settings.theme>
	
	<!--- die if no template folder --->
	<cfif not directoryExists(variables.themefolder)>
		<cfthrow message="Template folder, #variables.themefolder#, does not exist.">
	</cfif>
			
	<!--- do we have podlayout.cfm? --->
	<cfif fileExists(variables.themefolder & "/podlayout.cfm")>
		<cfset variables.custompodlayout = true>
	<cfelse>
		<cfset variables.custompodlayout = false>
	</cfif>
	
	<cfset variables.thememapping = "/root/themes/#variables.settings.theme#">
	
	<cfset variables.themeurl = arguments.settings.rooturl & "/themes/#variables.settings.theme#">
	
	<!--- store the custom pods we have --->
	<cfset variables.podcache = {}>
	<cfif directoryExists(variables.themefolder & "/pods")>
		<cfdirectory directory="#variables.themefolder#/pods" name="poddir" filter="*.cfm"> 	
		<cfloop query="poddir">
			<cfif name is not "Application.cfm" and name is not "Application.cfc">
				<cfset variables.podcache[listDeleteAt(name, listLen(name, "."), ".")] = variables.thememapping & "/pods/" & name>
			</cfif>
		</cfloop>
	</cfif>
	<cfdirectory directory="#variables.settings.rootfolder#/pods" name="poddir" filter="*.cfm"> 	
	<cfloop query="poddir">
		<cfif name is not "Application.cfm" and name is not "Application.cfc">
			<cfif not structKeyExists(variables.podcache, listDeleteAt(name, listLen(name, "."), "."))>
				<cfset variables.podcache[listDeleteAt(name, listLen(name, "."), ".")] = "/root/pods/" & name>
			</cfif>
		</cfif>
	</cfloop>

	<cfset variables.podcontentcache = {}>
	
</cffunction>

</cfcomponent>