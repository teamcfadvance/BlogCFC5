<cfif structKeyExists(form, "submit")>
	<cfset session.dsn = form.dsn>
	<cfset session.dbtype = form.dbtype>
	<cfset session.dsnusername = form.dsnusername>
	<cfset session.dsnpassword = form.dsnpassword>
	<cfset session.saltAlgorithm = form.saltAlgorithm>
	<cfset session.saltKeySize = form.saltKeySize>
	<cfset session.hashAlgorithm = form.hashAlgorithm>

	<cfset setProfileString(application.iniFile, session.blogname, "dsn", form.dsn)>
	<cfset setProfileString(application.iniFile, session.blogname, "blogdbtype", form.dbtype)>
	<cfset setProfileString(application.iniFile, session.blogname, "username", form.dsnusername)>
	<cfset setProfileString(application.iniFile, session.blogname, "password", form.dsnpassword)>
	
	<cfset setProfileString(application.iniFile, session.blogname, "saltAlgorithm", form.saltAlgorithm)>
	<cfset setProfileString(application.iniFile, session.blogname, "saltKeySize", form.saltKeySize)>
	<cfset setProfileString(application.iniFile, session.blogname, "hashAlgorithm", form.hashAlgorithm)>

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
<fieldset>
	<legend>DSN Settings</legend>
<label>DSN Name:</label> <input type="text" name="dsn" class="required"><br/>
<label>Database Type:</label> <select name="dbtype">
<cfloop item="dbtype" collection="#application.dbtypes#">
	<cfoutput><option value="#dbtype#">#application.dbtypes[dbtype]#</option></cfoutput>
</cfloop>
</select><br/>
<label>Username:</label> <input type="text" name="dsnusername"><br/>
<label>Password:</label> <input type="text" name="dsnpassword"><br/>
</fieldset>
			<fieldset>
				<legend>Crypto Settings</legend>
				<p>
				In most cases, the default settings here should be fine.  Unless you have a specific reason to change these values, 
				changing them may affect how securely your passwords are stored.
				</p>
				<table>
				<tr>
					<td><label>Salt Algorithm:</label></td>
					<td><select name="saltAlgorithm" >
							<option value="AES">AES</option>
							<option value="BLOWFISH">BLOWFISH (not recommended)</option>
							<option value="DES">DES (not recommended)</option>
						</select></td>
				</tr>
				<tr>
					<td><label>Salt Key Length:</label></td>
					<td><input type="text" name="saltKeySize" value="256"></td>
				</tr>
				<tr>
					<td><label>Hash Algorithm:</label></td>
					<td><select name="hashAlgorithm">
							<option value="MD5">MD5 (not recommended)</option>
							<option value="SHA">SHA (not recommended)</option>
							<option value="SHA-224">SHA-224 (CF Enterprise Only)</option>
							<option value="SHA-256">SHA-256</option>
							<option value="SHA-384">SHA-384</option>
							<option value="SHA-512" selected>SHA-512</option>
						</select></td>
				</tr>
				</table>
			</fieldset>



<input type="submit" name="submit" value="Verify and Continue">
</form>

</cf_layout>