<cfcomponent displayName="Page" output="false">

<cfset variables.dsn = "">
<cfset variables.username = "">
<cfset variables.password = "">
<cfset variables.blog = "">

<cffunction name="init" returnType="page" output="false" access="public">
	<cfargument name="dsn" type="string" required="true">
	<cfargument name="username" type="string" required="true">
	<cfargument name="password" type="string" requirred="true">
	<cfargument name="blog" type="string" required="true">

	<cfset variables.dsn = arguments.dsn>
	<cfset variables.username = arguments.username>
	<cfset variables.password = arguments.password>
	<cfset variables.blog = arguments.blog>

	<cfreturn this>
</cffunction>

<cffunction name="deletePage" returnType="void" output="false" access="public">
	<cfargument name="id" type="uuid" required="true">

	<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
	delete from #application.tableprefix#tblblogpages
	where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	and		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
	</cfquery>

	<!--- remove all cats --->
	<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
	delete from #application.tableprefix#tblblogpagescategories
	where pageidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	</cfquery>

</cffunction>

<cffunction name="getCategoriesForPage" returnType="query" output="false" access="public">
	<cfargument name="id" type="uuid" required="true">
	<cfset var q = "">

	<cfquery name="q" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">


	select	tblblogcategories.categoryID, tblblogcategories.categoryname
	from	tblblogcategories, #application.tableprefix#tblblogpagescategories
	where	tblblogcategories.categoryID = #application.tableprefix#tblblogpagescategories.categoryidfk
	and		#application.tableprefix#tblblogpagescategories.pageidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
	</cfquery>
	<cfreturn q>	
</cffunction>

<cffunction name="getPage" returnType="struct" output="false" access="public">
	<cfargument name="id" type="uuid" required="true">
	<cfset var q = "">
	<cfset var s = structNew()>

	<cfquery name="q" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
	select		id, blog, title, alias, body, showlayout
	from		#application.tableprefix#tblblogpages
	where		id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	and			blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
	</cfquery>

	<cfif q.recordCount>
		<cfset s.id = q.id>
		<cfset s.blog = q.blog>
		<cfset s.title = q.title>
		<cfset s.alias = q.alias>
		<cfset s.body = q.body>
		<cfset s.showlayout = q.showlayout>
		<cfset s.categories = getCategoriesForPage(q.id)>
	</cfif>

	<cfreturn s>
</cffunction>

<cffunction name="getPageByAlias" returnType="struct" output="false" access="public">
	<cfargument name="alias" type="string" required="true">
	<cfset var q = "">
	<cfset var s = structNew()>

	<cfquery name="q" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
	select		id, blog, title, alias, body, showlayout
	from		#application.tableprefix#tblblogpages
	where		alias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">
	and			blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
	</cfquery>

	<cfif q.recordCount>
		<cfset s.id = q.id>
		<cfset s.blog = q.blog>
		<cfset s.title = q.title>
		<cfset s.alias = q.alias>
		<cfset s.body = q.body>
		<cfset s.showlayout = q.showlayout>
	</cfif>

	<cfreturn s>
</cffunction>

<cffunction name="getPages" returnType="query" output="false" access="public">
	<cfset var q = "">

	<cfquery name="q" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
	select		id, blog, title, alias, body, showlayout
	from		#application.tableprefix#tblblogpages
	where		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="50">
	order by 	title asc
	</cfquery>

	<cfreturn q>
</cffunction>

<cffunction name="savePage" returnType="void" output="false" access="public">
	<cfargument name="id" type="string" required="true">
	<cfargument name="title" type="string" required="true">
	<cfargument name="alias" type="string" required="true">
	<cfargument name="body" type="string" required="true">
	<cfargument name="showlayout" type="boolean" required="true">
	<cfargument name="categories" type="string" required="true">

	<cfset var c = "">
	
	<cfif arguments.id is 0>
		<cfset arguments.id = createUUID()>

		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		insert into #application.tableprefix#tblblogpages(id, title, alias, body, blog, showlayout)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="255">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.blog#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.showlayout#">
			)
		</cfquery>

	<cfelse>

		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		update #application.tableprefix#tblblogpages
		set
				title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="255">,
				alias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.alias#" maxlength="100">,
				body = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body#">,
				showlayout = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.showlayout#">
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

	</cfif>

	<!--- remove all cats --->
	<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
	delete from #application.tableprefix#tblblogpagescategories
	where pageidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
	</cfquery>
	
	<cfloop index="c" list="#arguments.categories#">
		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		insert into #application.tableprefix#tblblogpagescategories(pageidfk,categoryidfk)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#c#" maxlength="35">
			)
		</cfquery>
	</cfloop>
	
</cffunction>

</cfcomponent>