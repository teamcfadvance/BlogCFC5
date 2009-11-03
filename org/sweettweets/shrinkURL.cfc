<!---
	Name: shrinkURL
	Author: Andy Matthews
	Website: http://www.andyMatthews.net || http://shrinkurl.riaforge.org
	Created: 1/16/2009
	Last Updated: 2/26/2009
	History:
			1/16/2009 - Initial creation
			1/25/2009 - Added support for Cligs, added error trapping on shrinkSnurl method, added better regex for validating URLs
							All thanks to Adam Tuttle over at FusionGrokker (http://fusiongrokker.com/)
			02/03/2009 - shrinkURL now works with Railo, courtesy of Adam Tuttle.
			2/10/2009 - Removed service specific methods. Now building callAPI based on service definition in VARIABLES scope
			2/12/2009 - Added method to return current version
			2/13/2009 - Added URLZen support
			2/15/2009 - Added ShortIE support
			2/25/2009 - Added Short.to, W3t, EasyURL, BudURL, Tr.im
			3/1/2009 - Rewrote internal service storage mechanisms. Allows finer grain control over fields submitted into app
			3/21/2009 - Added 10 new services: Adjix, Lincr, PiURL, Trakz, Idek, PeaURL, ChilpIt, PntMe, MooURL and HREFin
	Purpose: Quick access to short url creation via various open APIs
	Version: Listed in contructor

	TODO:
		+ add additional services
			API
			-----------
			http://notlong.com/
			http://jijr.com/
			http://smallr.com/
			http://rubyurl.com/home

			NO API
			------------
			http://ow.ly/url/shorten-url
			http://moourl.com/
			http://bloat.me/
			http://bacn.me/
			http://dwarfurl.com/

--->
<cfcomponent hint="CFC allowing users to create short URLS via various URL shortening services" displayname="shrinkURL" output="false">

	<cfscript>
		VARIABLES.version = '0.5.5';

		VARIABLES.services = StructNew();

		//gives unique urls to every user
		VARIABLES.services['BitLy'] = StructNew();
		VARIABLES.services['BitLy']['method'] = 'GET';
		VARIABLES.services['BitLy']['url'] = 'http://api.bit.ly/shorten';
		VARIABLES.services['BitLy']['docs'] = 'http://code.google.com/p/bitly-api/wiki/ApiDocumentation';
		VARIABLES.services['BitLy']['parameters'] = ArrayNew(1);
		VARIABLES.services['BitLy']['parameters'][1] = createStruct(field='longUrl',label='URL',value='');
		VARIABLES.services['BitLy']['parameters'][2] = createStruct(field='login',label='Login',value='');
		VARIABLES.services['BitLy']['parameters'][3] = createStruct(field='apiKey',label='apiKey',value='');
		VARIABLES.services['BitLy']['parameters'][4] = createStruct(field='version',label='version',value='2.0.1');
		VARIABLES.services['BitLy']['parameters'][5] = createStruct(field='format',label='format',value='text');

		VARIABLES.services['IsGD'] = StructNew();
		VARIABLES.services['IsGD']['method'] = 'GET';
		VARIABLES.services['IsGD']['url'] = 'http://is.gd/api.php';
		VARIABLES.services['IsGD']['docs'] = 'http://is.gd/api_info.php';
		VARIABLES.services['IsGD']['parameters'] = ArrayNew(1);
		VARIABLES.services['IsGD']['parameters'][1] = createStruct(field='longurl',label='URL',value='');

		//gives unique urls to every user
		VARIABLES.services['Twurl'] = StructNew();
		VARIABLES.services['Twurl']['method'] = 'POST';
		VARIABLES.services['Twurl']['url'] = 'http://tweetburner.com/links';
		VARIABLES.services['Twurl']['docs'] = 'http://tweetburner.com/api';
		VARIABLES.services['Twurl']['parameters'] = ArrayNew(1);
		VARIABLES.services['Twurl']['parameters'][1] = createStruct(field='link[url]',label='URL',value='');

		VARIABLES.services['Cligs'] = StructNew();
		VARIABLES.services['Cligs']['method'] = 'GET';
		VARIABLES.services['Cligs']['url'] = 'http://cli.gs/api/v1/cligs/create';
		VARIABLES.services['Cligs']['docs'] = 'http://blog.cli.gs/api';
		VARIABLES.services['Cligs']['parameters'] = ArrayNew(1);
		VARIABLES.services['Cligs']['parameters'][1] = createStruct(field='url',label='URL',value='');
		VARIABLES.services['Cligs']['parameters'][2] = createStruct(field='appid',label='appid',value='shrinkURL (http://shrinkurl.riaforge.org/)');

		VARIABLES.services['TinyURL'] = StructNew();
		VARIABLES.services['TinyURL']['method'] = 'GET';
		VARIABLES.services['TinyURL']['url'] = 'http://tinyurl.com/api-create.php';
		VARIABLES.services['TinyURL']['docs'] = 'http://www.scripting.com/stories/2007/06/27/tinyurlHasAnApi.html';
		VARIABLES.services['TinyURL']['parameters'] = ArrayNew(1);
		VARIABLES.services['TinyURL']['parameters'][1] = createStruct(field='url',label='URL',value='');

		VARIABLES.services['Hexio'] = StructNew();
		VARIABLES.services['Hexio']['method'] = 'GET';
		VARIABLES.services['Hexio']['url'] = 'http://hex.io/api-create.php';
		VARIABLES.services['Hexio']['docs'] = 'http://hex.io/';
		VARIABLES.services['Hexio']['parameters'] = ArrayNew(1);
		VARIABLES.services['Hexio']['parameters'][1] = createStruct(field='url',label='URL',value='');

		//gives unique urls to every user
		VARIABLES.services['POPrl'] = StructNew();
		VARIABLES.services['POPrl']['method'] = 'POST';
		VARIABLES.services['POPrl']['url'] = 'http://poprl.com/api/post';
		VARIABLES.services['POPrl']['docs'] = 'http://poprl.com/api_ref';
		VARIABLES.services['POPrl']['parameters'] = ArrayNew(1);
		VARIABLES.services['POPrl']['parameters'][1] = createStruct(field='url',label='URL',value='');

		VARIABLES.services['URLZen'] = StructNew();
		VARIABLES.services['URLZen']['method'] = 'GET';
		VARIABLES.services['URLZen']['url'] = 'http://urlzen.com/api';
		VARIABLES.services['URLZen']['docs'] = 'http://urlzen.com/';
		VARIABLES.services['URLZen']['parameters'] = ArrayNew(1);
		VARIABLES.services['URLZen']['parameters'][1] = createStruct(field='url',label='URL',value='');

		VARIABLES.services['Zima'] = StructNew();
		VARIABLES.services['Zima']['method'] = 'GET';
		VARIABLES.services['Zima']['url'] = 'http://zi.ma/';
		VARIABLES.services['Zima']['docs'] = 'http://zi.ma/api';
		VARIABLES.services['Zima']['parameters'] = ArrayNew(1);
		VARIABLES.services['Zima']['parameters'][1] = createStruct(field='url',label='URL',value='');
		VARIABLES.services['Zima']['parameters'][2] = createStruct(field='module',label='module',value='ShortURL');
		VARIABLES.services['Zima']['parameters'][3] = createStruct(field='file',label='file',value='Add');
		VARIABLES.services['Zima']['parameters'][4] = createStruct(field='mode',label='mode',value='API');

		VARIABLES.services['ShortTo'] = StructNew();
		VARIABLES.services['ShortTo']['method'] = 'GET';
		VARIABLES.services['ShortTo']['url'] = 'http://short.to/s.txt';
		VARIABLES.services['ShortTo']['docs'] = 'http://short.to/api.do';
		VARIABLES.services['ShortTo']['parameters'] = ArrayNew(1);
		VARIABLES.services['ShortTo']['parameters'][1] = createStruct(field='url',label='URL',value='');

		VARIABLES.services['BudURL'] = StructNew();
		VARIABLES.services['BudURL']['method'] = 'POST';
		VARIABLES.services['BudURL']['url'] = 'http://budurl.com/?create-url';
		VARIABLES.services['BudURL']['docs'] = 'http://budurl.com';
		VARIABLES.services['BudURL']['parameters'] = ArrayNew(1);
		VARIABLES.services['BudURL']['parameters'][1] = createStruct(field='myurl',label='URL',value='');

		//gives unique urls to every user
		VARIABLES.services['Trim'] = StructNew();
		VARIABLES.services['Trim']['method'] = 'GET';
		VARIABLES.services['Trim']['url'] = 'http://tr.im/api/trim_simple';
		VARIABLES.services['Trim']['docs'] = 'http://tr.im/api';
		VARIABLES.services['Trim']['parameters'] = ArrayNew(1);
		VARIABLES.services['Trim']['parameters'][1] = createStruct(field='url',label='URL',value='');

		//gives unique urls to every user
		VARIABLES.services['Snurl'] = StructNew();
		VARIABLES.services['Snurl']['method'] = 'POST';
		VARIABLES.services['Snurl']['url'] = 'http://snipurl.com/site/getsnip';
		VARIABLES.services['Snurl']['docs'] = 'http://www.snurl.com/site/help?go=api';
		VARIABLES.services['Snurl']['parameters'] = ArrayNew(1);
		VARIABLES.services['Snurl']['parameters'][1] = createStruct(field='sniplink',label='URL',value='');
		VARIABLES.services['Snurl']['parameters'][2] = createStruct(field='snipuser',label='username',value='');
		VARIABLES.services['Snurl']['parameters'][3] = createStruct(field='snipapi',label='apikey',value='');

		//gives unique urls to every user
		VARIABLES.services['ShortIE'] = StructNew();
		VARIABLES.services['ShortIE']['method'] = 'GET';
		VARIABLES.services['ShortIE']['url'] = 'http://short.ie/api';
		VARIABLES.services['ShortIE']['docs'] = 'http://short.ie/';
		VARIABLES.services['ShortIE']['parameters'] = ArrayNew(1);
		VARIABLES.services['ShortIE']['parameters'][1] = createStruct(field='url',label='URL',value='');
		VARIABLES.services['ShortIE']['parameters'][2] = createStruct(field='format',label='format',value='text');
		VARIABLES.services['ShortIE']['parameters'][3] = createStruct(field='private',label='private',value="false");

		VARIABLES.services['W3t'] = StructNew();
		VARIABLES.services['W3t']['method'] = 'GET';
		VARIABLES.services['W3t']['url'] = 'http://www.w3t.org/';
		VARIABLES.services['W3t']['docs'] = 'http://www.w3t.org/_shortURL/?module=Pages&id=27';
		VARIABLES.services['W3t']['parameters'] = ArrayNew(1);
		VARIABLES.services['W3t']['parameters'][1] = createStruct(field='url',label='URL',value='');
		VARIABLES.services['W3t']['parameters'][2] = createStruct(field='module',label='module',value='ShortURL');
		VARIABLES.services['W3t']['parameters'][3] = createStruct(field='mode',label='mode',value='API');
		VARIABLES.services['W3t']['parameters'][4] = createStruct(field='file',label='file',value='Add');

		VARIABLES.services['EasyURL'] = StructNew();
		VARIABLES.services['EasyURL']['method'] = 'POST';
		VARIABLES.services['EasyURL']['url'] = 'http://www.easyurl.net/index.php';
		VARIABLES.services['EasyURL']['docs'] = 'http://www.easyurl.net/index.php';
		VARIABLES.services['EasyURL']['parameters'] = ArrayNew(1);
		VARIABLES.services['EasyURL']['parameters'][1] = createStruct(field='longurl',label='URL',value='');
		VARIABLES.services['EasyURL']['parameters'][2] = createStruct(field='mode',label='mode',value='shorten');
		VARIABLES.services['EasyURL']['parameters'][3] = createStruct(field='domain',label='domain',value='atu.ca');

		VARIABLES.services['Adjix'] = StructNew();
		VARIABLES.services['Adjix']['method'] = 'GET';
		VARIABLES.services['Adjix']['url'] = 'http://api.adjix.com/shrinkLink';
		VARIABLES.services['Adjix']['docs'] = 'http://web.adjix.com/AdjixAPI.html';
		VARIABLES.services['Adjix']['parameters'] = ArrayNew(1);
		VARIABLES.services['Adjix']['parameters'][1] = createStruct(field='url',label='URL',value='');
		VARIABLES.services['Adjix']['parameters'][2] = createStruct(field='ultraShort',label='ultraShort',value='y');
		VARIABLES.services['Adjix']['parameters'][3] = createStruct(field='partnerID',label='PartnerID',value='');

		VARIABLES.services['Lincr'] = StructNew();
		VARIABLES.services['Lincr']['method'] = 'GET';
		VARIABLES.services['Lincr']['url'] = 'http://lin.cr';
		VARIABLES.services['Lincr']['docs'] = 'http://lin.cr/';
		VARIABLES.services['Lincr']['parameters'] = ArrayNew(1);
		VARIABLES.services['Lincr']['parameters'][1] = createStruct(field='l',label='URL',value='');
		VARIABLES.services['Lincr']['parameters'][2] = createStruct(field='mode',label='mode',value='api');
		VARIABLES.services['Lincr']['parameters'][3] = createStruct(field='full',label='full',value='1');

		VARIABLES.services['HREFin'] = StructNew();
		VARIABLES.services['HREFin']['method'] = 'GET';
		VARIABLES.services['HREFin']['url'] = 'http://href.in/api.php';
		VARIABLES.services['HREFin']['docs'] = 'http://href.in/api_example.php';
		VARIABLES.services['HREFin']['parameters'] = ArrayNew(1);
		VARIABLES.services['HREFin']['parameters'][1] = createStruct(field='create',label='URL',value='');

		VARIABLES.services['PiURL'] = StructNew();
		VARIABLES.services['PiURL']['method'] = 'POST';
		VARIABLES.services['PiURL']['url'] = 'http://piurl.com/api.php';
		VARIABLES.services['PiURL']['docs'] = 'http://piurl.com/api.php';
		VARIABLES.services['PiURL']['parameters'] = ArrayNew(1);
		VARIABLES.services['PiURL']['parameters'][1] = createStruct(field='url',label='URL',value='');

		VARIABLES.services['Trakz'] = StructNew();
		VARIABLES.services['Trakz']['method'] = 'GET';
		VARIABLES.services['Trakz']['url'] = 'http://tra.kz/api/shorten';
		VARIABLES.services['Trakz']['docs'] = 'http://code.google.com/p/trakz-api/wiki/API_Documentation';
		VARIABLES.services['Trakz']['parameters'] = ArrayNew(1);
		VARIABLES.services['Trakz']['parameters'][1] = createStruct(field='l',label='URL',value='');
		VARIABLES.services['Trakz']['parameters'][2] = createStruct(field='api',label='Key',value='shrinkurl');
		VARIABLES.services['Trakz']['parameters'][3] = createStruct(field='version',label='version',value='1.0');
		VARIABLES.services['Trakz']['parameters'][4] = createStruct(field='format',label='format',value='json');

		VARIABLES.services['Idek'] = StructNew();
		VARIABLES.services['Idek']['method'] = 'GET';
		VARIABLES.services['Idek']['url'] = 'http://idek.net/c.php';
		VARIABLES.services['Idek']['docs'] = 'http://idek.net/url-shortening-api.php';
		VARIABLES.services['Idek']['parameters'] = ArrayNew(1);
		VARIABLES.services['Idek']['parameters'][1] = createStruct(field='idek-url',label='URL',value='');
		VARIABLES.services['Idek']['parameters'][2] = createStruct(field='idek-api',label='idek-api',value='true');
		VARIABLES.services['Idek']['parameters'][3] = createStruct(field='idek-ref',label='idek-ref',value='Shrinkadoo');

		VARIABLES.services['PeaURL'] = StructNew();
		VARIABLES.services['PeaURL']['method'] = 'GET';
		VARIABLES.services['PeaURL']['url'] = 'http://peaurl.com/api';
		VARIABLES.services['PeaURL']['docs'] = 'http://peaurl.com/api/documentation';
		VARIABLES.services['PeaURL']['parameters'] = ArrayNew(1);
		VARIABLES.services['PeaURL']['parameters'][1] = createStruct(field='link',label='URL',value='');
		VARIABLES.services['PeaURL']['parameters'][2] = createStruct(field='type',label='type',value='json');
		VARIABLES.services['PeaURL']['parameters'][3] = createStruct(field='friendly',label='friendly',value='true');

		VARIABLES.services['ChilpIt'] = StructNew();
		VARIABLES.services['ChilpIt']['method'] = 'POST';
		VARIABLES.services['ChilpIt']['url'] = 'http://chilp.it/api.php';
		VARIABLES.services['ChilpIt']['docs'] = 'http://chilp.it/';
		VARIABLES.services['ChilpIt']['parameters'] = ArrayNew(1);
		VARIABLES.services['ChilpIt']['parameters'][1] = createStruct(field='url',label='URL',value='');

		VARIABLES.services['PntMe'] = StructNew();
		VARIABLES.services['PntMe']['method'] = 'POST';
		VARIABLES.services['PntMe']['url'] = 'http://pnt.me/links';
		VARIABLES.services['PntMe']['docs'] = 'http://pnt.me/links';
		VARIABLES.services['PntMe']['parameters'] = ArrayNew(1);
		VARIABLES.services['PntMe']['parameters'][1] = createStruct(field='link[destination]',label='URL',value='');

		VARIABLES.services['MooURL'] = StructNew();
		VARIABLES.services['MooURL']['method'] = 'GET';
		VARIABLES.services['MooURL']['url'] = 'http://moourl.com/create/';
		VARIABLES.services['MooURL']['docs'] = 'http://moourl.com/create/';
		VARIABLES.services['MooURL']['parameters'] = ArrayNew(1);
		VARIABLES.services['MooURL']['parameters'][1] = createStruct(field='source',label='URL',value='');

		/*

		VARIABLES.services['RubyURL'] = StructNew();
		VARIABLES.services['RubyURL']['method'] = 'POST';
		VARIABLES.services['RubyURL']['url'] = 'http://rubyurl.com/api/link';
		VARIABLES.services['RubyURL']['docs'] = 'http://rubyurl.com/api';
		VARIABLES.services['RubyURL']['parameters'] = ArrayNew(1);
		VARIABLES.services['RubyURL']['parameters'][1] = createStruct(field='website_url',label='URL',value='');

		VARIABLES.services['Smallr'] = StructNew();
		VARIABLES.services['Smallr']['method'] = 'POST';
		VARIABLES.services['Smallr']['url'] = 'http://smallr.com/url/shorten/';
		VARIABLES.services['Smallr']['docs'] = 'http://smallr.com/api';
		VARIABLES.services['Smallr']['parameters'] = ArrayNew(1);
		VARIABLES.services['Smallr']['parameters'][1] = createStruct(field='long_url',label='URL',value='');
		*/

	</cfscript>

	<cffunction name="init" description="Initializes the CFC, returns itself" displayname="init" returntype="shrinkURL" hint="Initializes shrinkURL" access="public" output="false">
		<cfreturn THIS>
	</cffunction>

	<cffunction name="getAllServices" description="Returns a structure containing the information for all available services" displayname="getAllServices" returntype="struct" hint="Returns a list of services offered by shrinkURL" access="remote" output="false">
		<cfreturn VARIABLES.services>
	</cffunction>

	<cffunction name="listServices" description="Returns an array containing just the names of all available services" displayname="listServices" returntype="array" hint="Returns the names of all services offered by shrinkURL" access="remote" output="false">
		<cfset var svcArr = ArrayNew(1)>
		<!--- loop over the services structure --->
		<cfloop collection="#VARIABLES.services#" item="key">
			<!--- insert each key as an index --->
			<cfset ArrayAppend(svcArr,key)>
		</cfloop>
		<!--- sort the array separately --->
		<cfset ArraySort(svcArr,'textnocase')>
		<cfreturn svcArr>
	</cffunction>

	<cffunction name="currentVersion" description="Returns current version of shrinkURL" displayname="currentVersion" returntype="string" hint="Reports current version" access="public" output="false">
		<cfreturn VARIABLES.version>
	</cffunction>

	<cffunction name="getService" description="Returns the parameters for a single service" displayname="getService" returntype="array" hint="Gets service parameters" access="remote" output="false">
		<cfargument name="service" type="string" required="true">
		<cfreturn VARIABLES.services[ARGUMENTS.service]['parameters']>
	</cffunction>

	<cffunction name="shrinkByURLString" description="Shrinks URL based off key/value pairs rather than complex objects" displayname="shrinkByURLString" returntype="string" hint="Allows user to shrink string by passing in key/value pairs in string format" access="remote" output="false">
		<cfargument name="parameters" required="true" type="string" hint="Packet of information required by each individual service">
		<cfset var pairs = ''>
		<cfset var obj = StructNew()>
		<cfloop index="pairs" list="#ARGUMENTS.parameters#" delimiters="&">
			<cfset obj[ListFirst(pairs,'=')] = ListLast(pairs,'=')>
		</cfloop>
		<cfreturn shrink(obj['service'],obj)>
	</cffunction>

	<cffunction name="submitFeedback" description="Allows users to submit feedback from within the AIR app" displayname="submitFeedback" returntype="boolean" hint="Allows users to submit feedback from within the AIR app" access="remote" output="false">
		<cfargument name="name" type="string" required="true">
		<cfargument name="from" type="string" required="true">
		<cfargument name="to" type="string" required="true">
		<cfargument name="comments" type="string" required="true">
		<!--- make sure that both arguments have values --->
		<cfif ARGUMENTS.from NEQ "" AND ARGUMENTS.to NEQ "" AND ARGUMENTS.comments NEQ "">
			<cfmail to="#ARGUMENTS.to#" from="#ARGUMENTS.from#" subject="Shrinkadoo feedback email">
From: #ARGUMENTS.name#
Comments: #ARGUMENTS.comments#
			</cfmail>
		</cfif>
		<cfreturn true>
	</cffunction>

	<cffunction name="shrink" description="The primary point of entry, shrinks a URL using the provided service" displayname="shrink" returntype="string" access="remote" output="false">
		<cfargument name="service" type="string" required="true">
		<cfargument name="parameters" required="true" type="struct" hint="Packet of information required by each individual service">

		<cfset var key = ''>
		<cfset var s = ''>
		<cfset var servicePacket = Duplicate(VARIABLES.services[ARGUMENTS.service])>

		<!--- loop over the parameters for the selected service --->
		<cfloop index="s" from="1" to="#ArrayLen(servicePacket.parameters)#">
			<cfif StructKeyExists(ARGUMENTS.parameters,servicePacket.parameters[s]['field'])>
				<!--- make sure that none of the passed in values are empty --->
				<cfif ARGUMENTS.parameters[servicePacket.parameters[s]['field']] EQ ''>
					<cfreturn 'One of more of the required values are empty. Please try again'>
				<cfelse>
					<cfset servicePacket.parameters[s]['value'] = ARGUMENTS.parameters[servicePacket.parameters[s]['field']]>
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn ReplaceNoCase(callAPI(ARGUMENTS.service,servicePacket),'www.','')>
	</cffunction>

	<cffunction name="callAPI" description="Performs the specific API call" displayname="callAPI" returntype="string" access="private" output="false">
		<cfargument name="service" type="string" required="true">
		<cfargument name="packet" type="struct" required="true">

		<cfset var cfhttp = ''>
		<cfset var name = ''>
		<cfset var apiURL = ARGUMENTS.packet['url']>
		<cfset var shortURL = ''>
		<cfset var cfhttpType = IIF((ARGUMENTS.packet['method'] IS "get"), DE('URL'), DE('formfield'))>

		<!--- make the http call --->
		<cftry>
			<cfhttp url="#apiURL#" method="#ARGUMENTS.packet['method']#" timeout="10">
				<!--- loop over the packet of data --->
				<cfloop index="p" from="1" to="#ArrayLen(ARGUMENTS.packet['parameters'])#">
					<cfhttpparam name="#ARGUMENTS.packet['parameters'][p]['field']#" type="#cfhttpType#" value="#ARGUMENTS.packet['parameters'][p]['value']#">
				</cfloop>
			</cfhttp>

			<!--- massage the returned data, return just a simple string --->
			<cfset shortURL = parseURL(cfhttp.filecontent, ARGUMENTS.service)>

			<cfcatch type="any">
				<cfreturn "The call to the #ARGUMENTS.service# service failed">
			</cfcatch>
		</cftry>

		<cfreturn shortURL>
	</cffunction>

	<cffunction name="verifyURL" description="Uses regular expressions to confirm that the passed in URL is valid" displayname="verifyURL" returntype="boolean" hint="Validates a URL" access="private" output="false">
		<cfargument name="url" type="string" required="true">
		<cfset var regex = '(ht|f)tp(s?)://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?'>
		<cfreturn REFindNoCase(regex, ARGUMENTS.url)>
	</cffunction>

	<cffunction name="parseURL" description="Massages the data returned from the API call into a usable string" displayname="parseURL" returntype="string" hint="Parses the returned data string for a URL" access="private" output="false">
		<cfargument name="data" type="string" required="true">
		<cfargument name="service" type="string" required="true">

		<cfset var shortURL = ''>
		<cfset var tmp = ''>
		<cfset var errorMsg = '#ARGUMENTS.service# returned an invalid URL.'>

		<!--- most services return a simple string, but several have to be difficult --->
		<cfswitch expression="#ARGUMENTS.service#">
			<cfcase value="Snurl">
				<!--- snurl returns XML, unless it's an error --->
				<cfif IsXML(ARGUMENTS.data)>
					<cfset shortURL = XMLParse(ARGUMENTS.data).snip.id.XmlText>
				<cfelse>
					<cfset shortURL = errorMsg>
				</cfif>
			</cfcase>
			<cfcase value="ShortIE">
				<!--- snurl returns XML, unless it's an error --->
				<cfif IsXML(ARGUMENTS.data)>
					<cfset shortURL = XMLParse(ARGUMENTS.data).short.shortened.XmlText>
				<cfelse>
					<cfset shortURL = errorMsg>
				</cfif>
			</cfcase>
			<cfcase value="EasyURL">
				<!--- EasyURL returns the whole HTML page --->
				<cfset tmp = REFindNoCase('http://atu.ca/[0-9a-zA-Z]+',ARGUMENTS.data,0,'true')>
				<cfset shortURL = Mid(ARGUMENTS.data,tmp['pos'][1],tmp['len'][1])>
			</cfcase>
			<cfcase value="BudURL">
				<!--- EasyURL returns the whole HTML page --->
				<cfset tmp = REFindNoCase('http://budurl.com/[0-9a-zA-Z]+',ARGUMENTS.data,0,'true')>
				<cfset shortURL = Mid(ARGUMENTS.data,tmp['pos'][1],tmp['len'][1])>
			</cfcase>
			<cfcase value="Trakz">
				<!--- EasyURL returns the whole HTML page --->
				<cfset tmp = DeserializeJSON(ARGUMENTS.data)>
				<cfset shortURL = 'http://tra.kz/' & tmp['s']>
			</cfcase>
			<cfcase value="PeaURL">
				<!--- EasyURL returns the whole HTML page --->
				<cfset tmp = DeserializeJSON(ARGUMENTS.data)>
				<cfset shortURL = tmp['result']['peaurl']>
			</cfcase>
			<cfcase value="PntMe">
				<!--- EasyURL returns the whole HTML page --->
				<cfset tmp = DeserializeJSON(ARGUMENTS.data)>
				<cfset shortURL = tmp['token']>
			</cfcase>
			<cfcase value="MooURL">
				<!--- EasyURL returns the whole HTML page --->
				<cfset tmp = REFindNoCase('http://moourl.com/[0-9a-zA-Z]+',ARGUMENTS.data,0,'true')>
				<cfset shortURL = Mid(ARGUMENTS.data,tmp['pos'][1],tmp['len'][1])>
			</cfcase>
			<cfdefaultcase>
				<!--- everyone else gets a plain string --->
				<cfset shortURL = ARGUMENTS.data>
			</cfdefaultcase>
		</cfswitch>

		<!--- make sure that the returning string is a valid URL --->
		<cfif NOT verifyURL(shortURL)>
			<!--- if it's not a valid URL then we're probably looking at an error --->
			<cfset shortURL = errorMsg>
		</cfif>
		<cfreturn shortURL>
	</cffunction>

	<cffunction name="createStruct" description="Returns a struct from arguments" displayname="createStruct" returntype="struct" hint="Returns a struct from arguments" access="private" output="false">
		<cfreturn ARGUMENTS>
	</cffunction>
</cfcomponent>