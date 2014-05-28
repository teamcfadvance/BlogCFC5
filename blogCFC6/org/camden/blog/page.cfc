<cfcomponent displayName="Page" output="false">

<cffunction name="init" returnType="page" output="false" access="public">
	<cfreturn this>
</cffunction>

<cffunction name="deletePage" returnType="void" output="false" access="public">
	<cfargument name="id" type="uuid" required="true">
	
	<cfquery datasource="#variables.settings.dsn#" username="#variables.settings.username#" password="#variables.settings.password#">
	delete from tblblogpages
	where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	and		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settings.blogname#" maxlength="50">
	</cfquery>
</cffunction>

<cffunction name="getPage" returnType="struct" output="false" access="public">
	<cfargument name="id" type="uuid" required="true">
	<cfset var q = "">
	<cfset var s = structNew()>
	
	<cfquery name="q" datasource="#variables.settings.dsn#" username="#variables.settings.username#" password="#variables.settings.password#">
	select		id, blog, title, alias, body
	from		tblblogpages
	where		id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	and			blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settings.blogname#" maxlength="50">
	</cfquery>

	<cfif q.recordCount>
		<cfset s.id = q.id>
		<cfset s.blog = q.blog>
		<cfset s.title = q.title>
		<cfset s.alias = q.alias>
		<cfset s.body = q.body>
	</cfif>
		
	<cfreturn s>
</cffunction>

<cffunction name="getPageByAlias" returnType="struct" output="false" access="public">
	<cfargument name="alias" type="string" required="true">
	<cfset var q = "">
	<cfset var s = structNew()>
	
	<cfquery name="q" datasource="#variables.settings.dsn#" username="#variables.settings.username#" password="#variables.settings.password#">
	select		id, blog, title, alias, body
	from		tblblogpages
	where		alias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">
	and			blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settings.blogname#" maxlength="50">
	</cfquery>

	<cfif q.recordCount>
		<cfset s.id = q.id>
		<cfset s.blog = q.blog>
		<cfset s.title = q.title>
		<cfset s.alias = q.alias>
		<cfset s.body = q.body>
	</cfif>
		
	<cfreturn s>
</cffunction>

<cffunction name="getPages" returnType="query" output="false" access="public">
	<cfset var q = "">
	
	<cfquery name="q" datasource="#variables.settings.dsn#" username="#variables.settings.username#" password="#variables.settings.password#">
	select		id, blog, title, alias, body
	from		tblblogpages
	where		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settings.blogname#" maxlength="50">
	order by 	title asc
	</cfquery>
	
	<cfreturn q>
</cffunction>

<cffunction name="savePage" returnType="void" output="false" access="public">
	<cfargument name="id" type="string" required="true">
	<cfargument name="title" type="string" required="true">
	<cfargument name="alias" type="string" required="true">
	<cfargument name="body" type="string" required="true">
	
	<cfif arguments.id is 0>
		<cfset arguments.id = createUUID()>

		<cfquery datasource="#variables.settings.dsn#" username="#variables.settings.username#" password="#variables.settings.password#">
		insert into tblblogpages(id, title, alias, body, blog)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="255">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settings.blogname#" maxlength="35">
			)
		</cfquery>

	<cfelse>
	
		<cfquery datasource="#variables.settings.dsn#" username="#variables.settings.username#" password="#variables.settings.password#">
		update tblblogpages
		set
				title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="255">,
				alias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">,
				body = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body#">
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
	</cfif>
	
</cffunction>

<cffunction name="setSettings" access="public" returnType="void" output="false">
	<cfargument name="settings" type="struct" required="true">
	<cfset variables.settings = arguments.settings>
</cffunction>

</cfcomponent>