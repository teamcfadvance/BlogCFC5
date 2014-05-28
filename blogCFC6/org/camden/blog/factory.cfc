<!---
	Name         : objectFactory.cfc
	Author       : Rob Gonda
	Created      : August 25, 2006
	Last Updated : August 25, 2006
	History      : 
	Purpose		 : Simple Object Factory / Service Locator
--->
<cfcomponent displayname="objectFactory" hint="I am a simple object factory">

	<cffunction name="init" access="public" output="No" returntype="factory">
		<cfargument name="settings" type="struct" required="true">
		
		<cfset variables.com = structNew()>
		<cfset variables.settings = arguments.settings>

		<cfreturn this />
	</cffunction>

	<!--- 
		function getObject
		in:		name of object
		out:	object
		notes:	
	 --->
	<cffunction name="get" access="public" output="No" returntype="any">
		<cfargument name="objName" required="false" type="string" />
		<cfargument name="singleton" required="false" type="boolean" default="true" />
		
		<cfscript>
			var obj = ''; //local var to hold object
			if (arguments.singleton and singletonExists(arguments.objName)) {
				return getSingleton(arguments.objName);
			}
		
			switch(arguments.objName) {

				case "entryService":
					obj = createObject('component','entry').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings(variables.settings);
						obj.setUtils(get("utils"));
					return obj;
				break;

				case "page":
					obj = createObject('component','page').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings(variables.settings);
					return obj;
				break;

				case "themeservice":
					obj = createObject('component','theme').init();
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
						// inject dependencies through setter
						obj.setSettings(variables.settings);
						obj.setEntryService(get("entryService"));
					return obj;
				break;

				case "utils":
					obj = createObject('component','utils');
						if (arguments.singleton) { // scope singleton
							addSingleton(arguments.objName, obj);
						}
					return obj;
				break;
			}
		</cfscript>
		
	</cffunction>
	
	
	<cffunction name="singletonExists" access="public" output="No" returntype="boolean">
		<cfargument name="objName" required="Yes" type="string" />
		<cfreturn StructKeyExists(variables.com, arguments.objName) />
	</cffunction>
	
	<cffunction name="addSingleton" access="public" output="No" returntype="void">
		<cfargument name="objName" required="Yes" type="string" />
		<cfargument name="obj" required="Yes" />
		<cfset variables.com[arguments.objName] = arguments.obj />
	</cffunction>

	<cffunction name="getSingleton" access="public" output="No" returntype="any">
		<cfargument name="objName" required="Yes" type="string" />
		<cfreturn variables.com[arguments.objName] />
	</cffunction>

	<cffunction name="removeSingleton" access="public" output="No" returntype="void">
		<cfargument name="objName" required="Yes" />
		<cfscript>
			if ( StructKeyExists(variables.com, arguments.objName) ){
				structDelete(variables.com, arguments.objName);
			}
		</cfscript>
	</cffunction>

</cfcomponent>