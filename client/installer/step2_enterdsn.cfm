<cfif structKeyExists(form, "submit")>
	<cfset session.dsn = form.dsn>
	<cfset session.dbtype = form.dbtype>
	<cfset session.dsnusername = form.dsnusername>
	<cfset session.dsnpassword = form.dsnpassword>

	<cfset setProfileString(application.iniFile, session.blogname, "dsn", form.dsn)>
	<cfset setProfileString(application.iniFile, session.blogname, "blogdbtype", form.dbtype)>
	<cfset setProfileString(application.iniFile, session.blogname, "username", form.dsnusername)>
	<cfset setProfileString(application.iniFile, session.blogname, "password", form.dsnpassword)>

	<cflocation url="step3_runscripts.cfm" addToken="false">
</cfif>

<cf_layout title="Step 2: Enter DSN">

<script>
$(document).ready(function(){
	$("#dsnForm").validate()
})
</script>

<p>
In this step I need you to provide the name of the DSN and database type you will be using with BlogCFC. <b>Ensure this DSN and database exists!</b>
If your DSN requires a username and password, be sure to include that as well.
</p>

<p>
<form id="dsnForm" method="post">
<b>DSN Name:</b> <input type="text" name="dsn" class="required"><br/>
<b>Database Type:</b> <select name="dbtype">
<cfloop item="dbtype" collection="#application.dbtypes#">
	<cfoutput><option value="#dbtype#">#application.dbtypes[dbtype]#</option></cfoutput>
</cfloop>
</select><br/>
<b>Username:</b> <input type="text" name="dsnusername"><br/>
<b>Password:</b> <input type="text" name="dsnpassword"><br/>

<input type="submit" name="submit" value="Verify and Continue">
</form>

</cf_layout>