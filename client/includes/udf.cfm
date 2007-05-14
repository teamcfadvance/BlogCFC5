<cfscript>
function titleCase(str) {
	return uCase(left(str,1)) & right(str,len(str)-1);
}

/**
 * Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
 * Update by David Kearns to support '
 * SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
 * 
 * @param str 	 The string to check. (Required)
 * @return Returns a boolean. 
 * @author Jeff Guillaume (jeff@kazoomis.com) 
 * @version 2, August 15, 2002 
 */
function IsEmail(str) {
        //supports new top level tlds
if (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$",str)) return TRUE;
	else return FALSE;
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
