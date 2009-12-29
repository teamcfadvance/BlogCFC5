<cfcomponent output="false">
	<cffunction name="init" access="public" hint="This function initializes all of the variables needed for the component." output="false">
		<cfargument name="file" default="#getDirectoryFromPath(getCurrentTemplatePath()) & "coldfishconfig.xml"#" required="false"/><!--- assumes config file is in same directory --->
		<cfset loadConfigFile(arguments.file)/>
        <cfreturn this/>
    </cffunction>
	
	<cffunction name="loadConfigFile" access="public" hint="Load and parse the config file" output="false">
		<cfargument name="file" required="true"/>
		<cfset var xmlFile = ""/>
		<cfset var xmlObject = ""/>
		<cfset var typeIndex = ""/>
		<cfset var attributes = ""/>
		
		<cffile action="read" file="#arguments.file#" variable="xmlFile"/>
		<cfset xmlObject = xmlparse(xmlFile)/>
		
		<cfset variables.instance.colors=structnew()/>
		<cfset variables.instance.keywordmap = structnew()>
		<cfloop from="1" to="#ArrayLen( xmlObject.coldfish.types.XmlChildren )#" index="typeIndex">
			<cfset attributes = xmlObject.coldfish.types.type[typeIndex].XmlAttributes/> 
			<cfset setStyle(attributes.name,attributes.style)/>
			<cfif isDefined("attributes.parser") AND isDefined("attributes.keywords")>
				<cfset addKeywordmap(attributes.parser,attributes.name,attributes.keywords)/>
			</cfif>
		</cfloop>
		<cfset setCacheSize(xmlObject.coldfish.settings.XmlAttributes.cachesize)/>
		<cfset setInitialParser(xmlObject.coldfish.settings.XmlAttributes.defaultparser)/>
		<cfset setShowLineNumbers(xmlObject.coldfish.settings.XmlAttributes.showLineNumbers)/>
		<cfset setShowToolbar(xmlObject.coldfish.settings.XmlAttributes.showToolbar)/>
		<cfreturn/>
    </cffunction>
	
    <cffunction name="getInstanceData" access="public" hint="Return the instance data" output="false">
		<cfreturn variables.instance/>
	</cffunction>
	<cffunction name="addKeywordmap" access="public" hint="This function can be used to set keyword mappings for the parsers to look at." output="false">
    	<cfargument name="parser" type="string"/>
        <cfargument name="typename" type="string"/>
		<cfargument name="keywordlist" type="string"/>
		<cfif not StructKeyExists(variables.instance.keywordmap, arguments.parser)>
			<cfset variables.instance.keywordmap[arguments.parser] = structnew()/>
			<cfset variables.instance.keywordmap[arguments.parser].keywordlist = arraynew(1)/>
       		<cfset variables.instance.keywordmap[arguments.parser].typename = arraynew(1)/>
		</cfif>
		<cfset arrayappend(variables.instance.keywordmap[arguments.parser].keywordlist,arguments.keywordlist)/>
		<cfset arrayappend(variables.instance.keywordmap[arguments.parser].typename,arguments.typename)/>
    </cffunction>
	<cffunction name="getKeywordmap" access="public" hint="This function returns the keyword map." output="false">
		<cfreturn variables.instance.keywordmap/>
    </cffunction>
    <cffunction name="getStyle" access="public" hint="This function can be used to get the style used in conjunction with a type of language element." output="false">
    	<cfargument name="element" type="string"/>
		<cfreturn variables.instance.colors[arguments.element]/>
    </cffunction>
    <cffunction name="setStyle" access="public" hint="This function can be used to set the style used in conjunction with a type of language element.  The value submitted should be a valid CSS black; (i.e. 'color:black;background-color:yellow;')" output="false">
    	<cfargument name="element" type="string"/>
        <cfargument name="style" type="string"/>
        <cfset variables.instance.colors[arguments.element]=arguments.style/>
    </cffunction>
    <cffunction name="getStyles" access="public" hint="This function returns all of the styles used for each type of language element." output="false">
		<cfreturn variables.instance.colors/>
    </cffunction>
	<cffunction name="setInitialParser" access="public" hint="You can set the initial parser state with this.  This is helpful for scripts that make initial parsing impossible (ie. Script, Actionscript)" output="false">
		<cfset variables.instance.initialparser = arguments[1]/>
    </cffunction>
	<cffunction name="getInitialParser" access="public" hint="You can set the initial parser state with this.  This is helpful for scripts that make initial parsing impossible (ie. Script, Actionscript)" output="false">
		<cfreturn variables.instance.initialparser/>
    </cffunction>
	<cffunction name="setCacheSize" access="public" hint="Returns the size of the cache." output="false">
		<cfargument name="cachesize" type="numeric"/>
		<cfset variables.instance.cachesize = arguments.cachesize/>
    </cffunction>
	<cffunction name="getCacheSize" access="public" hint="Returns the size of the cache." output="false">
		<cfreturn variables.instance.cachesize/>
    </cffunction>
	<cffunction name="setShowLineNumbers" access="public" hint="Sets whether or not to use line numbers" output="false">
		<cfargument name="showLineNumbers" type="Boolean"/>
		<cfset variables.instance.showLineNumbers = arguments.showLineNumbers/>
    </cffunction>
	<cffunction name="getShowLineNumbers" access="public" hint="Gets setting on whether or not to use line numbers" output="false">
		<cfreturn variables.instance.showLineNumbers/>
    </cffunction>
	<cffunction name="setShowToolbar" access="public" hint="Sets whether or not to use the toolbar" output="false">
		<cfargument name="showToolbar" type="Boolean"/>
		<cfset variables.instance.showToolbar = arguments.showToolbar/>
    </cffunction>
	<cffunction name="getShowToolbar" access="public" hint="Gets setting on whether or not to use the toolbar" output="false">
		<cfreturn variables.instance.showToolbar/>
    </cffunction>
</cfcomponent>