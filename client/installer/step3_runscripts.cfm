
<cfif structKeyExists(form, "runscripts")>

	<cfset scriptFile = expandPath("./#lcase(session.dbtype)#/script.txt")>
	<cffile action="read" file="#scriptFile#" variable="sql">
	<cfif session.dbtype is "mysql">
		<cfset parts = listToArray(sql, ";")>
	<cfelseif session.dbtype is "mssql">
		<cfset parts = sql.split("(?m)^GO")>

	</cfif>
	<cfloop index="x" from="1" to="#arrayLen(parts)#">
		<cfset sql = trim(parts[x])>
		<cfif len(sql)>
			<cfquery datasource="#session.dsn#" username="#session.dsnusername#" password="#session.dsnpassword#">
			#preserveSingleQuotes(sql)#
			</cfquery>
		</cfif>
	</cfloop>
	
	<!--- if values other than the defaults are chosen for crypto, we need to update 
	the admin user values we just wrote to the database. There are much cleaner ways
	to do all of this, but that would require rewriting a substantial part of the 
	install wizard, and really, who wants to spend their time doing that? --->
	<cfif (session.saltAlgorithm IS NOT "AES") OR (session.saltKeySize IS NOT "256") OR (session.hashAlgorithm IS NOT "SHA-512")>
		<cfset salt = generateSecretKey(session.saltalgorithm, session.saltkeySize)>
		
		<cfquery name="updateUserSecurity" datasource="#session.dsn#" username="#session.dsnusername#" password="#session.dsnpassword#">
			UPDATE tblusers
			SET password = <cfqueryparam value="#hash(salt & 'admin', session.hashAlgorithm)#" cfsqltype="cf_sql_varchar" maxlength="256">,
			    salt = <cfqueryparam value="#salt#" cfsqltype="cf_sql_varchar" maxlength="256">
			WHERE 	username = 'admin'
			and		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.blogName#" maxlength="50">
		</cfquery>
	</cfif>

	<cf_layout title="Step 3: Done with SQL Scripts">
	<p>
	I'm done running the SQL scripts.
	</p>

	<form action="step4_settings.cfm" method="post">
	<input type="submit" value="Move on to the settings.">
	</form>

	</cf_layout>
	<cfabort>

</cfif>

<cf_layout title="Step 3: Run SQL Scripts?">

<cfoutput>
<p>
Ok, you've told me that you want to use the DSN #session.dsn# which is a #application.dbtypes[session.dbtype]# database.
</p>

<cfif session.dbtype is "MSACCESS">
	<p>
	Because you have selected Microsoft Access for your database and have set the DSN up already, it is assumed you copied the file from the BlogCFC installation directory. Therefore, there are no scripts that need to be run to setup
	the database.
	</p>

	<form action="step4_settings.cfm" method="post">
	<input type="submit" value="Next">
	</form>

<cfelseif session.dbtype is "ORACLE">

	<p>
	Sorry, you've selected Oracle as your DB type. I don't currently support setting that type of database help. Please email me (ray@camdenfamily.com) if you want to help add that functionality.
	</p>

	<form action="step4_settings.cfm" method="post">
	<input type="submit" value="Next">
	</form>

<cfelse>

	<p>
	Would you like me to attempt to run the database scripts? This will create the BlogCFC tables and populate them with the initial user data. This should only (normally!) be done on an empty database.
	</p>

	<form  method="post">
	<input type="submit" name="runscripts" value="Yes, set up my database please.">
	</form>

	<form action="step4_settings.cfm" method="post">
	<input type="submit" value="No, move on to the settings.">
	</form>


</cfif>

</cfoutput>

</cf_layout>