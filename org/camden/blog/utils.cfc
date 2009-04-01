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

<!--- 
Copyright for coloredCode function. Also note that Jeff Coughlin made some mods to this as well.
=============================================================
	Utility:	ColdFusion ColoredCode v3.2
	Author:		Dain Anderson
	Email:		webmaster@cfcomet.com
	Revised:	June 7, 2001
	Download:	http://www.cfcomet.com/cfcomet/utilities/
============================================================= 
--->
	<cffunction name="coloredCode" output="false" returnType="string" access="public"
			   hint="Colors code">
		<cfargument name="dataString" type="string" required="true">
		<cfargument name="class" type="string" required="true">

		<cfset var data = trim(arguments.dataString) />
		<cfset var eof = 0>
		<cfset var bof = 1>
		<cfset var match = "">
		<cfset var orig = "">
		<cfset var chunk = "">

		<cfscript>
		/* Convert special characters so they do not get interpreted literally; italicize and boldface */
		data = REReplaceNoCase(data, '&([[:alpha:]]{2,});', '«strong»«em»&amp;\1;«/em»«/strong»', 'ALL');
	
		/* Convert many standalone (not within quotes) numbers to blue, ie. myValue = 0 */
		data = REReplaceNoCase(data, "(gt|lt|eq|is|,|\(|\))([[:space:]]?[0-9]{1,})", "\1«span style='color: ##0000ff'»\2«/span»", "ALL");
	
		/* Convert normal tags to navy blue */
		data = REReplaceNoCase(data, "<(/?)((!d|b|c(e|i|od|om)|d|e|f(r|o)|h|i|k|l|m|n|o|p|q|r|s|t(e|i|t)|u|v|w|x)[^>]*)>", "«span style='color: ##000080'»<\1\2>«/span»", "ALL");
	
		/* Convert all table-related tags to teal */
		data = REReplaceNoCase(data, "<(/?)(t(a|r|d|b|f|h)([^>]*)|c(ap|ol)([^>]*))>", "«span style='color: ##008080'»<\1\2>«/span»", "ALL");
	
		/* Convert all form-related tags to orange */
		data = REReplaceNoCase(data, "<(/?)((bu|f(i|or)|i(n|s)|l(a|e)|se|op|te)([^>]*))>", "«span style='color: ##ff8000'»<\1\2>«/span»", "ALL");
	
		/* Convert all tags starting with 'a' to green, since the others aren't used much and we get a speed gain */
		data = REReplaceNoCase(data, "<(/?)(a[^>]*)>", "«span style='color: ##008000'»<\1\2>«/span»", "ALL");
	
		/* Convert all image and style tags to purple */
		data = REReplaceNoCase(data, "<(/?)((im[^>]*)|(sty[^>]*))>", "«span style='color: ##800080'»<\1\2>«/span»", "ALL");
	
		/* Convert all ColdFusion, SCRIPT and WDDX tags to maroon */
		data = REReplaceNoCase(data, "<(/?)((cf[^>]*)|(sc[^>]*)|(wddx[^>]*))>", "«span style='color: ##800000'»<\1\2>«/span»", "ALL");
	
		/* Convert all HTML and ColdFusion comments to gray */	
		/* The next 10 lines of code can be replaced with the commented-out line following them, if you do care whether HTML and CFML 
		   comments contain colored markup. */

		while(NOT EOF) {
			Match = REFindNoCase("<!--" & "-?([^-]*)-?-->", data, BOF, True);
			if (Match.pos[1]) {
				Orig = Mid(data, Match.pos[1], Match.len[1]);
				Chunk = REReplaceNoCase(Orig, "«(/?[^»]*)»", "", "ALL");
				BOF = ((Match.pos[1] + Len(Chunk)) + 38); // 38 is the length of the SPAN tags in the next line
				data = Replace(data, Orig, "«span style='color: ##808080'»«em»#Chunk#«/em»«/span»");
			} else EOF = 1;
		}

		/* Convert all inline "//" comments to gray (revised) */
		data = REReplaceNoCase(data, "([^:/]\/{2,2})([^\n]+)($|[\n])", "«span style='color: ##808080'»«em»\1\2«/em»«/span»", "ALL");
	
		/* Convert all multi-line script comments to gray */
		data = REReplaceNoCase(data, "(\/\*[^\*]*\*\/)", "«span style='color: ##808080'»«em»\1«/em»«/span»", "ALL");
	

		/* Convert all quoted values to blue */
		data = REReplaceNoCase(data, """([^""]*)""", "«span style=""color: ##0000ff""»""\1""«/span»", "all");

		/* Convert left containers to their ASCII equivalent */
		data = REReplaceNoCase(data, "<", "&lt;", "ALL");

		/* Convert right containers to their ASCII equivalent */
		data = REReplaceNoCase(data, ">", "&gt;", "ALL");

		/* Revert all pseudo-containers back to their real values to be interpreted literally (revised) */
		data = REReplaceNoCase(data, "«([^»]*)»", "<\1>", "ALL");

		/* ***New Feature*** Convert all FILE and UNC paths to active links (i.e, file:///, \\server\, c:\myfile.cfm) */
		data = REReplaceNoCase(data, "(((file:///)|([a-z]:\\)|(\\\\[[:alpha:]]))+(\.?[[:alnum:]\/=^@*|:~`+$%?_##& -])+)", "<a target=""_blank"" href=""\1"">\1</a>", "ALL");

		/* Convert all URLs to active links (revised) */
		data = REReplaceNoCase(data, "([[:alnum:]]*://[[:alnum:]\@-]*(\.[[:alnum:]][[:alnum:]-]*[[:alnum:]]\.)?[[:alnum:]]{2,}(\.?[[:alnum:]\/=^@*|:~`+$%?_##&-])+)", "<a target=""_blank"" href=""\1"">\1</a>", "ALL");

		/* Convert all email addresses to active mailto's (revised) */
		data = REReplaceNoCase(data, "(([[:alnum:]][[:alnum:]_.-]*)?[[:alnum:]]@[[:alnum:]][[:alnum:].-]*\.[[:alpha:]]{2,})", "<a href=""mailto:\1"">\1</a>", "ALL");
		</cfscript>

		<!--- mod by ray --->
		<!--- change line breaks at end to <br /> --->
		<cfset data = replace(data,chr(13),"<br />","all") />
		<!--- replace tab with 3 spaces --->
		<cfset data = replace(data,chr(9),"&nbsp;&nbsp;&nbsp;","all") />
		<cfset data = "<div class=""#arguments.class#"">" & data &  "</div>" />
		
		<cfreturn data>
	</cffunction>
	
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
		
		<cfif arguments.mailserver is "">
			<cfmail to="#arguments.to#" from="#arguments.from#" cc="#arguments.cc#" bcc="#arguments.bcc#" subject="#arguments.subject#" type="#arguments.type#">#arguments.body#</cfmail>
		<cfelse>
			<cfmail to="#arguments.to#" from="#arguments.from#" cc="#arguments.cc#" bcc="#arguments.bcc#" subject="#arguments.subject#" type="#arguments.type#"
					server="#arguments.mailserver#" username="#arguments.mailusername#" password="#arguments.mailpassword#">#arguments.body#</cfmail>
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
</cfcomponent>