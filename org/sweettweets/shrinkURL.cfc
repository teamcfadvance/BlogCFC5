<!---
	Name: shrinkURL
	Author: Andy Matthews
	Website: http://www.andyMatthews.net || http://shrinkurl.riaforge.org
	Created: 1/16/2009
	Last Updated: 1/16/2009
	History:
			1/16/2009 - Initial creation
			1/25/2009 - Added support for Cligs, added error trapping on shrinkSnurl method, added better regex for validating URLs
							All thanks to Adam Tuttle over at FusionGrokker (http://fusiongrokker.com/)
	Purpose: Quick access to short url creation via various open APIs
	Version: 0.3

	TODO:
		+ add additional services
			zi.ma (http://zi.ma/api)
		+ get rid of specific app methods in favor of a generic method
			possibly use the services "definition" variable to auto generate
			methods at run time?
--->
<cfcomponent hint="CFC allowing users to create short URLS via various URL shortening services" displayname="shrinkURL">

	<cfscript>
		VARIABLES.services = structNew();
		VARIABLES.services['Snurl'] = structNew();
		VARIABLES.services['Snurl'].method = 'POST';
		VARIABLES.services['Snurl'].url = 'http://snipurl.com/site/getsnip';
		VARIABLES.services['Snurl'].docs = 'http://www.snurl.com/site/help?go=api';
		VARIABLES.services['Snurl'].parameters = structNew();
		VARIABLES.services['Snurl'].parameters['snipapi'] = '<apikey>';
		VARIABLES.services['Snurl'].parameters['snipuser'] = '<username>';

		VARIABLES.services['IsGD'] = structNew();
		VARIABLES.services['IsGD'].method = 'GET';
		VARIABLES.services['IsGD'].url = 'http://is.gd/api.php';
		VARIABLES.services['IsGD'].docs = 'http://is.gd/api_info.php';
		VARIABLES.services['IsGD'].parameters = structNew();
		VARIABLES.services['IsGD'].parameters['longurl'] = '<url>';

		VARIABLES.services['TinyURL'] = structNew();
		VARIABLES.services['TinyURL'].method = 'GET';
		VARIABLES.services['TinyURL'].url = 'http://tinyurl.com/api-create.php';
		VARIABLES.services['TinyURL'].docs = 'http://www.scripting.com/stories/2007/06/27/tinyurlHasAnApi.html';
		VARIABLES.services['TinyURL'].parameters = structNew();
		VARIABLES.services['TinyURL'].parameters['url'] = '<url>';

		VARIABLES.services['BitLy'] = structNew();
		VARIABLES.services['BitLy'].method = 'GET';
		VARIABLES.services['BitLy'].url = 'http://api.bit.ly/shorten';
		VARIABLES.services['BitLy'].docs = 'http://code.google.com/p/bitly-api/wiki/ApiDocumentation';
		VARIABLES.services['BitLy'].parameters = structNew();
		VARIABLES.services['BitLy'].parameters['login'] = '<login>';
		VARIABLES.services['BitLy'].parameters['apiKey'] = '<apiKey>';
		VARIABLES.services['BitLy'].parameters['longUrl'] = '<url>';
		VARIABLES.services['BitLy'].parameters['version'] = '2.0.1';
		VARIABLES.services['BitLy'].parameters['format'] = 'xml';

		VARIABLES.services['Twurl'] = structNew();
		VARIABLES.services['Twurl'].method = 'POST';
		VARIABLES.services['Twurl'].url = 'http://tweetburner.com/links';
		VARIABLES.services['Twurl'].docs = 'http://tweetburner.com/api';
		VARIABLES.services['Twurl'].parameters = structNew();
		VARIABLES.services['Twurl'].parameters['link[url]'] = '<url>';

		VARIABLES.services['Hexio'] = structNew();
		VARIABLES.services['Hexio'].method = 'GET';
		VARIABLES.services['Hexio'].url = 'http://hex.io/api-create.php';
		VARIABLES.services['Hexio'].docs = 'http://hex.io/';
		VARIABLES.services['Hexio'].parameters = structNew();
		VARIABLES.services['Hexio'].parameters['url'] = '<url>';

		VARIABLES.services['POPrl'] = structNew();
		VARIABLES.services['POPrl'].method = 'POST';
		VARIABLES.services['POPrl'].url = 'http://poprl.com/api/post';
		VARIABLES.services['POPrl'].docs = 'http://poprl.com/api_ref';
		VARIABLES.services['POPrl'].parameters = structNew();
		VARIABLES.services['POPrl'].parameters['url'] = '<url>';

		//ajat 2009-01-24 -- added for cligs support
		VARIABLES.services['Cligs'] = structNew();
		VARIABLES.services['Cligs'].method = 'GET';
		VARIABLES.services['Cligs'].url = 'http://cli.gs/api/v1/cligs/create';
		VARIABLES.services['Cligs'].docs = 'http://blog.cli.gs/api';
		VARIABLES.services['Cligs'].parameters = structNew();
		VARIABLES.services['Cligs'].parameters['url'] = '<url>';
		VARIABLES.services['Cligs'].parameters['appid'] = 'shrinkURL';
	</cfscript>

	<cffunction name="init" returntype="shrinkURL" hint="Initializes shrinkURL" access="public">
		<cfreturn THIS>
	</cffunction>

	<cffunction name="listServices" returntype="struct" hint="Returns a list of services offered by shrinkURL" access="public">
		<cfreturn VARIABLES.services>
	</cffunction>

	<cffunction name="verifyURL" returntype="boolean" hint="Validates a URL" access="private">
		<cfargument name="url" type="string" required="true">
		<cfset var regex = '^(ht|f)tp(s?)://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$'>
		<cfset testURL = reFindNoCaseAll(regex, ARGUMENTS.url)>
		<cfreturn ArrayLen(testURL.len)>
	</cffunction>

	<cffunction name="shrink" returntype="string" output="false" access="remote">
		<cfargument name="service" type="string" required="true">
		<cfargument name="url" type="string" required="true">
		<cfargument name="parameters" required="false" type="struct" default="#StructNew()#" hint="Additional packet of information required by each individual service">

		<!--- parameterize the url string variable --->
		<cfset var newURL = ''>

		<!--- does this URL pass validation? --->
		<cfif NOT verifyURL(ARGUMENTS.url)>
			<!--- it doesn't, to let's provide a message --->
			<cfset newURL = 'URL appears to be invalid, please try again.'>

		<cfelse>

			<!--- determine which service the user wants to use --->
			<cfswitch expression="#ARGUMENTS.service#">
				<cfcase value="Snurl">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')
						AND (StructKeyExists(ARGUMENTS.parameters,'snipuser') AND ARGUMENTS.parameters.snipuser NEQ '')
						AND (StructKeyExists(ARGUMENTS.parameters,'snipapi') AND  ARGUMENTS.parameters.snipapi NEQ '')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'sniplink',ARGUMENTS.url)>
						<!--- shrink the URL --->
						<cfset newURL = snurlShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'Parameters missing, likely username or password.'>
					</cfif>
				</cfcase>
				<cfcase value="isGD">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'longurl',ARGUMENTS.url)>
						<!--- shrink the URL --->
						<cfset newURL = isGDShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'An unknown error occurred'>
					</cfif>
				</cfcase>
				<cfcase value="TinyURL">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'url',ARGUMENTS.url)>
						<!--- shrink the URL --->
						<cfset newURL = tuShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'An unknown error occurred'>
					</cfif>
				</cfcase>
				<cfcase value="BitLy">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')
						AND (StructKeyExists(ARGUMENTS.parameters,'login') AND ARGUMENTS.parameters.login NEQ '')
						AND (StructKeyExists(ARGUMENTS.parameters,'apiKey') AND ARGUMENTS.parameters.apiKey NEQ '')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'longUrl',ARGUMENTS.url)>
						<cfset StructInsert(ARGUMENTS.parameters,'version',VARIABLES.services['BitLy'].parameters['version'])>
						<cfset StructInsert(ARGUMENTS.parameters,'format',VARIABLES.services['BitLy'].parameters['format'])>
						<!--- shrink the URL --->
						<cfset newURL = bitlyShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'Parameters missing, likely username or password.'>
					</cfif>
				</cfcase>
				<cfcase value="Twurl">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'link[url]',ARGUMENTS.url)>
						<!--- shrink the URL --->
						<cfset newURL = twurlShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'An unknown error occurred'>
					</cfif>
				</cfcase>
				<cfcase value="Hexio">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'url',ARGUMENTS.url)>
						<!--- shrink the URL --->
						<cfset newURL = hexioShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'An unknown error occurred'>
					</cfif>
				</cfcase>
				<cfcase value="POPrl">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'url',ARGUMENTS.url)>
						<!--- shrink the URL --->
						<cfset newURL = poprlShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'An unknown error occurred'>
					</cfif>
				</cfcase>
				<cfcase value="Cligs">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'url',ARGUMENTS.url)>
						<!--- replace missing appid with shrinkUrl --->
						<cfif not structKeyExists(ARGUMENTS.parameters,'appid')>
							<cfset ARGUMENTS.parameters.appid = VARIABLES.services['Cligs'].parameters['appid']>
						</cfif>
						<!--- shrink the URL --->
						<cfset newURL = cligsShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'An unknown error occurred'>
					</cfif>
				</cfcase>
				<cfcase value="Zima">
					<!--- make sure that the parameters struct exists, and has the keys we need. --->
					<cfif StructKeyExists(ARGUMENTS,'parameters')>
						<!--- add the URL into the parameters structure --->
						<cfset StructInsert(ARGUMENTS.parameters,'url',ARGUMENTS.url)>
						<cfset StructInsert(ARGUMENTS.parameters,'file','Add')>
						<cfset StructInsert(ARGUMENTS.parameters,'module','ShortURL')>
						<!--- shrink the URL --->
						<cfset newURL = zimaShrink(ARGUMENTS.parameters)>
					<cfelse>
						<!--- return an error if the user doesn't prove the username and API key --->
						<cfset newURL = 'An unknown error occurred'>
					</cfif>
				</cfcase>
			</cfswitch>
		</cfif>

		<cfreturn newURL>
	</cffunction>

	<cffunction name="callAPI" returntype="string" output="false" access="private">
		<cfargument name="url" type="string" required="true">
		<cfargument name="method" type="string" required="true">
		<cfargument name="parameters" required="no" type="struct" default="#StructNew()#" hint="Name / value pairs of data to be sent to service">

		<cfset var cfhttp = ''>
		<cfset var name = ''>

		<!--- jat 2009-02-03 -- in Railo, <CFHTTPPARAM type=FormField> isn't valid for GET requests --->
		<cfif lcase(arguments.method) eq "get">
			<cfloop collection="#arguments.parameters#" item="name">
				<cfif not findNoCase("?",arguments.url)>
					<cfset arguments.url = arguments.url & "?#name#=#urlEncodedFormat(arguments.parameters[name])#"/>
				<cfelse>
					<cfset arguments.url = arguments.url & "&#name#=#urlEncodedFormat(arguments.parameters[name])#"/>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfhttp url="#ARGUMENTS.url#" method="#ARGUMENTS.method#" timeout="20">
			<cfif lcase(arguments.method) neq "get">
				<cfloop collection="#ARGUMENTS.parameters#" item="name">
					<cfhttpparam name="#name#" type="formfield" value="#ARGUMENTS.parameters[name]#">
				</cfloop>
			</cfif>
		</cfhttp>

		<cfreturn cfhttp.filecontent>
	</cffunction>

	<cffunction name="snurlShrink" returntype="string" hint="shrinks a URL using the snurl service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['Snurl'].url>
		<cfset var xmlReturn = ''>
		<cftry>
			<cfset xmlReturn = XMLParse(callAPI(accessURL,VARIABLES.services['Snurl'].method,ARGUMENTS.parameters))>

			<cfif StructKeyExists(xmlReturn,'snip')>
				<cfreturn xmlReturn.snip.id.xmltext>
			<cfelse>
				<cfreturn 'An error occurred. Most likely due to an invalid or incomplete URL. Please try again.'>
			</cfif>
			<cfcatch>
				<cfreturn 'An error occurred. Most likely due to incorrect username or password.'/>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="isGDShrink" returntype="string" hint="shrinks a URL using the Is.gd service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['IsGD'].url>
		<cfset var xmlReturn = callAPI(accessURL,VARIABLES.services['IsGD'].method,ARGUMENTS.parameters)>

		<!--- if the URL was invalid, return an error --->
		<cfif FindNoCase('Error',xmlReturn)>
			<cfreturn 'An error occurred. Most likely due to an invalid or incomplete URL. Please try again.'>
		<cfelse>
			<cfreturn xmlReturn>
		</cfif>
	</cffunction>

	<cffunction name="tuShrink" returntype="string" hint="shrinks a URL using the TinyURL service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['TinyURL'].url>
		<cfset var xmlReturn = callAPI(accessURL,VARIABLES.services['TinyURL'].method,ARGUMENTS.parameters)>

		<!--- if the URL was invalid, return an error --->
		<cfif FindNoCase('Error',xmlReturn)>
			<cfreturn 'An error occurred. Most likely due to an invalid or incomplete URL. Please try again.'>
		<cfelse>
			<cfreturn xmlReturn>
		</cfif>
	</cffunction>

	<cffunction name="bitlyShrink" returntype="string" hint="shrinks a URL using the Bit.ly service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['BitLy'].url>
		<cfset var xmlReturn = ''>
		<cftry>
			<cfset xmlReturn = XMLParse(callAPI(accessURL,VARIABLES.services['BitLy'].method,ARGUMENTS.parameters))>

			<!--- if the URL was invalid, return an error --->
			<cfif StructKeyExists(xmlReturn.bitly.results.nodeKeyVal.shortUrl,'xmlText')>
				<cfreturn xmlReturn.bitly.results.nodeKeyVal.shortUrl.xmlText>
			<cfelse>
				<cfreturn 'An error occurred. Most likely due to an invalid or incomplete URL. Please try again.'>
			</cfif>
			<cfcatch>
				<cfreturn 'An error occurred. Most likely due incorrect username or password.'>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="twurlShrink" returntype="string" hint="shrinks a URL using the Twurl service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['Twurl'].url>
		<cfset var xmlReturn = callAPI(accessURL,VARIABLES.services['Twurl'].method,ARGUMENTS.parameters)>

		<cfreturn xmlReturn>
	</cffunction>

	<cffunction name="hexioShrink" returntype="string" hint="shrinks a URL using the Hexio service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['Hexio'].url>
		<cfset var xmlReturn = callAPI(accessURL,VARIABLES.services['Hexio'].method,ARGUMENTS.parameters)>

		<cfreturn xmlReturn>
	</cffunction>

	<cffunction name="poprlShrink" returntype="string" hint="shrinks a URL using the POPrl service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['POPrl'].url>
		<cfset var xmlReturn = callAPI(accessURL,VARIABLES.services['POPrl'].method,ARGUMENTS.parameters)>

		<cfreturn xmlReturn>
	</cffunction>

	<!--- jat 2009-01-24 -- added cligsShrink function for cligs compatability --->
	<cffunction name="cligsShrink" returntype="string" hint="shrinks a URL using the Cligs service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['Cligs'].url>
		<cfset var xmlReturn = callAPI(accessURL,VARIABLES.services['Cligs'].method,ARGUMENTS.parameters)>

		<cfreturn xmlReturn>
	</cffunction>

	<cffunction name="zimaShrink" returntype="string" hint="shrinks a URL using the Zi.ma service" access="private">
		<cfargument name="parameters" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var accessURL = VARIABLES.services['Zima'].url>
		<!--- <cfset var xmlReturn = callAPI(accessURL,VARIABLES.services['Zima'].method,ARGUMENTS.parameters)> --->

		<cfdump var="#VARIABLES.services['Zima']#">
		<cfdump var="#ARGUMENTS.parameters#">
		<cfabort>

		<cfreturn xmlReturn>
	</cffunction>

	<!---
	http://cflib.org/udf/reFindNoCaseAll
	Returns all the matches (case insensitive) of a regular expression within a string. This is simular to reGet(),
	but more closely matches the result set of reFind.

	@param regex      Regular expression. (Required)
	@param text      String to search. (Required)
	@return Returns an array.
	@author Ben Forta (ben@forta.com)
	@version 1, November 17, 2003
	--->
	<cffunction name="reFindNoCaseAll" output="true" returntype="struct">
		<cfargument name="regex" type="string" required="yes">
		<cfargument name="text" type="string" required="yes">
		<!--- Define local variables --->
		<cfset var results=structNew()>
		<cfset var pos=1>
		<cfset var subex="">
		<cfset var done=false>
		<!--- Initialize results structure --->
		<cfset results.len=arraynew(1)>
		<cfset results.pos=arraynew(1)>
		<!--- Loop through text --->
		<cfloop condition="not done">
			<!--- Perform search --->
			<cfset subex=reFindNoCase(arguments.regex, arguments.text, pos, true)>
			<!--- Anything matched? --->
			<cfif subex.len[1] is 0>
				<!--- Nothing found, outta here --->
				<cfset done=true>
			<cfelse>
				<!--- Got one, add to arrays --->
				<cfset arrayappend(results.len, subex.len[1])>
				<cfset arrayappend(results.pos, subex.pos[1])>
				<!--- Reposition start point --->
				<cfset pos=subex.pos[1]+subex.len[1]>
			</cfif>
		</cfloop>
		<!--- If no matches, add 0 to both arrays --->
		<cfif arraylen(results.len) is 0>
			<cfset arrayappend(results.len, 0)>
			<cfset arrayappend(results.pos, 0)>
		</cfif>
		<!--- and return results --->
		<cfreturn results>
	</cffunction>
</cfcomponent>