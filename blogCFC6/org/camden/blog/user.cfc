<cfcomponent>

	<cffunction name="addSubscriber" access="remote" returnType="string" output="false"
				hint="Adds a subscriber to the blog.">
		<cfargument name="email" type="string" required="true">
		<cfset var token = createUUID()>
		<cfset var getMe = "">

		<!--- First, lets see if this guy is already subscribed. --->
		<cfquery name="getMe" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select	email
		from	tblblogsubscribers
		where	email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="50">
		and		blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
		</cfquery>

		<cfif getMe.recordCount is 0>
			<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			insert into tblblogsubscribers(email,
			token,
			blog,
			verified)
			values(<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="50">,
			<cfqueryparam value="#token#" cfsqltype="cf_sql_varchar" maxlength="35">,
			<cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">,
			0
			)
			</cfquery>

			<cfreturn token>

		<cfelse>

			<cfreturn "">

		</cfif>

	</cffunction>
	
	<cffunction name="addUser" access="public" returnType="void" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var q = "">

		<cflock name="blogcfc.adduser" type="exclusive" timeout="60">
			<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			select	username
			from	tblusers
			where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
			and		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
			</cfquery>

			<cfif q.recordCount>
				<cfset variables.utils.throw("#arguments.name# already exists as a user.")>
			</cfif>

			<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			insert into tblusers(username, name, password, blog)
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="50">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
			)
			</cfquery>
		</cflock>

	</cffunction>

	<cffunction name="authenticate" access="public" returnType="boolean" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">

		<cfset var q = "">

		<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			select 	username
			from	tblusers
			where	username = <cfqueryparam value="#arguments.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
			and		password = <cfqueryparam value="#arguments.password#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
			and		blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfquery>

		<cfreturn q.recordCount is 1>

	</cffunction>

	<cffunction name="confirmSubscription" access="public" returnType="void" output="false"
				hint="Confirms a user's subscription to the blog.">
		<cfargument name="token" type="uuid" required="false">
		<cfargument name="email" type="string" required="false">

		<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		update	tblblogsubscribers
		set		verified = 1
		<cfif structKeyExists(arguments, "token")>
		where	token = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.token#">
		<cfelseif structKeyExists(arguments, "email")>
		where	email = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#arguments.email#">
		<cfelse>
			<cfthrow message="Invalid call to confirmSubscription. Must pass token or email.">
		</cfif>
		</cfquery>

	</cffunction>
	
	<cffunction name="deleteUser" access="public" returnType="void" output="false" hint="Deletes a user.">
		<cfargument name="username" type="string" required="true">

		<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		delete from tblusers
		where	blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		and		username = <cfqueryparam value="#arguments.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfquery>

	</cffunction>

	<cffunction name="getBlogRoles" access="public" returnType="query" output="false">
		<cfset var q = "">

		<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select	id, role, description
		from	tblblogroles
		</cfquery>

		<cfreturn q>
	</cffunction>

	<cffunction name="getNameForUser" access="public" returnType="string" output="false">
		<cfargument name="username" type="string" required="true">
		<cfset var q = "">

		<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select	name
		from	tblusers
		where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
		</cfquery>

		<cfreturn q.name>
	</cffunction>

	<cffunction name="getSubscribers" access="public" returnType="query" output="false"
				hint="Returns all people subscribed to the blog.">
		<cfargument name="verifiedonly" type="boolean" required="false" default="false">
		<cfset var getPeople = "">

		<cfquery name="getPeople" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select		email, token, verified
		from		tblblogsubscribers
		where		blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
		<cfif		arguments.verifiedonly>
		and			verified = 1
		</cfif>
		order by	email asc
		</cfquery>

		<cfreturn getPeople>
	</cffunction>
	
	<cffunction name="getUser" access="public" returnType="struct" output="false" hint="Returns a user for a blog.">
		<cfargument name="username" type="string" required="true">
		<cfset var q = "">
		<cfset var s = structNew()>

		<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select	username, password, name
		from	tblusers
		where	blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		and		username = <cfqueryparam value="#arguments.username#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfquery>
		<cfif q.recordCount>
			<cfset s.username = q.username>
			<cfset s.password = q.password>
			<cfset s.name = q.name>
			<cfreturn s>
		<cfelse>
			<cfthrow message="Unknown user #arguments.username# for blog.">
		</cfif>

	</cffunction>
	
	<cffunction name="getUserByName" access="public" returnType="string" output="false"
				hint="Get username based on encoded name.">
		<cfargument name="name" type="string" required="true">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select	username
		from	tblusers
		where	name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(arguments.name,"_"," ","all")#" maxlength="50">
		</cfquery>
		
		<cfreturn q.username>

	</cffunction>

	<cffunction name="getUserBlogRoles" access="public" returnType="string" output="false">
		<cfargument name="username" type="string" required="true">
		<cfset var q = "">

		<!--- MSACCESS fix provided by Andy Florino --->
		<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		<cfif instance.blogDBType is "MSACCESS">
		select tblblogroles.id
		from tblblogroles, tbluserroles, tblusers
		where (tblblogroles.id = tbluserroles.roleidfk and tbluserroles.username = tblusers.username)
		and tblusers.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
		and tblusers.blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		<cfelse>
		select	tblblogroles.id
		from	tblblogroles
		left join tbluserroles on tbluserroles.roleidfk = tblblogroles.id
		left join tblusers on tbluserroles.username = tblusers.username
		where tblusers.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
		and tblusers.blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfif>
		</cfquery>

		<cfreturn valueList(q.id)>
	</cffunction>
	
	<cffunction name="getUsers" access="public" returnType="query" output="false" hint="Returns users for a blog.">
		<cfset var q = "">

		<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select	username, password, name
		from	tblusers
		where	blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
		</cfquery>

		<cfreturn q>
	</cffunction>

	<cffunction name="isBlogAuthorized" access="public" returnType="boolean" output="false" hint="Simple wrapper to check session roles and see if you are cool to do stuff. Admin role can do all.">
		<cfargument name="role" type="string" required="true">
		<!--- Roles are IDs, but to make code simpler, we allow you to specify a string, so do a cached lookup conversion. --->
		<cfset var q = "">

		<!--- cache admin once --->
		<cfif not structKeyExists(variables.roles, 'admin')>
			<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			select	id
			from	tblblogroles
			where	role = <cfqueryparam cfsqltype="cf_sql_varchar" value="admin" maxlength="50">
			</cfquery>
			<cfset variables.roles['admin'] = q.id>
		</cfif>

		<cfif not structKeyExists(variables.roles, arguments.role)>
			<cfquery name="q" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			select	id
			from	tblblogroles
			where	role = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role#" maxlength="50">
			</cfquery>
			<cfset variables.roles[arguments.role] = q.id>
		</cfif>

		<cfreturn (listFindNoCase(session.roles, variables.roles[arguments.role]) or listFindNoCase(session.roles, variables.roles['admin']))>
	</cffunction>
	
	<cffunction name="removeSubscriber" access="remote" returnType="boolean" output="false"
				hint="Removes a subscriber user.">
		<cfargument name="email" type="string" required="true">
		<cfargument name="token" type="uuid" required="false">
		<cfset var getMe = "">

		<cfif not isUserInRole("admin") and not structKeyExists(arguments,"token")>
			<cfset variables.utils.throw("Unauthorized removal.")>
		</cfif>

		<!--- First, lets see if this guy is already subscribed. --->
		<cfquery name="getMe" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select	email
		from	tblblogsubscribers
		where	email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="50">
		<cfif structKeyExists(arguments, "token")>
		and		token = <cfqueryparam value="#arguments.token#" cfsqltype="cf_sql_varchar" maxlength="35">
		</cfif>
		</cfquery>

		<cfif getMe.recordCount is 1>
			<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			delete	from tblblogsubscribers
			where	email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="50">
			<cfif structKeyExists(arguments, "token")>
			and		token = <cfqueryparam value="#arguments.token#" cfsqltype="cf_sql_varchar" maxlength="35">
			</cfif>
			and		blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
			</cfquery>

			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>

	</cffunction>
	
	<cffunction name="removeUnverifiedSubscribers" access="remote" returnType="void" output="false" roles="admin"
				hint="Removes all subscribers who are not verified.">

		<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		delete	from tblblogsubscribers
		where	blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
		and		verified = 0
		</cfquery>

	</cffunction>

	<cffunction name="saveUser" access="public" returnType="void" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="password" type="string" required="true">

		<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		update	tblusers
		set		name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
				password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="50">
		where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
		and		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
		</cfquery>

	</cffunction>
	
	<cffunction name="setUserBlogRoles" access="public" returnType="void" output="false" roles="admin" hint="Sets a user's blog roles">
		<cfargument name="username" type="string" required="true">
		<cfargument name="roles" type="string" required="true">
		<cfset var r = "">
		<!--- first, nuke old roles --->
		<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		delete from tbluserroles
		where username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
		and blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
		</cfquery>

		<cfloop index="r" list="#arguments.roles#">
			<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			insert into tbluserroles(username, roleidfk, blog)
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#r#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.name#" maxlength="50">
			)
			</cfquery>
		</cfloop>

	</cffunction>
	
	<cffunction name="unsubscribeThread" access="public" returnType="boolean" output="false"
				hint="Removes a user from a thread.">
		<cfargument name="commentID" type="UUID" required="true">
		<cfargument name="email" type="string" required="true">
		<cfset var verifySubscribe = "">

		<!--- First ensure that the commentID equals the email --->
		<cfquery name="verifySubscribe" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			select	entryidfk
			from	tblblogcomments
			where	id = <cfqueryparam value="#arguments.commentID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			and		email = <cfqueryparam value="#arguments.email#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
		</cfquery>

		<!--- If we have a result, then set subscribe=0 for this user for ALL comments in the thread --->
		<cfif verifySubscribe.recordCount>

			<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
				update	tblblogcomments
				set		subscribe = 0
				where	entryidfk = <cfqueryparam value="#verifySubscribe.entryidfk#"
									cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				and		email = <cfqueryparam value="#arguments.email#" cfsqltype="CF_SQL_VARCHAR" maxlength="100">
			</cfquery>

			<cfreturn true>
		</cfif>

		<cfreturn false>
	</cffunction>


	<cffunction name="updatePassword" access="public" returnType="boolean" output="false"
				hint="Updates the current user's password.">
		<cfargument name="oldpassword" type="string" required="true">
		<cfargument name="newpassword" type="string" required="true">
		<cfset var checkit = "">

		<cfquery name="checkit" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
		select	password
		from	tblusers
		where	username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar" maxlength="50">
		and		password = <cfqueryparam value="#arguments.oldpassword#" cfsqltype="cf_sql_varchar" maxlength="50">
		and		blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
		</cfquery>

		<cfif checkit.recordCount is 0>
			<cfreturn false>
		<cfelse>
			<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			update	tblusers
			set		password = <cfqueryparam value="#arguments.newpassword#" cfsqltype="cf_sql_varchar" maxlength="50">
			where	username = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar" maxlength="50">
			and		blog = <cfqueryparam value="#instance.name#" cfsqltype="cf_sql_varchar" maxlength="50">
			</cfquery>
			<cfreturn true>
		</cfif>
	</cffunction>

</cfcomponent>
