<!---
	Copyright 2008 Jason Delmore
    All rights reserved.
    jason@cfinsider.com
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License (LGPL) as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
	--->
<!---
	
	History		Build	Notes
	2/24/2008	1.0		Created by Jason Delmore
	2/27/2008	1.0.1	Fixed defect when trying to append special characters
						Fixed issues with form elements and simplified some of the logic
	5/4/2008			Changed to use a StringBuilder (performance)
	
	--->
<cfcomponent output="false">
	<cffunction name="init" access="public" hint="This function initializes all of the variables needed for the component." output="false">
		<cfscript>
			//initialize a buffer
				
			// If you're not using JDK 1.5 or later, then this needs to be a StringBuffer	//variables.buffer=createObject("java","java.lang.StringBuffer").init();

			variables.buffer=createObject("java","java.lang.StringBuilder").init();
			
			// initialize private variables
			variables.isCommented=false;
			variables.isTag=false;
			variables.isValue=false;
			variables.isCFSETTag=false;
			variables.isScript=false;
			variables.isOneLineComment=false;
			variables.colors=structnew();
			
			
			// Initialize styles for various types of elements
			//
			// Default text color that is outside a tag
			setStyle("TEXT","color:##000000");
			
			// Comments
			// Greyed out
			setStyle("HTMLCOMMENT","color:##AAAAAA");
			// Yellow highlight with black text
			setStyle("CFCOMMENT","color:##333333;background-color:##FFFF00");
			
			// CF Tags
			setStyle("CFTAG","color:##990033");
			setStyle("CFSET","color:##000000");
			setStyle("SCRIPT","color:##000000");
			
			// HTML Tags
			setStyle("HTML","color:##000099");
			setStyle("HTMLSTYLES","color:##990099");
			setStyle("HTMLTABLES","color:##009999");
			setStyle("HTMLFORMS","color:##FF9900");
			
			// VALUES
			setStyle("VALUE","color:##0000CC");
			setStyle("SCRIPTVALUE","color:##006600");
			
			// BINDS
			setStyle("BIND","color:##000099");
		</cfscript>
        <cfreturn this/>
    </cffunction>
    <cffunction name="getStyle" access="public" hint="This function can be used to get the style used in conjunction with a type of language element." output="false">
    	<cfargument name="element" type="string"/>
		<cfreturn variables.colors[arguments.element]/>
    </cffunction>
    <cffunction name="setStyle" access="public" hint="This function can be used to set the style used in conjunction with a type of language element.  The value submitted should be a valid CSS black; (i.e. 'color:black;background-color:yellow;')" output="false">
    	<cfargument name="element" type="string"/>
        <cfargument name="style" type="string"/>
        <cfset variables.colors[arguments.element]=arguments.style/>
    </cffunction>
    <cffunction name="getStyles" access="public" hint="This function returns all of the styles used for each type of language element." output="false">
		<cfreturn variables.colors/>
    </cffunction>
    
	<cffunction name="formatString" access="public" hint="This function accepts a block of code and formats it into syntax highlighted HTML." output="false">
    	<cfargument name="code" type="string"/>
		<cfscript>
            var BIstream = createObject("java","java.io.StringBufferInputStream").init(code);
            var IStream = createObject("java","java.io.InputStreamReader").init(BIstream);
            var reader = createObject("java","java.io.BufferedReader").init(IStream);
            var line = reader.readLine();
			var i =0;
			
			variables.buffer=createObject("java","java.lang.StringBuilder").init();
			
			buffer.append("<span style='" & getStyle("TEXT") & "'>"); // start the default text color
			while (isdefined("line")) {
                formatLine(line);
                line = reader.readLine();
            }
			buffer.append("</span>");
			reader.close();
			for (i=0;i<10;i++) {
				buffer.append("</span>");
			} // end the span a bunch of times just in case...

            return buffer;
        </cfscript>
	</cffunction>
    <cffunction name="formatFile" access="public" hint="This function accepts a file path, reads in the file and formats it into syntax highlighted HTML." output="false">
    	<cfargument name="filePath" type="string"/>
        <cfreturn formatString(fileRead(arguments.filepath))/>
	</cffunction>
	<cffunction name="formatLine" access="private" hint="This function takes a single line of code and formats it into syntax highlighted HTML." output="false">
    	<cfargument name="line" type="any"/>
        <cfscript>
			var character = "";
			var thisLine=arguments.line;
			var i =0;
			
			if (variables.isOneLineComment) endOneLineComment();
			
			for (i=0; i<thisLine.length(); i++)
			{
				character=thisLine.charAt(i);
				if (character=='<')
				{
					if (variables.isScript && !variables.isValue)
						endScript();
					if (thisLine.regionMatches(1, i+1, "!--", 0, 3))
					{
						if (thisLine.regionMatches(1, i+4, "-", 0, 1))
						{
							startComment("CF");
						} else {
							startComment("HTML");
						}
					} else {
						if (thisLine.regionMatches(1, i+1, "CF", 0, 2) || thisLine.regionMatches(1, i+1, "/CF", 0, 3))
						{
							startTag("CF");
							if (thisLine.regionMatches(1, i+3, "SET", 0, 3)) // CFSET Tag
							{
								buffer.append(thisLine.substring(i+1,i+6));
								i=i+5;
								startCFSET();
							}
							else if (thisLine.regionMatches(1, i+3, "SCRIPT>", 0, 6)) // SCRIPT TAG
							{
								buffer.append(thisLine.substring(i+1,i+9) & "&gt;");
								i=i+9;
								startScript();
							}
						}
						else if	((thisLine.charAt(i+1) == "T" && listfindnocase("A,B,D,F,H,R", thisLine.charAt(i+2))) || (thisLine.charAt(i+1) == "/" && (thisLine.charAt(i+2) == "T" && listfindnocase("A,B,D,F,H,R", thisLine.charAt(i+3))))) // HTML TABLE
						{
							startTag("HTMLTABLES");
						}
						else if (thisLine.regionMatches(1, i+1, "IMG", 0, 3) || thisLine.regionMatches(1, i+1, "STY", 0, 3) || thisLine.regionMatches(1, i+1, "/STY", 0, 4)) //IMG or STYLE Tag
						// TODO: Do separate syntax highlighting for stuff inside style
						{
							startTag("HTMLSTYLES");
						}
						else if (
									thisLine.regionMatches(1, i+1, "FORM", 0, 4) ||
									thisLine.regionMatches(1, i+1, "/FORM", 0, 5) ||
									thisLine.regionMatches(1, i+1, "INPUT", 0, 5) ||
									thisLine.regionMatches(1, i+1, "/INPUT", 0, 5) ||
									thisLine.regionMatches(1, i+1, "TEXT", 0, 4) ||
									thisLine.regionMatches(1, i+1, "/TEXT", 0, 5) ||
									thisLine.regionMatches(1, i+1, "SELECT", 0, 6) ||
									thisLine.regionMatches(1, i+1, "/SELECT", 0, 7) ||
									thisLine.regionMatches(1, i+1, "OPT", 0, 3) ||
									thisLine.regionMatches(1, i+1, "/OPT", 0, 3)
								)
						{
							startTag("HTMLFORMS");
						} else {
							startTag("HTML");
						}
					}
				}
				else if (character=='>')
				{
					if (variables.isCommented && thisLine.regionMatches(1, i-2, "--", 0, 2))
					{
						if (thisLine.charAt(i-3)=='-')
						{
							endComment("CF");
						} else {
							endComment("HTML");
						}
					} else {
						if (variables.isCFSETTag) {
							endCFSET();
						} else {
							endTag();
						}
					}
				}
				else if (character=='"')
				{
					if (variables.isTag || variables.isScript)
					{
						if (!variables.isValue) {
							startValue();
							buffer.append('"');
						} else {
							buffer.append('"');
							endValue();
						}
					} else {
						buffer.append('"');
					}
				}
				else if (character=='{')
				{
					startBind();
					buffer.append("{");
					endBind();
				}
				else if (character=='}')
				{
					startBind();
					buffer.append("}");
					endBind();
				}
				else if (character=='/')
				{
					if (variables.isScript && i != thisLine.length()-1 && thisLine.charAt(i+1)=='/') 					{
						startOneLineComment();
					}
					else if (variables.isCommented)
					{
						if (thisLine.charAt(i-1)=='*')
						{
							endComment("SCRIPT");
						} else {
							buffer.append("/");
						}
					} else {
						if (thisLine.charAt(i+1)=='*')
						{
							startComment("SCRIPT");
						} else {
							buffer.append("/");
						}
					}
				}
				
				// straight up replacements
				else if (character=='\t' || character=='	')
				{
					buffer.append("&nbsp;&nbsp;&nbsp;&nbsp;");
				}
				else if (character==' ')
				{
					 buffer.append("&##32;");
				} else {
					buffer.append(character.toString());
				}
			}
			buffer.append("<br />");
		</cfscript>
    </cffunction>
    <cffunction name="startHighlight" access="private" hint="" output="false">
    	<cfargument name="element" type="string"/>
		<cfset buffer.append("<span style='" & variables.colors[arguments.element]& "'>")/>
    </cffunction>
    <cffunction name="endHighlight" access="private" hint="" output="false">
		<cfargument name="line" type="any"/>
		<cfset buffer.append("</span>")/>
    </cffunction>
    <cffunction name="startOneLineComment" access="private" output="false">
    	<cfargument name="line" type="any"/>
		<cfscript>
		startHighlight("HTMLCOMMENT");
		buffer.append("/");
		variables.isOneLineComment=true;
		variables.isCommented=true;
		</cfscript>	
    </cffunction>
    <cffunction name="endOneLineComment" access="private" output="false">
    	<cfargument name="line" type="any"/>
		<cfscript>
		endHighlight();
		variables.isOneLineComment=false;
		variables.isCommented=false;
		</cfscript>	
    </cffunction>
	<cffunction name="startComment" access="private" output="false">
    	<cfargument name="type" type="string"/>
        <cfscript>
		if (type == "CF") {
			startHighlight("CFCOMMENT");
			buffer.append("&lt;");
		} else if (type == "HTML") {
			startHighlight("HTMLCOMMENT");
			buffer.append("&lt;");
		} else if (type == "SCRIPT") {
			startHighlight("HTMLCOMMENT");
			buffer.append("/");
		}
		variables.isCommented=true;
		</cfscript>
    </cffunction>
	<cffunction name="endComment" access="private" output="false">
    	<cfargument name="type" type="string"/>
        <cfscript>
		if (type == "SCRIPT") {
			buffer.append("/");
		} else {
			buffer.append("&gt;");
		}
		endHighlight();
		variables.isCommented=false;
		</cfscript>
    </cffunction>
	<cffunction name="startTag" access="private" output="false">
    	<cfargument name="type" type="string"/>
        <cfscript>
		if (!variables.isCommented && !variables.isValue) {
			if (type == "CF") {
				startHighlight("CFTAG");
			} else if (type == "HTMLSTYLES") {
				startHighlight("HTMLSTYLES");
			} else if (type == "HTMLTABLES") {
				startHighlight("HTMLTABLES");
			} else if (type == "HTMLFORMS") {
				startHighlight("HTMLFORMS");
			} else { // type is HTML
				startHighlight("HTML");
			}
			variables.isTag=true;
		}
		buffer.append("&lt;");
		</cfscript>
    </cffunction>
	<cffunction name="endTag" access="private" output="false">
    	<cfscript>
		buffer.append("&gt;");
		if (!variables.isCommented && !variables.isValue) {
			endHighlight();
			variables.isTag=false;
		}
		</cfscript>
    </cffunction>
	<cffunction name="startValue" access="private" output="false">
    	<cfscript>
		if (!variables.isCommented) {
			if (variables.isCFSETTag || variables.isScript) {
				startHighlight("SCRIPTVALUE");
			} else {
				startHighlight("VALUE");
			}
			variables.isValue=true;
		}
		</cfscript>
    </cffunction>
	<cffunction name="endValue" access="private" output="false">
    	<cfscript>
		if (!variables.isCommented) {
			endHighlight();
			variables.isValue=false;
		}
		</cfscript>
	</cffunction>
	<cffunction name="startBind" access="private" output="false">
    	<cfscript>
		if (!variables.isCommented) {
			startHighlight("BIND");
			bindDef=true;
		}
		</cfscript>
    </cffunction>
	<cffunction name="endBind" access="private" output="false">
    	<cfscript>
		if (!variables.isCommented) {
			endHighlight();
			bindDef=false;
		}
		</cfscript>
	</cffunction>
	<cffunction name="startCFSET" access="private" output="false">
    	<cfscript>
		if (!variables.isCommented) {
			startHighlight("CFSET");
			variables.isCFSETTag=true;
		}
		</cfscript>
    </cffunction>
	<cffunction name="endCFSET" access="private" output="false">
    	<cfscript>
		if (!variables.isCommented) {
			endHighlight();
			buffer.append("&gt;");
			endHighlight();
			variables.isCFSETTag=false;
		} else {
			buffer.append("&gt;");
		}
		</cfscript>
    </cffunction>
	<cffunction name="startScript" access="private" output="false">
    	<cfscript>
		if (!variables.isCommented) {
			endHighlight();
			startHighlight("SCRIPT");
			variables.isScript=true;
		}
		</cfscript>
	</cffunction>
	<cffunction name="endScript" access="private" output="false">
    	<cfscript>
		if (!variables.isCommented) {
			endHighlight();
			variables.isScript=false;
		}
		</cfscript>
	</cffunction>
</cfcomponent>