<!---
	Name         : utils
	Author       : Raymond Camden 
	Created      : A long time ago in a galaxy far, far away
	Last Updated : January 14, 2008
	History      : Reset history for version 4.0
				 : Added this header, and moved coloredCode in (rkc 9/22/05)
				 : Added Mail (rkc 7/7/06)
				 : Added getResource (rkc 8/20/06)
				 : fix in the comment area, not from me, but I forget who did it (rkc 1/18/08)
	Purpose		 : Utilities
--->
<cfcomponent displayName="Utils" output="false" hint="Utility functions for the Blog">
	
	<cffunction name="configParam" output="false" returnType="string" access="public"
				hint="Basically says, try to get name.key in ini file, and if not, default to default.key. Also support %default% expansion, which just means replace with default value">
		<cfargument name="iniFile" type="string" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="key" type="string" required="true">
		
		<cfset var result = getProfileString(inifile,name,key)>
		
		<cfif result eq "">
			<cfset result = getProfileString(inifile,"Default",key)>
		</cfif>
		
		<cfreturn result>
				
	</cffunction>

	<cffunction name="getResource" access="public" returnType="string" output="false"
				hint="A utility wrapper for RB">
		<cfargument name="str" type="string" required="true">
		<cfreturn application.resourceBundle.getResource(arguments.str)>
	</cffunction>
	
	<cffunction name="mail" access="public" returnType="void" output="false"
				hint="This function handles the funky auth mail versus non auth mail. All mail ops for app should eventually go through this.">
		<cfargument name="to" type="string" required="true">
		<cfargument name="from" type="string" required="true">
		<cfargument name="subject" type="string" required="true">
		<cfargument name="body" type="string" required="true">
		<cfargument name="cc" type="string" required="false" default="">
		<cfargument name="bcc" type="string" required="false" default="">		
		<cfargument name="type" type="string" required="false" default="text">		
		<cfargument name="mailserver" type="string" required="false" default="">
		<cfargument name="mailusername" type="string" required="false" default="">
		<cfargument name="mailpassword" type="string" required="false" default="">
		<cfargument name="failto" type="string" required="false" default="">

		<cfif arguments.mailserver is "">
			<cfmail to="#arguments.to#" from="#arguments.from#" cc="#arguments.cc#" bcc="#arguments.bcc#" subject="#arguments.subject#" type="#arguments.type#" failto="#arguments.failto#">#arguments.body#</cfmail>
		<cfelse>
			<cfmail to="#arguments.to#" from="#arguments.from#" cc="#arguments.cc#" bcc="#arguments.bcc#" subject="#arguments.subject#" type="#arguments.type#"
					server="#arguments.mailserver#" username="#arguments.mailusername#" password="#arguments.mailpassword#" failto="#arguments.failto#">#arguments.body#</cfmail>
		</cfif>
	
	</cffunction>
	
	<cffunction name="throw" access="public" returnType="void" output="false"
				hint="Throws errors.">
		<cfargument name="message" type="string" required="false" default="">
		<cfthrow type="blog.cfc" message="#arguments.message#">
		
	</cffunction>

	<cffunction name="htmlToPlainText" access="public" returnType="string" output="false"
				hint="Sanitizes a string from having HTML by replacing common entites and remove the others.">
		<cfargument name="input" type="string" required="true">

		<!---// remove html tags (do this first to avoid issues after replacing < & >) //--->
		<cfset arguments.input = reReplace(arguments.input, "<[^>]+>", "", "all") />
		<!---// replace the ellipse entity with three periods //--->
		<cfset arguments.input = replace(arguments.input, "&hellip;", "...", "all") />
		<!---// replace the em-dashes with two dashes //--->
		<cfset arguments.input = reReplace(arguments.input, "(&mdash;)|(&##8212;)|(&##151;)", "--", "all") />
		<!---// replace the < entity with the real character //--->
		<cfset arguments.input = replace(arguments.input, "&lt;", "<", "all") />
		<!---// replace the > entity with the real character //--->
		<cfset arguments.input = replace(arguments.input, "&gt;", ">", "all") />
		<!---// replace the & entity with the real character //--->
		<cfset arguments.input = replace(arguments.input, "&amp;", "&", "all") />
		<!---// remove all other html entities //--->
		<cfset arguments.input = reReplace(arguments.input, "(&##[0-9]+;)|(&[A-Za-z]+;)", "", "all") />
		
		<cfreturn arguments.input />
	</cffunction>
	
	
	<cffunction name="fixUrl" access="public" returntype="string" output="false" hint="Ensures a URL is properly formatted.">
		<cfargument name="url" type="string" required="true" />
		
		<cfreturn reReplace(arguments.url, "\/{2,}", "/", "all")>
	</cffunction>

	<cfscript>
