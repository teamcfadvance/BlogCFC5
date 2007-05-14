<cfcomponent extends="render" instructions="To include a file, use <cfinclude template=""xxx"" where xxx is relative to the blog CFC or specified with a ColdFusion Mapping.">

<cffunction name="display">
	<cfargument name="template" type="string" required="false" default="">
	<cfset var buffer = "">
	
	<cfif len(arguments.template)>
		<cfsavecontent variable="buffer">
		<cfinclude template="#arguments.template#">
		</cfsavecontent>
		<cfreturn buffer>
	</cfif>
	
	<cfreturn "">
	
</cffunction>

</cfcomponent>