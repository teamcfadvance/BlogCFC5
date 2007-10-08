<cfcomponent name="CF7 Ping" extends="ping">

	<cffunction name="pingAggregators" access="public" returnType="void" output="false" 
				hint="Pings blog aggregators.">
		<cfargument name="pingurls" type="string" required="true">
		<cfargument name="blogtitle" type="string" required="true">
		<cfargument name="blogurl" type="string" required="true">
		
		<cfset var aURL = "">

		<cfloop index="aURL" list="#arguments.pingurls#">
		
			<cfif aURL is "@technorati">
				<cfset pingTechnorati(arguments.blogTitle, arguments.blogURL)>
			<cfelseif aURL is "@weblogs">
				<cfset pingweblogs(arguments.blogTitle, arguments.blogURL)>
			<cfelseif aURL is "@icerocket">
				<cfset pingIceRocket(arguments.blogTitle, arguments.blogURL)>
			<cfelse>
				<cfhttp url="#aURL#" method="GET" resolveurl="false">
			</cfif>
		
		</cfloop>		
		   
	</cffunction>	

</cfcomponent>