/**
 * When given an email address this function will return the address in a format safe from email harvesters.
 * Minor edit by Rob Brooks-Bilson (rbils@amkor.com)
 * Update now converts all characters in the email address to unicode, not just the @ symbol. (by author)
 *
 * @param EmailAddress 	 Email address you want to make safe. (Required)
 * @param Mailto 	 Boolean (Yes/No). Indicates whether to return formatted email address as a mailto link.  Default is No. (Optional)
 * @return Returns a string
 * @author Seth Duffey (rbils@amkor.comsduffey@ci.davis.ca.us)
 * @version 2, May 2, 2002
 */
		function EmailAntiSpam(EmailAddress) {
			var i = 1;
			var antiSpam = "";
			for (i=1; i LTE len(EmailAddress); i=i+1) {
				antiSpam = antiSpam & "&##" & asc(mid(EmailAddress,i,1)) & ";";
			}
			if ((ArrayLen(Arguments) eq 2) AND (Arguments[2] is "Yes")) return "<a href=" & "mailto:" & antiSpam & ">" & antiSpam & "</a>";
			else return antiSpam;
		}
	</cfscript>

	<cffunction name="toHTML" returntype="string">
		<cfargument name="source" type="string" required="true" />
<!---- Change greater than and less than back into non-HTML escaped characters --->
		<cfset var result = replacenocase(replacenocase(source,'&lt;','<','all'),'&gt;','>','all')>
