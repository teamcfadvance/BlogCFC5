<!---
	What: Security Update for blogCFC 5.9.8.001
	Who: Rob Brooks-Bilson (rbils@amkor.com)
	When: January 25, 2011
	
	Here's what we're going to do:
	1. Choose hash and salt algorithms
	2. Get DSN information
	3. Validate database hasn't already been converted
	4. Change the length of the password field in tblUsers table from 50 to 256 for MySQL, MSSQL, and Oracle or 255 for MSACCESS
	5. Add a new field called Salt to the tblusers table (256 varchar for MySQL, MSSQL, and Oracle or 255 text for MSACCESS)
	6. Generate random Salt and hash the passwords for every user in the table
	7. Update the blogcfc.ini.cfm with the crypto info used.
	
	DISCLAIMER: Backup your tblusers table before you run this. You've been warned. If you blow up your users table and don't have a backup it's your fault, not mine.
--->
<cfparam name="url.step" type="integer" default="1" />
 
<cfswitch expression="#url.step#">
	<cfcase value="1">
		<cfpod height="500" width="500" title="BlogCFC 5.9.8.001 Security Updater: Step 1">
		<cfoutput>
		Welcome to the BlogCFC Security Updater
		<p>
		WARNING! Before you continue, it is strongly recommended that you make a backup of your tblusers table.  
		Running this wizard will alter your existing users table and will result in hashing all of the passwords
		in the database. A hash is a one-way operation. It is not possible to decrypt or reverse a hash.
		</p>
		<p>
		You should also note that runninng this script will affect the user table for all blogs.  If you're only
		running one blog, this isn't an issue.  However, if you have multiple blogs that share the same database
		you will need to ensure that you update the blogCFC code for ALL of those blogs after running this script.		
		</p>
		<p>
		In general, you should accept the default values below.  The values you select here should be added to 
		your blogcfc.ini.cfm file after you finish running the wizard.  If you are running multiple blogs from
		a single .ini file, the values you set here will apply to all blogs. 
		</p>
		<form action="#cgi.SCRIPT_NAME#?step=2" method="post" >
			<fieldset>
				<legend>Crypto Settings</legend>
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
			<p>
			<input type="submit" name="submit" value="Submit" />
			<p>		
		</form>
		</cfoutput>
		</cfpod>
	</cfcase>
	

	<cfcase value="2">
		<cfset session.saltAlgorithm = form.saltAlgorithm>
		<cfset session.saltKeySize = form.saltKeySize>
		<cfset session.hashAlgorithm = form.hashAlgorithm>
		
		<cfpod height="500" width="500" title="BlogCFC 5.9.8.001 Security Updater: Step 2">
		<cfoutput>
		<p>
		Next, we need to gather some information about your blogCFC data source.
		</p>
		
		<form action="#cgi.SCRIPT_NAME#?step=3" method="post">
			<fieldset>
				<legend>Data Source Settings</legend>
				<table>
				<tr>
					<td><label>DSN:</label></td>
					<td><input type="text" name="DSN"></td>
				</tr>
				<tr>
					<td><label>Username:</label></td>
					<td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td><label>Password:</label></td>
					<td><input type="password" name="password"></td>
				</tr>
				</table>
			</fieldset>
			<p>
			Click Submit to have the wizard validate your blogCFC database and
			create the required table modifications.
			</p>
			<p>
			<input type="submit" name="submit" value="Submit" />
			</p>
		</form>
		</cfoutput>
		</cfpod>
	</cfcase>
	
	<cfcase value="3">
		<cfset session.dsn = form.dsn>
		<cfset session.username = form.username>
		<cfset session.password = form.password>
		
		<cfset proceed = true>
		<cfpod height="500" width="500" title="BlogCFC 5.9.8.001 Security Updater: Step 3">
		<!--- first, check that the DSN is valid and that it is a blogCFC database --->
		<cftry>
			<cfdbinfo 
				datasource="#session.dsn#" 
				username="#session.username#" 
				password="#session.password#" 
				dbname="blogCFC" 
				name="myDSN" 
				type="Columns" 
				table="#application.tableprefix#tblUsers">
				
				<!--- see if the Salt field already exists. If so, there's no need 
				      to run these steps again as they'll just cause errors. --->
				<cfquery dbtype="query" name="checkField">
					SELECT *
					FROM myDSN
					WHERE column_name = 'salt'
				</cfquery>
				
				<cfif checkField.recordCount is 1>
					<cfthrow type="com.updater.fieldExists" message="It appears as though this data source has already been updated.">
				</cfif>
			
			<cfcatch type="com.updater.fieldExists">
				<cfset proceed = false>
				<cfoutput>#cfcatch.message#</cfoutput>			
			</cfcatch>
			
			<cfcatch type="any">
				<cfset proceed = false>
				Data source not found or this is not a BlogCFC database. Please check your DSN information and try again.
				<cfdump var="#cfcatch#"> 
			</cfcatch>
		</cftry>
		
		<cfif proceed>	
			<!--- Let's increase the length of the password field and add a new field for salt --->
			<cfdbinfo 
				datasource="#session.dsn#" 
				username="#session.username#" 
				password="#session.password#" 
				type="version" 
				name="dbType">
			
			<!--- Note the use of cftransaction. For most of the databases, altering the table is a two step process. 
				  First we add a new field then we lengthen an existing field.  If either of those operations fail, we 
				  want to roll back so that the database is in the same state as when we started. That will make it 
				  easier to re-run the updater after you've sorted out what went wrong. --->					
			<cfswitch expression="#dbType.DATABASE_PRODUCTNAME#">
				<cfcase value="MySQL">
					<cftransaction>
					<cftry>
						<cfquery name="updateDB" datasource="#session.dsn#" username="#session.username#" password="#session.password#">
							ALTER TABLE `#application.tableprefix#tblUsers` CHANGE COLUMN `password` `password` VARCHAR(256) NULL DEFAULT NULL  ;
						</cfquery>
						
						<cfcatch type="any">
							<cfset proceed = false>
							Unable to increase the length of the password column.
							<cfdump var="#cfcatch#">
						</cfcatch>
					</cftry>
					
					<cfif proceed>
						<cftry>
							<cfquery name="updateDB" datasource="#session.dsn#" username="#session.username#" password="#session.password#">
								ALTER TABLE `#application.tableprefix#tblUsers` ADD COLUMN `salt` VARCHAR(256) NULL DEFAULT NULL AFTER `password` ;
							</cfquery>				
						
							<cfcatch type="any">
								<cfset proceed = false>
								Unable to create the Salt column.
								<cfdump var="#cfcatch#">
							</cfcatch>
						</cftry>
					</cfif>			
					</cftransaction>	
				</cfcase>
					
				<cfcase value="Microsoft SQL Server">
					<cftry>
						<cfquery name="updateDB" datasource="#session.dsn#" username="#session.username#" password="#session.password#">				
							ALTER TABLE #application.tableprefix#tblUsers
							ADD salt varchar(256) NULL;
								
							ALTER TABLE #application.tableprefix#tblUsers
							ALTER COLUMN password varchar(256);		
						</cfquery>		
						<cfcatch type="any">
							<cfset proceed = false>
							Unable to modify #application.tableprefix#tblUsers.
							<cfdump var="#cfcatch#">
						</cfcatch>
					</cftry>
				</cfcase>

				<cfcase value="Oracle">
					<cftransaction>
					<cftry>
						<cfquery name="updateDB" datasource="#session.dsn#" username="#session.username#" password="#session.password#">
							ALTER TABLE
							   #application.tableprefix#tblUsers
							MODIFY
							   (
							   password VARCHAR2(256) NULL
							   )
							;
						</cfquery>
						
						<cfcatch type="any">
							<cfset proceed = false>
							Unable to increase the length of the password column.
							<cfdump var="#cfcatch#">
						</cfcatch>
					</cftry>
					
					<cfif proceed>
						<cftry>
							<cfquery name="updateDB" datasource="#session.dsn#" username="#session.username#" password="#session.password#">
								ALTER TABLE
								   #application.tableprefix#tblUsers
								ADD
								   (
								   salt VARCHAR2(256) NULL
								   )
								;	
							</cfquery>				
						
							<cfcatch type="any">
								<cfset proceed = false>
								Unable to create the Salt column.
								<cfdump var="#cfcatch#">
							</cfcatch>
						</cftry>
					</cfif>				
					</cftransaction>		
				</cfcase>
			
				<cfcase value="Microsoft Access">
					<cftransaction>
					<cftry>
						<!--- access only supports 255 chars in a text field. Not a problem now but it will be if we get to 256 charter values --->
						<cfquery name="updateDB" datasource="#session.dsn#" username="#session.username#" password="#session.password#">					
							ALTER TABLE #application.tableprefix#tblUsers
							ALTER COLUMN Password TEXT(255)
						</cfquery>

						<cfcatch type="any">
							<cfset proceed = false>
							Unable to increase the length of the password column.
							<cfdump var="#cfcatch#">
						</cfcatch>
					</cftry>
					
					<cfif proceed>
						<cftry>
							<cfquery name="updateDB" datasource="#session.dsn#" username="#session.username#" password="#session.password#">
								ALTER TABLE #application.tableprefix#tblUsers
								ADD COLUMN Salt TEXT(255)  
							</cfquery>				
						
							<cfcatch type="any">
								<cfset proceed = false>
								Unable to create the Salt column.
								<cfdump var="#cfcatch#">
							</cfcatch>
						</cftry>
					</cfif>	
					</cftransaction>
				</cfcase>
				
				<cfdefaultcase>
					<cfset proceed = false>
					You are using a potentially unsupported database.  
					This wizard is unable to automatically convert your passwords to the new format.
				</cfdefaultcase>
			</cfswitch>	
		
			<cfif proceed>
			<cfoutput>
			<p>
			The database tables have successfully been altered. 
			</p>
			<form action="#cgi.SCRIPT_NAME#?step=4" method="post">
				<input type="submit" name="submit" value="Continue">
			</form>		
			</cfoutput>
			</cfif>
		</cfif>
		</cfpod>
	</cfcase>
	
	<cfcase value="4">
	 	<cfset proceed = true>
		
		<cfpod height="500" width="500" title="BlogCFC 5.9.8.001 Security Updater: Step 4">
		<cftry>
		<cfquery name="getRecords" datasource="#session.dsn#" username="#session.username#" password="#session.password#">
			SELECT username, blog, password
			from #application.tableprefix#tblUsers
		</cfquery>

		<cftransaction>	<!--- all or nothing as far as converting the database goes --->
		<cfloop query="getRecords">
			<cfset salt = generateSecretKey(session.saltalgorithm, session.saltkeySize)>
			<cfquery name="updateRecord" datasource="#session.dsn#" username="#session.username#" password="#session.password#">
				UPDATE #application.tableprefix#tblUsers
				SET password = <cfqueryparam value="#hash(salt & getRecords.password, session.hashAlgorithm)#" cfsqltype="cf_sql_varchar" maxlength="256">,
				    salt = <cfqueryparam value="#salt#" cfsqltype="cf_sql_varchar" maxlength="256">
				WHERE 	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getRecords.username#" maxlength="50">
				and		blog = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getRecords.blog#" maxlength="50">
			</cfquery> 
		</cfloop>
		</cftransaction>
		<cfcatch type="any">
		<cfset proceed = false>
		<p>
		There was a problem converting the existing passwords in your user table.  Here are the details:
		<cfdump var="#cfcatch#">
		</p>	
		</cfcatch>
		</cftry>
	
		<cfif proceed>
			<!--- Update each section of the ini file for one or more blogs --->
			<cfloop list="#application.blogNames#" index="i">
				<cfset setProfileString(application.iniFile, i, "saltAlgorithm", session.saltAlgorithm)>
				<cfset setProfileString(application.iniFile, i, "saltKeySize", session.saltKeySize)>
				<cfset setProfileString(application.iniFile, i, "hashAlgorithm", session.hashAlgorithm)>
			</cfloop>
			<p>
			That's it, we're done! Your user table should now be converted for use with blogCFC 5.9.8.001.  
			You may need to clear your blog cache before the new settings take effect.
			</p> 
		</cfif>
		</cfpod>
	</cfcase>
</cfswitch>
