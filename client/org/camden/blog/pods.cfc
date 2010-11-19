<cfcomponent output="false" displayName="Pods">
	
	
<cffunction name="getPods" access="public" returnType="struct" output="false" hint="Gets pods">
	<cfargument name="directory" type="string" required="true">
	<cfset var pod = "">
		
	<cfset pod = getInfo(arguments.directory)>
	
	<cfreturn pod>
</cffunction>

<cffunction name="getInfo" access="public" returnType="struct" output="false" hint="Try to find an xml file and parse it.">
	<cfargument name="directory" type="string" required="true">
	<cfset var result = structNew()>
	<cfset var xmlFile = arguments.directory & "/pods.xml">
	<cfset var xmlPacket = "">
	<cfset var x = "">
	<cfset var pod = structNew()>
	<cfset var podNode = "">
	
	<cfset result.name = "">
	<cfset result.pods = structNew()>
	
	<cfif not directoryExists(arguments.directory) or not fileExists(xmlFile)>
		<cfreturn result>
	</cfif>
	
	<cfset result.name = listLast(arguments.directory, "/\")>
	
	<cffile action="read" file="#xmlFile#" variable="xmlPacket">
	<cfset xmlPacket = xmlParse(xmlPacket)>
	
	<cfif not structKeyExists(xmlPacket, "pods")>
		<cfreturn result>
	</cfif> 
	
	<cfif structKeyExists(xmlPacket.pods, "files") and arrayLen(xmlPacket.pods.files.xmlChildren)>
		<cfloop index="x" from="1" to="#arrayLen(xmlPacket.pods.files.xmlChildren)#">
			<cfset podNode = xmlPacket.pods.files.xmlChildren[x]>
			<cfif structKeyExists(podNode.xmlAttributes, "name") and structKeyExists(podNode.xmlAttributes, "sortorder")>
				<cfset pod.filename = podNode.xmlAttributes.name>
				<cfset pod.sortOrder = podNode.xmlAttributes.sortorder>
				<cfset result.pods[pod.filename] = pod.sortorder>
			</cfif>				
		</cfloop> 
	</cfif>

	<cfreturn result>	
</cffunction>

<cffunction name="updateInfo" access="public" returnType="void" output="false" hint="Updates the XML packet.">
	<cfargument name="directory" type="string" required="true">
	<cfargument name="md" type="struct" required="true">
	<cfset var xmlFile = arguments.directory & "/pods.xml">
	<cfset var packet = "">
	<cfset var image = "">
	<cfset var pod = "">
	
	<cfxml variable="packet">
	<cfoutput>
<pods>
	<files>
	<cfloop item="pod" collection="#arguments.md.pods#">
		<pod name="#lcase(pod)#" sortorder="#arguments.md.pods[pod]#" />
	</cfloop>
	</files>
</pods>
	</cfoutput>	
	</cfxml>
	
	<cffile action="write" file="#xmlFile#" output="#toString(packet)#">
</cffunction>

</cfcomponent>