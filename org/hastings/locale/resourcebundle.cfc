<!---
	This code is a modified version of the resourceBundle.cfc by Paul Hastings.
	You can find the original code + examples here: 
	
	http://www.sustainablegis.com/unicode/resourceBundle/rb.cfm
	
	My modifications were to simply add a few var statements to rbLocale and
	to add a few more methods, as well as adding persistance to the CFC.
--->

<cfcomponent displayname="resourceBundle" hint="Reads and parses resource bundle per locale">
	
	<cffunction name="getResource" access="public" output="false" returnType="string"
				hint="Returns bundle.X, if it exists, and optionally wraps it ** if debug mode.">
		<cfargument name="resource" type="string" required="true">
		<cfset var val = "">
		
		<cfif not isDefined("variables.resourceBundle")>
			<cfthrow message="Fatal error: resource bundle not loaded.">
		</cfif>

		<cfif not structKeyExists(variables.resourceBundle, arguments.resource)>
			<cfset val = "_UNKNOWNTRANSLATION_">
		<cfelse>
			<cfset val = variables.resourceBundle[arguments.resource]>
		</cfif>

		<cfif isDebugMode()>
			<cfset val = "*** #val# ***">
		</cfif>
		
		<cfreturn val>
		
	</cffunction>
	
	<cffunction access="public" name="getResourceBundle" output="No" returntype="struct" hint="reads and parses java resource bundle per locale">
		<cfargument name="rbFile" required="Yes" type="string">
		<cfargument name="rbLocale" required="No" type="string" default="en_US">
		<cfargument name="markDebug" required="No" type="boolean" default="false">
		
	    <cfset var isOk=false> <!--- success flag --->
	    <cfset var rbIndx=""> <!--- var to hold rb keys --->
	    <cfset var resourceBundle=structNew()> <!--- structure to hold resource bundle --->
	    <cfset var thisLang=listFirst(arguments.rbLocale,"_")>
	    <cfset var thisDir=GetDirectoryFromPath(arguments.rbFile)>
	    <cfset var thisFile=getFileFromPath(arguments.rbFile)&".properties">
	    <cfset var thisRBfile=thisDir & listFirst(thisFile,".") & "_"& arguments.rbLocale & "." & listLast(thisFile,".")>
	    
	    <cfif NOT fileExists(thisRBfile)> <!--- try just the language --->
	        <cfset thisRBfile=thisDir & listFirst(thisFile,".") & "_"& thisLang & "." & listLast(thisFile,".")>
	    </cfif>
	    <cfif NOT fileExists(thisRBfile)> <!--- still nothing? strip thisRBfile back to base rb --->
	        <cfset thisRBfile=arguments.rbFile&".properties">
	    </cfif>
	    <cfif fileExists(thisRBFile)>
	        <cfset isOK=true>
	        <cffile action="read" file="#thisRBfile#" variable="resourceBundleFile" charset="utf-8">
	        <cfloop index="rbIndx" list="#resourceBundleFile#" delimiters="#chr(10)#">
	            <cfif len(trim(rbIndx)) and left(rbIndx,1) NEQ "##">
	                <cfif NOT arguments.markDebug>
	                    <cfset resourceBundle[trim(listFirst(rbIndx,"="))] = trim(listRest(rbIndx,"="))>
	                <cfelse>
	                    <cfset resourceBundle[trim(listFirst(rbIndx,"="))] = "***"& trim(listRest(rbIndx,"=")) &"***">
	                </cfif>           
	            </cfif>
	        </cfloop>
	    </cfif>
	    <cfif isOK>
	        <cfreturn resourceBundle>
	    <cfelse>
	        <cfthrow message="Fatal error: resource bundle #thisRBfile# not found.">
	    </cfif>
	</cffunction> 

	<cffunction name="getResourceBundleData" access="public" output="No" hint="returns the struct only" returntype="struct">
		<cfreturn variables.resourceBundle>
	</cffunction>
	
	<cffunction name="loadResourceBundle" access="public" output="false" returnType="void"
				hint="Loads a bundle">
		<cfargument name="rbFile" required="Yes" type="string" hint="This must be the path + filename UP to but NOT including the locale. We auto-add .properties to the end.">
		<cfargument name="rbLocale" required="No" type="string" default="en_US">
				
		<cfset variables.resourceBundle = getResourceBundle(arguments.rbFile, arguments.rbLocale)>
	</cffunction>

</cfcomponent>