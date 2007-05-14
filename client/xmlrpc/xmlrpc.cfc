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
				<cfset myXml = "<methodResponse><fault><value><struct><member><name>faultCode</name><value><int>#arguments.data[1]#</int></value></member><member><name>faultString</name><value><string>#XmlFormat(arguments.data[2])#</string></value></member></struct></value></fault></methodResponse>" />
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
	
</cfcomponent>