<!---- Change %22 back into quotes --->
		<cfset result = replacenocase(result,"&quot;","""","all")>
		<cfreturn result>
	</cffunction>

	<cfscript>
		function titleCase(str) {
			return uCase(left(str,1)) & right(str,len(str)-1);
		}

/**
* Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
* Update by David Kearns to support '
* SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
* More TLDs
* Version 4 by P Farrel, supports limits on u/h
* Added mobi
* v6 more tlds
*
* @param str      The string to check. (Required)
* @return Returns a boolean.
* @author Jeff Guillaume (SBrown@xacting.comjeff@kazoomis.com)
* @version 6, July 29, 2008
* Note this is different from CFLib as it has the "allow +" support
*/
		function isEmail(str) {
			return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*(\+['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
				len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
		}

		function isLoggedIn() {
			return structKeyExists(session,"loggedin");
		}

/**
 * An &quot;enhanced&quot; version of ParagraphFormat.
 * Added replacement of tab with nonbreaking space char, idea by Mark R Andrachek.
 * Rewrite and multiOS support by Nathan Dintenfas.
 *
 * @param string 	 The string to format. (Required)
 * @return Returns a string.
 * @author Ben Forta (ben@forta.com)
 * @version 3, June 26, 2002
 */
		function ParagraphFormat2(str) {
//first make Windows style into Unix style
			str = replace(str,chr(13)&chr(10),chr(10),"ALL");
//now make Macintosh style into Unix style
			str = replace(str,chr(13),chr(10),"ALL");
//now fix tabs
			str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
//now return the text formatted in HTML
			return replace(str,chr(10),"<br />","ALL");
		}

/**
 * A quick way to test if a string is a URL
 *
 * @param stringToCheck 	 The string to check.
 * @return Returns a boolean.
 * @author Nathan Dintenfass (nathan@changemedia.com)
 * @version 1, November 22, 2001
 */
		function isURL(stringToCheck){
			return REFindNoCase("^(((https?:|ftp:|gopher:)\/\/))[-[:alnum:]\?%,\.\/&##!@:=\+~_]+[A-Za-z0-9\/]$",stringToCheck) NEQ 0;
		}

/**
 * Converts a byte value into kb or mb if over 1,204 bytes.
 *
 * @param bytes 	 The number of bytes. (Required)
 * @return Returns a string.
 * @author John Bartlett (jbartlett@strangejourney.net)
 * @version 1, July 31, 2005
 */
		function KBytes(bytes) {
			var b=0;

			if(arguments.bytes lt 1024) return trim(numberFormat(arguments.bytes,"9,999")) & " bytes";

			b=arguments.bytes / 1024;

			if (b lt 1024) {
				if(b eq int(b)) return trim(numberFormat(b,"9,999")) & " KB";
				return trim(numberFormat(b,"9,999.9")) & " KB";
			}
			b= b / 1024;
			if (b eq int(b)) return trim(numberFormat(b,"999,999,999")) & " MB";
			return trim(numberFormat(b,"999,999,999.9")) & " MB";
		}

/* copied from soundings UDFs
 to deal with the merging of the two apps
*/
		function arrayDefinedAt(arr,pos) {
			var temp = "";
			try {
				temp = arr[pos];
				return true;
			}
			catch(coldfusion.runtime.UndefinedElementException ex) {
				return false;
			}
			catch(coldfusion.runtime.CfJspPage$ArrayBoundException ex) {
				return false;
			}
		}
		request.udf.arrayDefinedAt = arrayDefinedAt;

	</cfscript>

<!---
	  This UDF from Steven Erat, http://www.talkingtree.com/blog
--->
	<cffunction name="replaceLinks" access="public" output="yes" returntype="string">
		<cfargument name="input" required="Yes" type="string">
		<cfargument name="linkmax" type="numeric" required="false" default="50">
		<cfscript>
			var inputReturn = arguments.input;
			var pattern = "";
			var urlMatches = structNew();
			var inputCopy = arguments.input;
			var result = "";
			var rightStart = "";
			var rightInputCopyLen = "";
			var targetNameMax = "";
			var targetLinkName = "";
			var i = "";

			pattern = "(((https?:|ftp:|gopher:)\/\/)|(www\.|ftp\.))[-[:alnum:]\?%,\.\/&##!;@:=\+~_]+[A-Za-z0-9\/]";

			while (len(inputCopy)) {
				result = refind(pattern,inputCopy,1,'true');
				if (result.pos[1]){
					match = mid(inputCopy,result.pos[1],result.len[1]);
					urlMatches[match] = "";
					rightStart = result.len[1] + result.pos[1];
					rightInputCopyLen = len(inputCopy)-rightStart;
					if (rightInputCopyLen GT 0){
						inputCopy = right(inputCopy,rightInputCopyLen);
					} else break;
				} else break;
			}

//convert back to array
			urlMatches = structKeyArray(urlMatches);

			targetNameMax = arguments.linkmax;
			for (i=1; i LTE arraylen(urlMatches);i=i+1) {
				targetLinkName = urlMatches[i];
				if (len(targetLinkName) GTE targetNameMax) {
					targetLinkName = left(targetLinkName,targetNameMax) & "...";
				}
				inputReturn = replace(inputReturn,urlMatches[i],'<a href="#urlMatches[i]#" target="_blank">#targetLinkName#</a>',"all");
			}
		</cfscript>
		<cfreturn inputReturn>
	</cffunction>


<!---- Modified from parseMySES function in parseses.cfm from BlogCFC; modified to be more generic and also moved to tag from script ---->
	<cffunction name="parseSES" returntype="struct">
		<cfset var urlVars=reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '')>
		<cfset var r = structNew()>
		<cfset var theLen = listLen(urlVars,"/")>
		<cfset var TempIndex = "">

<!---- if the list length is 0 or the only element of the URL vars is the delimiter, return the empty struct ---->
		<cfif (len(urlVars) is 0 or urlvars is "/")>
			<cfreturn r>
		</cfif>

<!---- this is the new stuff --->
		<cfloop from="1" to="#theLen#" index="TempIndex" step="2">
<!--- the try catches URL variables that are off ---->
			<cftry>
				<cfset r[ListGetAt(urlVars,Tempindex,"/")] = ListGetAt(urlVars,Tempindex+1,"/")>
				<cfcatch type="any">
					<cfset r[ListGetAt(urlVars,Tempindex,"/")] = "">
				</cfcatch>
			</cftry>

		</cfloop>

		<cfreturn r>

	</cffunction>


</cfcomponent>