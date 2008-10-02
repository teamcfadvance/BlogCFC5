<cfcomponent displayname="XML-RPC" output="false" hint="Allows painless translation of XML-RPC packets to and from CFML data structures">

	<!--- 
	Copyright (c)2003 Agincourt Media
	VERSION: 1.2
		- 2003-6-11:
			- added support for fault packages to XMLRPC2CFML
			- added a little error checking
			- added support for typeless values
			- added support for paranthetical tokens in addition to $token
		- 2003-10-5:
			- added support for namespaced deserialization
	AUTHOR: Roger Benningfield (roger@agincourtmedia.com)
	WEBLOG: http://admin.support.journurl.com/
	This code is free of charge and without warranty. Use at your own risk.
	NOTE: If you make significant modifications or improvements to this component,
		send the resulting code to the author.
	ANOTHER NOTE: This comment section must remain with the component in any
		distribution. Feel free to snip it out on your production box.
	--->

	<cffunction name="XMLRPC2CFML" access="public" returntype="struct" output="false" hint="Accepts an XML-RPC packet and returns a struct containing the method name (returnvar.method) and an array of params (returnvar.params)">
		<cfargument name="data" type="string" required="true" hint="A string containing an XML-RPC package" />
		<cfset var myResult = StructNew() />
		<cfset var dummy = "" />
		<cfset var myContent = arguments.data />
		<cfset var myParsedContent = "" />
		<cfset var myParams = "" />
		<cfset var x = "" />
		<cfif Len(mycontent)>
			<cfset myparsedcontent = XmlParse(mycontent) />
			<cfset dummy = XmlSearch(myparsedcontent, "//methodName") />
			<cfset myResult.method = "" />
			<cfif ArrayLen(dummy)>
				<cfset myResult.method = dummy[1].xmlText />
			</cfif>
			<cfset dummy = XmlSearch(myparsedcontent, "//fault") />
			<cfset myResult.fault = StructNew() />
			<cfset myResult.fault.faultCode = 0 />
			<cfset myResult.fault.faultString = "" />
			<cfif ArrayLen(dummy)>
				<cfset myResult.fault = this.deserialize(branch=dummy[1].value[1]) />
			</cfif>
			<cfset myParams = XmlSearch(myparsedcontent, "//params/param") />
			<cfset myResult.params = ArrayNew(1) />
			<cfloop index="x" from="1" to="#ArrayLen(myParams)#">
				<cfset myResult.params[x] = this.deserialize(branch=myParams[x].value[1]) />
			</cfloop>
		<cfelse>
			<cfset myResult.method = "Error" />
			<cfset myResult.params = ArrayNew(1) />
			<cfset myresult.params[1] = "Error" />
		</cfif>
		<cfreturn myResult />
	</cffunction>
	
	<cffunction name="CFML2XMLRPC" access="public" returntype="string" output="false" hint="Takes a CFML array and converts it into an XML-RPC package">
		<cfargument name="data" required="true" type="array" hint="A CFML array. If the 'type' argument is set to 'call', the first element of the array should be a string containing a method name, with subsequent elements containing data. If the 'type' argument is set to 'response', the array should only contain data. If the 'type' argument is set to 'responsefault', the first array element should be an integer representing a faultCode, and the second element should be a string containing the faultString" />
		<cfargument name="type" required="false" default="call" type="string" hint="Can be set to one of three values: 'call', 'response', and 'responsefault'." />

		<cfset var x = "" />
		<cfset var myXml = "" />
		<cfset var faultValue = "" />

		<cfdump var="#arguments.data#">
		<cfdump var="#arguments.type#">


		<cfswitch expression="#LCase(arguments.type)#">
			<cfcase value="call">
				<cfset myXml = "<methodCall><methodName>#arguments.data[1]#</methodName><params>" />
				<cfloop index="x" from="2" to="#ArrayLen(arguments.data)#">
					<cfset myXml = myXml & "<param>#this.serialize(arguments.data[x])#</param>" />
				</cfloop>
				<cfset myXml = myXml & "</params></methodCall>" />
			</cfcase>
			<cfcase value="response">
				<cfset myXml = "<methodResponse><params>" />
				<cfloop index="x" from="1" to="#ArrayLen(arguments.data)#">
					<cfset myXml = myXml & "<param>#this.serialize(arguments.data[x])#</param>" />
				</cfloop>
				<cfset myXml = myXml & "</params></methodResponse>" />
			</cfcase>
			<cfcase value="responsefault">
				<cfif arrayLen(arguments.data) gte 2>
					<cfset faultValue = arguments.data[2] />
				<cfelse>
					<cfset faultValue = arguments.data[1] />
				</cfif>
				
				<cfset myXml = "<methodResponse><fault><value><struct><member><name>faultCode</name><value><int>#arguments.data[1]#</int></value></member><member><name>faultString</name><value><string>#XmlFormat(faultValue)#</string></value></member></struct></value></fault></methodResponse>" />
			</cfcase>
		</cfswitch>
		<cfreturn myXml />
	</cffunction>
	
	<cffunction name="serialize" access="public" output="false">
		<cfargument name="branch" required="true" />
		<cfset var myResult = "<value>" />
		<cfset var myStruct = "" />
		<cfset var myArray = "" />
		<cfset var myKey = "" />
		<cfset var myDate = "" />
		<cfset var dummy = arguments.branch />
		<cfset var x = "" />
		
		<cfif IsSimpleValue(dummy) AND (Left(dummy, 8) IS "$boolean" OR Left(dummy, 9) IS "(boolean)")>
			<cfset dummy = Replace(dummy, "$boolean", "", "ONE") />
			<cfset dummy = Replace(dummy, "(boolean)", "", "ONE") />
			<cfset myResult = myResult & "<boolean>#dummy#</boolean>" />
		<cfelseif IsSimpleValue(dummy) AND (Left(dummy, 3) IS "$i4" OR Left(dummy, 4) IS "(i4)")>
			<cfset dummy = Replace(dummy, "$i4", "", "ONE") />
			<cfset dummy = Replace(dummy, "(i4)", "", "ONE") />
			<cfset myResult = myResult & "<i4>#dummy#</i4>" />
		<cfelseif IsSimpleValue(dummy) AND (Left(dummy, 4) IS "$int" OR Left(dummy, 5) IS "(int)")>
			<cfset dummy = Replace(dummy, "$int", "", "ONE") />
			<cfset dummy = Replace(dummy, "(int)", "", "ONE") />
			<cfset myResult = myResult & "<int>#dummy#</int>" />
		<cfelseif IsNumeric(dummy) OR (IsSimpleValue(dummy) AND (Left(dummy, 7) IS "$double" OR Left(dummy, 8) IS "(double)"))>
			<cfset dummy = Replace(dummy, "$double", "", "ONE") />
			<cfset dummy = Replace(dummy, "(double)", "", "ONE") />
			<cfset myResult = myResult & "<double>#dummy#</double>" />
		<cfelseif IsBinary(dummy)>
			<cfset myResult = myResult & "<base64>#ToBase64(dummy)#</base64>" />
		<cfelseif IsDate(dummy) OR (IsSimpleValue(dummy) AND (Left(dummy, 17) IS "$dateTime.iso8601" OR Left(dummy, 18) IS "(dateTime.iso8601)"))>
			<cfset dummy = Replace(dummy, "$dateTime.iso8601", "", "ONE") />
			<cfset dummy = Replace(dummy, "(dateTime.iso8601)", "", "ONE") />
			<cfset mydate = ParseDateTime(dummy) />
			<cfset myResult = myResult & "<dateTime.iso8601>#DateFormat(mydate, "yyyymmdd")#T#TimeFormat(mydate, "HH:mm:ss")#</dateTime.iso8601>" />
		<cfelseif IsSimpleValue(dummy) OR (IsSimpleValue(dummy) AND (Left(dummy, 7) IS "$string" OR Left(dummy, 8) IS "(string)"))>
			<cfif Left(dummy, 7) IS "$string">
				<cfset dummy = Replace(dummy, "$string", "", "ONE") />
			<cfelseif Left(dummy, 8) IS "(string)">
				<cfset dummy = Replace(dummy, "(string)", "", "ONE") />
			</cfif>

			<cfset myResult = myResult & "<string>#XmlFormat(dummy)#</string>" />

			<!---
			<cfset myResult = myResult & "#XmlFormat(dummy)#" />
			--->
		<cfelseif IsArray(dummy)>
			<cfset myResult = myResult & "<array><data>" />
			<cfloop index="x" from="1" to="#ArrayLen(dummy)#">
				<cfset myResult = myResult & this.serialize(branch=dummy[x]) />
			</cfloop>
			<cfset myResult = myResult & "</data></array>" />
		<cfelseif IsStruct(dummy)>
			<cfset myResult = myResult & "<struct>" />
			<cfloop item="x" collection="#dummy#">
				<cfset myResult = myResult & "<member><name>#x#</name>" />
				<cfset myResult = myResult & this.serialize(branch=dummy[x]) />
				<cfset myResult = myResult & "</member>" />
			</cfloop>
			<cfset myResult = myResult & "</struct>" />
		</cfif>
		<cfset myResult = myResult & "</value>" />
		<cfreturn myResult />
	</cffunction>
	
	<cffunction name="deserialize" access="public" output="false">
		<cfargument name="branch" required="true" />
		<cfargument name="namespace" required="false" default="" />
		<cfset var myResult = "" />
		<cfset var myStruct = "" />
		<cfset var myArray = "" />
		<cfset var myKey = "" />
		<cfset var dummy = arguments.branch />
		<cfset var x = 0 />
		<cfset var mynamespace = "">
		
		<cfset var rawdatetime = "">
		<cfset var targetzoneoffset = "">
		
		<cfif Len(arguments.namespace)>
			<cfset mynamespace = arguments.namespace & ":">
		</cfif>
		<cfif StructKeyExists(dummy, "#mynamespace#string")>
			<cfset myResult = ToString(dummy.string.xmlText) />
		<cfelseif StructKeyExists(dummy, "#mynamespace#boolean")>
			<cfset myResult = YesNoFormat(dummy.boolean.xmlText) />
		<cfelseif StructKeyExists(dummy, "#mynamespace#i4")>
			<cfset myResult = Int(dummy.i4.xmlText) />
		<cfelseif StructKeyExists(dummy, "#mynamespace#int")>
			<cfset myResult = Int(dummy.int.xmlText) />
		<cfelseif StructKeyExists(dummy, "#mynamespace#double")>
			<cfset myResult = Val(dummy.double.xmlText) />
		<cfelseif StructKeyExists(dummy, "#mynamespace#base64")>
			<cfset myResult = ToBinary(dummy.base64.xmlText) />
		<cfelseif StructKeyExists(dummy, "#mynamespace#dateTime.iso8601")>
			<cfset myResult = dummy["#mynamespace#dateTime.iso8601"].xmlText />

			<!--- fix by ddblock --->
			<cfif not find("-",left(myResult,5))>
				<cfset myResult = Insert("-", myResult, 4) />
				<cfset myResult = Insert("-", myResult, 7) />
				<cfset myResult = Replace(myResult, "T", " ", "ONE") />
			</cfif>
			
			<!--- RayMod --->
			<!---
			<cfif right(myresult, 1) is "Z">
				<cfset myresult = left(myresult, len(myresult)-1)>
			</cfif>
			
			<cfset myResult = ParseDateTime(myResult) />
			
			Following UDF from CFLib, by David Satz
			--->
			<cfscript>
				rawDatetime = left(myresult,10) & " " & mid(myresult,12,8);
				targetZoneOffset = -1 * getTimeZoneInfo().utcHourOffset;
				
				// adjust offset based on offset given in date string
				if (uCase(mid(myresult,20,1)) neq "Z")
					targetZoneOffset = targetZoneOffset -  val(mid(myresult,20,3)) ;
	
				myresult =  DateAdd("h", targetZoneOffset, CreateODBCDateTime(rawDatetime));
			
			</cfscript>
		<cfelseif StructKeyExists(dummy, "#mynamespace#array")>
			<cfset myArray = ArrayNew(1) />
			<cfset dummy = XmlSearch(dummy, "#mynamespace#array/#mynamespace#data/#mynamespace#value") />
			<cfloop index="x" from="1" to="#ArrayLen(dummy)#">
				<cfset myArray[x] = this.deserialize(branch=dummy[x], namespace=arguments.namespace) />
			</cfloop>
			<cfset myResult = myArray />
		<cfelseif StructKeyExists(dummy, "#mynamespace#struct")>
			<cfset myStruct = StructNew() />
			<cfset dummy = XmlSearch(dummy, "#mynamespace#struct/#mynamespace#member") />
			<cfloop index="x" from="1" to="#ArrayLen(dummy)#">
				<cfset myKey = dummy[x]["#mynamespace#name"].xmlText />
				<cfset myStruct[myKey] = this.deserialize(branch=dummy[x]["#mynamespace#value"][1], namespace=arguments.namespace) />
			</cfloop>
			<cfset myResult = myStruct />
		<cfelse>
			<cfset myResult = ToString(dummy.xmlText) />
		</cfif>
		<cfreturn myResult />
	</cffunction>

	<!---//
		the following functions convert <code> blocks that were written
		in rich text editor to be escaped as if they were typed as 
		regular source code and also convert <more/> tags to markup
	//--->
	<cffunction name="unescapeMarkup" access="public" output="false" hint="This function finds <code> blocks written in html and converts the text.">
		<cfargument name="string" type="string" required="true" />
		
		<cfset var counter = 0 />
		<cfset var newbody = "" />
		<cfset var codeportion = "" />
		<cfset var codeblock = "" />
		<cfset var result = "" />
	
		<cfif findNoCase("&lt;code&gt;", arguments.string) and findNoCase("&lt;/code&gt;", arguments.string)>
			<cfset counter = findNoCase("&lt;code&gt;", arguments.string)>
			<cfloop condition="counter gte 1">
				<cfset codeblock = reFindNoCase("(?s)(.*)(&lt;code&gt;)(.*)(&lt;/code&gt;)(.*)", arguments.string, 1, true) /> 
				<cfif arrayLen(codeblock.len) gte 6>
					<cfset codeportion = mid(arguments.string, codeblock.pos[4], codeblock.len[4]) />
					<cfif len(trim(codeportion))>
						<cfset result = convertHtmlToText(codeportion) />
					<cfelse>
						<cfset result = "" />
					</cfif>
					<cfset newbody = mid(arguments.string, 1, codeblock.len[2]) & result & mid(arguments.string, codeblock.pos[6], codeblock.len[6]) />
					
					<cfset arguments.string = newbody />
					<cfset counter = findNoCase("&lt;code&gt;",  arguments.string, counter) />
				<cfelse>
					<!--- bad crap, maybe <code> and no ender, or maybe </code><code> --->
					<cfset counter = 0 />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfset arguments.string = reReplaceNoCase(arguments.string, "&lt;more\s*\/&gt;", "<more/>", "all") />
		<cfset arguments.string = reReplaceNoCase(arguments.string, "&lt;textblock((\s+[^\]]*)|(\s*\/))?&gt;", "<textblock\1>", "all") />

		<cfset arguments.string = reReplaceNoCase(arguments.string, "&lt;\[code((\s+[^\]]*)|(\s*\/))?\]&gt;", "&lt;code\1&gt;", "all") />
		<cfset arguments.string = reReplaceNoCase(arguments.string, "&lt;\[more((\s+[^\]]*)|(\s*\/))?\]&gt;", "&lt;more\1&gt;", "all") />
		<cfset arguments.string = reReplaceNoCase(arguments.string, "&lt;\[textblock((\s+[^\]]*)|(\s*\/))?\]&gt;", "&lt;textblock\1&gt;", "all") />

		<cfset arguments.string = reMatchReplaceNoCase("<textblock((\s+[^>]*)|(\s*\/))?>", arguments.string, "&quot;", """") />

		<cfreturn arguments.string />
	
	</cffunction>
	
	<cffunction name="convertHtmlToText" access="public" output="false" hint="Handles actual html-to-plain text conversion.">
		<cfargument name="html" type="string" required="true" />
		
		<cfset var sHtml = arguments.html />
		
		<!---// remove line breaks, since we use HTML to determine them //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "#chr(13)#?#chr(10)#", "", "all") />
		<!---// remove extra whitespace, so we treat like html (multiple whitespace is counted as a single space) //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "\s{2,}", " ", "all") />
		<!---// remove paragraph tags //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "<p([^>]+)?>", chr(13) & chr(10), "all") />
		<!---// remove line break tags //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "<br([^>]+)?>", chr(13) & chr(10), "all") />
		<!---// remove erronous markup tags //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "<[^>]+>", "", "all") />
		<!---// replace entity less than symbols //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "&lt;|&##60;", "<", "all") />
		<!---// replace entity greater than symbols //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "&gt;|&##62;", ">", "all") />
		<!---// replace entity quotes with regular quotes //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "&quot;|&##34;", """", "all") />
		<!---// replace entity quotes with regular quotes //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "&apos;|&##34;", "''", "all") />
		<!---// convert no break spaces to regular spaces //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "&nbsp;|&##xA0;|&##160;", " ", "all") />
	
		<!---// this must be done last to avoid premature excaping of other html entities //--->
		<cfset sHtml = reReplace(sHtml, "&amp;|&##38;", "&", "all") />
	
		<!---// convert 4 spaces to a tab //--->
		<cfset sHtml = reReplace(sHtml, "    ", "#chr(9)#", "all") />
	
		<cfreturn "<code>" & sHtml & "</code>" />
	</cffunction>

	<!---//
		the follow functions covert markup back to escaped HTML
	//--->
	<cffunction name="escapeMarkup" access="public" output="false" hint="This function finds <code> blocks written in html and converts the text.">
		<cfargument name="string" type="string" required="true" />
		
		<cfset var counter = 0 />
		<cfset var newbody = "" />
		<cfset var codeportion = "" />
		<cfset var codeblock = "" />
		<cfset var result = "" />
		
		<cfset arguments.string = reReplaceNoCase(arguments.string, "&lt;code((\s+[^\s]*(?=&gt;))|(\s*\/))?&gt;", "&lt;[code\1]&gt;", "all") />
		<cfset arguments.string = reReplaceNoCase(arguments.string, "&lt;more((\s+[^\s]*(?=&gt;))|(\s*\/))?&gt;", "&lt;[more\1]&gt;", "all") />
		<cfset arguments.string = reReplaceNoCase(arguments.string, "&lt;textblock((\s+[^\s]*(?=&gt;))|(\s*\/))?&gt;", "&lt;[textblock\1]&gt;", "all") />
	
		<cfif findNoCase("<code>", arguments.string) and findNoCase("</code>", arguments.string)>
			<cfset counter = findNoCase("<code>", arguments.string)>
			<cfloop condition="counter gte 1">
				<cfset codeblock = reFindNoCase("(?s)(.*)(<code>)(.*)(</code>)(.*)", arguments.string, 1, true) /> 
				<cfif arrayLen(codeblock.len) gte 6>
					<cfset codeportion = mid(arguments.string, codeblock.pos[4], codeblock.len[4]) />
					<cfif len(trim(codeportion))>
						<cfset result = convertTextToHtml(codeportion) />
					<cfelse>
						<cfset result = "" />
					</cfif>
					<cfset newbody = mid(arguments.string, 1, codeblock.len[2]) & result & mid(arguments.string,codeblock.pos[6],codeblock.len[6]) />
					
					<cfset arguments.string = newbody />
					<cfset counter = findNoCase("<code>",  arguments.string, counter) />
				<cfelse>
					<!--- bad crap, maybe <code> and no ender, or maybe </code><code> --->
					<cfset counter = 0 />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfset arguments.string = reReplaceNoCase(arguments.string, "<more((\s+[^>]*)|(\s*\/))>", "&lt;more\1&gt;", "all") />
		<cfset arguments.string = reReplaceNoCase(arguments.string, "<textblock((\s+[^>]*)|(\s*\/))?>", "&lt;textblock\1&gt;", "all") />

		<cfreturn arguments.string />
	</cffunction>
	
	<cffunction name="convertTextToHtml" access="public" output="false" hint="Handles actual html-to-plain text conversion.">
		<cfargument name="html" type="string" required="true" />
		
		<cfset var sHtml = arguments.html />
		
		<!---// this must be done first to avoid excaping of other html entities //--->
		<cfset sHtml = reReplace(sHtml, "&", "&amp;", "all") />
		<!---// replace entity less than symbols //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "<", "&lt;", "all") />
		<!---// replace entity greater than symbols //--->
		<cfset sHtml = reReplaceNoCase(sHtml, ">", "&gt;", "all") />
		<!---// replace entity quotes with regular quotes //--->
		<cfset sHtml = reReplaceNoCase(sHtml, """", "&quot;", "all") />
		<!---// replace entity quotes with regular quotes //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "&apos;|&##34;", "''", "all") />
		<!---// ** DO LAST ** remove line breaks, since we use HTML to determine them //--->
		<cfset sHtml = reReplaceNoCase(sHtml, "(#chr(13)#?#chr(10)#)", "<br/>\1", "all") />
	
		<!---// convert 4 spaces to a tab //--->
		<cfset sHtml = reReplace(sHtml, "#chr(9)#", "&##160;&##160;&##160;&##160;", "all") />
	
		<cfreturn "&lt;code&gt;" & sHtml & "&lt;/code&gt;" />
	</cffunction>
	
	<cffunction name="reMatchReplaceNoCase" access="private" returntype="string" output="false" hint="Emulates the reMatch function in ColdFusion 8.">
		<cfargument name="regex" type="string" required="true" />
		<cfargument name="str" type="string" required="true" />
		<cfargument name="findstr" type="string" required="true" />
		<cfargument name="replacestr" type="string" required="true" />
		<cfargument name="matchContext" type="string" required="false" default="all" />

		<cfscript>
		var pos = 1;
		var loop = 1;
		var match = "";
		var currentMatch = "";
		var newstr = "";
		var charsRemaining = 0;
		var x = 1;
		
		while( reFindNoCase(arguments.regex, arguments.str, pos) ){ 
			match = reFindNoCase(arguments.regex, arguments.str, pos, true);

			if( (arrayLen(match.len)) gt 0 and match.len[1] ){
				currentMatch = mid(arguments.str, match.pos[1], match.len[1]);
				currentMatch = reReplaceNoCase(currentMatch, arguments.findstr, arguments.replacestr, arguments.matchContext);
				newstr = left(arguments.str, match.pos[1]-1) & currentMatch;
				charsRemaining = len(arguments.str) - (match.pos[1] + match.len[1]);
				if( charsRemaining gt 0 ) newstr = newstr & right(arguments.str, charsRemaining);
				
				arguments.str = newstr;
				
			}

			pos = match.pos[1] + len(currentMatch);
			loop = loop + 1;
		}
		return arguments.str;
		</cfscript>

	</cffunction>

</cfcomponent>