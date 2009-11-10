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
	5/4/2008	1.0.6	Changed to use a StringBuilder (performance)
	5/23/2008	1.0.7	Fixed bug with end-of-line directly after html comments
	5/23/2008	1.0.8	Fixed bug when using multiple formatted strings in the same template
	5/27/2008	1.0.9	Made it works with older version of CF... not very happy about implementing the old syntax... may rewrite to use native CF functions...
	
	6/4/2008	1.0.12	Fixed cfsetting coloring defect, also replaced use of CharAt function as it throws if there is no character at that reference
	6/5/2009	2.0		ColdFiSH 2.0 with ActionScript and MXML support.
	
	--->
<cfcomponent output="false">
	<cffunction name="init" access="public" hint="This function initializes all of the variables needed for the component." output="false">
		<cfset initializeColors()/>
        <cfreturn this/>
    </cffunction>
    
    <cffunction name="initializeColors" access="private" returntype="void" hint="This function initializes all of the colors used for highlighting." output="false">
		<cfscript>
			variables.colors=structnew();
			variables.initialparser="";
			
			// Initialize styles for various types of elements
			//
			// Default text color that is outside a tag
			setStyle("TEXT","color:##000000");
			
			// Comments
			// Greyed out
			setStyle("HTMLCOMMENT","color:##AAAAAA");
			// Yellow highlight with black text
			setStyle("CFCOMMENT","color:##333333;background-color:##FFFF00");
			
			// Line Numbers
			setStyle("LINENUMBER","display:block;float:left;clear:left;width:2em;color:##333333;background-color:##ddd;text-align:right");
			
			// CF Tags
			setStyle("CFTAG","color:##990033");
			setStyle("CFSET","color:##000000");
			setStyle("SCRIPT","color:##000000");
			
			// HTML Tags
			setStyle("HTML","color:##000099");
			setStyle("HTMLSTYLES","color:##990099");
			setStyle("HTMLTABLES","color:##009999");
			setStyle("HTMLFORMS","color:##FF9900");
			
			// MXML Tags
			setStyle("MXML","color:##00F");
			setStyle("MXMLCOMMENT","color:##093");
			setStyle("MXMLATTRIBUTES","color:##000000");
			setStyle("MXMLVALUE","color:##900");
			
			// ACTIONSCRIPT
			setStyle("ACTIONSCRIPTTAG","color:##093");
			setStyle("ACTIONSCRIPT","color:##000");
			setStyle("ACTIONSCRIPTVALUE","color:##900");
			setStyle("ACTIONSCRIPTKEYWORD1","color:##00F");
			setStyle("ACTIONSCRIPTKEYWORD2","color:##093");
			setStyle("ACTIONSCRIPTKEYWORD3","color:##69C");
			
			// VALUES
			setStyle("VALUE","color:##0000CC");
			setStyle("SCRIPTVALUE","color:##006600");
			
			// BINDS
			setStyle("BIND","color:##000099");
		</cfscript>
    </cffunction>
    
    <cffunction name="initializeVariables" access="private" returntype="void" hint="This function initializes all of the variables needed for the component." output="false">
		<cfscript>
			//initialize a buffer
				
			// If you're using JDK 1.5 or later and want some extra performance this can be a StringBuilder
			//variables.buffer=createObject("java","java.lang.StringBuilder").init();
			variables.buffer=createObject("java","java.lang.StringBuffer").init();
			
			// initialize private variables
			variables.isCommented=false;
			variables.isTag=false;
			variables.isValue=false;
			variables.isCFSETTag=false;
			variables.isScript=false;
			variables.isOneLineComment=false;
			variables.isMXML=false;
			variables.isActionscript=false;
			initializeKeywordMap();
		</cfscript>
    </cffunction>
    
    <cffunction name="initializeKeywordMap" access="private" returntype="void" hint="This function initializes all of the variables needed for keyword searching." output="false">
    	<cfset variables.keywordmap = structnew()>
        <cfset variables.keywordmap.Actionscript = structnew()/>
        <cfset variables.keywordmap.Actionscript.list = arraynew(1)/>
        <cfset variables.keywordmap.Actionscript.style = arraynew(1)/>
        <cfset variables.keywordmap.Actionscript.list[1] = "as,break,case,catch,class,const,continue,default,delete,do,else,extends,false,finally,for,if,implements,import,in,instanceof,interface,internal,is,native,new,null,package,private,protected,public,return,super,switch,this,throw,to,true,try,typeof,use,void,while,with,each,get,set,namespace,include,dynamic,final,native,override,static,abstract,boolean,byte,cast,char,debugger,double,enum,export,float,goto,intrinsic,long,prototype,short,synchronized,throws,to,transient,type,virtual,volatile">
        <cfset variables.keywordmap.Actionscript.style[1] = "ACTIONSCRIPTKEYWORD1"/>
        <cfset variables.keywordmap.Actionscript.list[2] = "function">
        <cfset variables.keywordmap.Actionscript.style[2] = "ACTIONSCRIPTKEYWORD2"/>
        <cfset variables.keywordmap.Actionscript.list[3] = "var">
        <cfset variables.keywordmap.Actionscript.style[3] = "ACTIONSCRIPTKEYWORD3"/>
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
    <cffunction name="setInitialParser" access="public" hint="You can set the initial parser state with this.  This is helpful for scripts that make initial parsing impossible (ie. Script, Actionscript)" output="false">
		<cfset variables.initialparser = arguments[1]/>
    </cffunction>
    
	<cffunction name="formatString" access="public" hint="This function accepts a block of code and formats it into syntax highlighted HTML." output="false">
    	<cfargument name="code" type="string"/>
		<cfscript>
            var BIstream = createObject("java","java.io.StringBufferInputStream").init(code);
            var IStream = createObject("java","java.io.InputStreamReader").init(BIstream);
            var reader = createObject("java","java.io.BufferedReader").init(IStream);
            var line = reader.readLine();
			var linenumber = 0;
			initializeVariables();
			
			
			if (variables.initialparser neq "") {
				"variables.is#variables.initialparser#" = true;
			}
			
			bufferAppend("<span style='" & getStyle("TEXT") & "'>"); // start the default text color
			while (isdefined("line")) {
				linenumber = linenumber + 1;
                bufferAppend("<span style='" & getStyle("LINENUMBER") & "'>" & linenumber & "&nbsp;</span>&nbsp;");
				formatLine(line);
                line = reader.readLine();
            }
			bufferAppend("</span>");
			reader.close();

            return buffer;
        </cfscript>
	</cffunction>
    <cffunction name="formatFile" access="public" hint="This function accepts a file path, reads in the file and formats it into syntax highlighted HTML." output="false">
    	<cfargument name="filePath" type="string"/>
        <cfset var fileRead = "">
        <cffile action="read" file="#arguments.filepath#" variable="fileRead">
        <cfreturn formatString(fileRead)/>
	</cffunction>
	<cffunction name="formatLine" access="private" hint="This function takes a single line of code and formats it into syntax highlighted HTML." output="false">
    	<cfargument name="line" type="any"/>
        <cfscript>
			var character = "";
			var thisLine=arguments.line;
			var i =0;
			
			if (variables.isOneLineComment) endOneLineComment();
			
			for (i=0; i LT thisLine.length(); i=i+1)
			{
				character=thisLine.charAt(javacast('int',i));
				if (character EQ '<')
				{
					if (variables.isScript AND NOT variables.isValue)
						endScript();
					if (regionMatches(thisLine, 1, i+1, "!--", 0, 3))
					{
						if (regionMatches(thisLine, 1, i+4, "-", 0, 1))
						{
							startComment("CF");
						} else {
							startComment("HTML");
						}
					} else {
						if (regionMatches(thisLine, 1, i+1, "CF", 0, 2) OR regionMatches(thisLine, 1, i+1, "/CF", 0, 3))
						{
							startTag("CF");
							if (regionMatches(thisLine, 1, i+3, "SET", 0, 3) AND NOT regionMatches(thisLine, 1, i+6, "T", 0, 1)) // CFSET Tag
							{
								bufferAppend(substring(thisLine,i+1,i+6));
								i=i+5;
								startCFSET();
							}
							else if (regionMatches(thisLine, 1, i+3, "SCRIPT>", 0, 6)) // SCRIPT TAG
							{
								bufferAppend(substring(thisLine, i+1, i+9) & "&gt;");
								i=i+9;
								startScript();
							}
						}
						else if	(
								 	regionMatches(thisLine, 1, i+1, "TA", 0, 2) OR
									regionMatches(thisLine, 1, i+1, "/TA", 0, 3) OR
									regionMatches(thisLine, 1, i+1, "TB", 0, 2) OR
									regionMatches(thisLine, 1, i+1, "/TB", 0, 3) OR
									regionMatches(thisLine, 1, i+1, "TD", 0, 2) OR
									regionMatches(thisLine, 1, i+1, "/TD", 0, 3) OR
									regionMatches(thisLine, 1, i+1, "TF", 0, 2) OR
									regionMatches(thisLine, 1, i+1, "/TF", 0, 3) OR
									regionMatches(thisLine, 1, i+1, "TH", 0, 2) OR
									regionMatches(thisLine, 1, i+1, "/TH", 0, 3) OR
									regionMatches(thisLine, 1, i+1, "TR", 0, 2) OR
									regionMatches(thisLine, 1, i+1, "/TR", 0, 3)
								) // HTML TABLE
						{
							startTag("HTMLTABLES");
						}
						else if (regionMatches(thisLine, 1, i+1, "IMG", 0, 3) OR regionMatches(thisLine, 1, i+1, "STY", 0, 3) OR regionMatches(thisLine, 1, i+1, "/STY", 0, 4)) //IMG or STYLE Tag
						// TODO: Do separate syntax highlighting for stuff inside style
						{
							startTag("HTMLSTYLES");
						}
						else if (
									regionMatches(thisLine, 1, i+1, "FORM", 0, 4) OR
									regionMatches(thisLine, 1, i+1, "/FORM", 0, 5) OR
									regionMatches(thisLine, 1, i+1, "INPUT", 0, 5) OR
									regionMatches(thisLine, 1, i+1, "/INPUT", 0, 5) OR
									regionMatches(thisLine, 1, i+1, "TEXT", 0, 4) OR
									regionMatches(thisLine, 1, i+1, "/TEXT", 0, 5) OR
									regionMatches(thisLine, 1, i+1, "SELECT", 0, 6) OR
									regionMatches(thisLine, 1, i+1, "/SELECT", 0, 7) OR
									regionMatches(thisLine, 1, i+1, "OPT", 0, 3) OR
									regionMatches(thisLine, 1, i+1, "/OPT", 0, 3)
								)
						{
							startTag("HTMLFORMS");
						}
						else if (
								 	regionMatches(thisLine, 1, i+1, "MX:", 0, 3) OR
									regionMatches(thisLine, 1, i+1, "/MX:", 0, 4)
								)
						{
							if (regionMatches(thisLine, 1, i+4, "SCRIPT>", 0, 6)) // SCRIPT TAG
							{
								startTag("ACTIONSCRIPTTAG");
								bufferAppend(substring(thisLine, i+1, i+10) & "&gt;");
								i=i+10;
								startActionscript();
							} else {
								startTag("MXML");
								endpos=find(' ',thisLine);
								//bufferAppend(endpos);
								if (endpos EQ 1) {
									endpos=find('>',thisLine);
								}
								try {
									bufferAppend(substring(thisLine,i+1,endpos));
									i=i+endpos;
								} catch(Any e) {
									bufferAppend(substring(thisLine,i+1,len(thisLine)-i));
									i=len(thisLine)-i;
								}
								
								startMXMLTag();		
							}
						} else {
							if (variables.isActionscript) {
								if (not regionMatches(thisLine, 1, i+1, "![CDATA", 0, 6)) {
									endActionscript();
								}
								bufferAppend("&lt;");
							} else {
								startTag("HTML");
							}
						}
					}
				}
				else if (character EQ '>')
				{
					if (variables.isCommented AND regionMatches(thisLine, 1, i-2, "--", 0, 2))
					{
						if (regionMatches(thisLine, 1, i-3, "-", 0, 1))
						{
							endComment("CF");
						} else {
							endComment("HTML");
						}
					} else {
						if (variables.isCFSETTag) {
							endCFSET();
						} else if (variables.isMXML) {
							endMXMLTag();
						} else {
							endTag();
						}
					}
				}
				else if (character EQ '"')
				{
					if (variables.isTag OR variables.isScript OR variables.isActionscript)
					{
						if (NOT variables.isValue) {
							startValue();
							bufferAppend('"');
						} else {
							bufferAppend('"');
							endValue();
						}
					} else {
						bufferAppend('"');
					}
				}
				else if (character EQ '{')
				{
					startBind();
					bufferAppend("{");
					endBind();
				}
				else if (character EQ '}')
				{
					startBind();
					bufferAppend("}");
					endBind();
				}
				else if (character EQ '/')
				{
					if ((variables.isScript OR variables.isActionscript) AND regionMatches(thisLine, 1, i+1, "/", 0, 1) AND NOT variables.isCommented)
					{
						if (variables.isActionscript) {
							startOneLineComment("MXMLCOMMENT");
						} else {
							startOneLineComment("HTMLCOMMENT");
						}
					}
					else if (variables.isCommented)
					{
						if (regionMatches(thisLine, 1, i-1, "*", 0, 1))
						{
							endComment("SCRIPT");
						} else {
							bufferAppend("/");
						}
					} else {
						if (regionMatches(thisLine, 1, i+1, "*", 0, 1))
						{
							startComment("SCRIPT");
						} else {
							bufferAppend("/");
						}
					}
				}
				
				// straight up replacements
				else if (character EQ '\t' OR character EQ '	')
				{
					bufferAppend("&nbsp;&nbsp;&nbsp;&nbsp;");
				}
				else if (character EQ ' ')
				{
					 bufferAppend("&##32;");
				} else {
					if (not variables.isCommented AND not variables.isValue) {
						keywordskip = keywordsearch(thisLine,i);
						if (keywordskip) {
							i = i + keywordskip;
						} else {
							bufferAppend(character.toString());
						}
					} else {
						bufferAppend(character.toString());
					}
				}
			}
			bufferAppend("<br />");
		</cfscript>
    </cffunction>
    <cffunction name="regionMatches" access="private" hint="This function checks if a regionMatches." output="false">
		<cfargument name="string1" type="any"/>
        <cfargument name="caseInsensitive" type="boolean" default="true"/>
        <cfargument name="startPosition1" type="numeric"/>
        <cfargument name="string2" type="any"/>
        <cfargument name="startPosition2" type="numeric"/>
        <cfargument name="endPosition2" type="numeric"/>
		<cfreturn arguments.string1.regionMatches(arguments.caseInsensitive, javacast('int',arguments.startPosition1), arguments.string2, javacast('int',arguments.startPosition2), javacast('int',arguments.endPosition2))/>
    </cffunction>
    <cffunction name="substring" access="private" hint="This function gets a substring from a line." output="false">
		<cfargument name="string" type="any"/>
        <cfargument name="startPosition" type="numeric"/>
        <cfargument name="endPosition" type="numeric"/>
		<cfreturn arguments.string.substring(javacast('int',arguments.startPosition), javacast('int',arguments.endPosition))/>
    </cffunction>
    <cffunction name="bufferAppend" access="private" hint="This function appends the buffer." output="false">
        <cfargument name="string" type="string"/>
		<cfreturn variables.buffer.append(arguments.string)/>
    </cffunction>
    <cffunction name="keywordsearch" access="private" hint="This function searches for keywords." output="false">
    	<cfargument name="thisLine" type="any"/>
        <cfargument name="i" type="numeric"/>
        <cfset var keywordmap = ""/>
		<cfif isActionscript>
        	<cfset keywordmap = variables.keywordmap.Actionscript/>
        </cfif>
        <cfif isStruct(keywordmap)>
            <cfloop from="1" to="#ArrayLen(keywordmap.list)#" index="keywordarray">
                <cfloop list="#keywordmap.list[keywordarray]#" index="keyword">
                    <cfif regionMatches(thisLine, 1, i, keyword & ' ', 0, keyword.length()+1)>
                        <cfset bufferAppend("<span style='" & getStyle(keywordmap.style[keywordarray]) & "'>" & keyword & "</span>&nbsp;")/>
                        <cfreturn keyword.length()/>
                    </cfif>
                </cfloop>
            </cfloop>
		</cfif>
        <cfreturn 0/>
    </cffunction>
    <cffunction name="startHighlight" access="private" hint="" output="false">
    	<cfargument name="element" type="string"/>
		<cfset bufferAppend("<span style='" & variables.colors[arguments.element]& "'>")/>
    </cffunction>
    <cffunction name="endHighlight" access="private" hint="" output="false">
		<cfargument name="line" type="any"/>
		<cfset bufferAppend("</span>")/>
    </cffunction>
    <cffunction name="startOneLineComment" access="private" output="false">
    	<cfargument name="type" type="string"/>
		<cfscript>
		startHighlight(type);
		bufferAppend("/");
		variables.isOneLineComment=true;
		variables.isCommented=true;
		</cfscript>	
    </cffunction>
    <cffunction name="endOneLineComment" access="private" output="false">
    	<cfscript>
		endHighlight();
		variables.isOneLineComment=false;
		variables.isCommented=false;
		</cfscript>	
    </cffunction>
	<cffunction name="startComment" access="private" output="false">
    	<cfargument name="type" type="string"/>
        <cfscript>
		if (type  EQ  "CF") {
			startHighlight("CFCOMMENT");
			bufferAppend("&lt;");
		} else if (type  EQ  "HTML") {
			startHighlight("HTMLCOMMENT");
			bufferAppend("&lt;");
		} else if (type  EQ  "SCRIPT") {
			startHighlight("HTMLCOMMENT");
			bufferAppend("/");
		}
		variables.isCommented=true;
		</cfscript>
    </cffunction>
	<cffunction name="endComment" access="private" output="false">
    	<cfargument name="type" type="string"/>
        <cfscript>
		if (type  EQ  "SCRIPT") {
			bufferAppend("/");
		} else {
			bufferAppend("&gt;");
		}
		endHighlight();
		variables.isCommented=false;
		</cfscript>
    </cffunction>
	<cffunction name="startTag" access="private" output="false">
    	<cfargument name="type" type="string"/>
        <cflog text="Starting TAG #TYPE#">
		<cfscript>
		if (NOT variables.isCommented AND NOT variables.isValue) {
			if (type  EQ  "CF") {
				startHighlight("CFTAG");
			} else if (type  EQ  "HTMLSTYLES") {
				startHighlight("HTMLSTYLES");
			} else if (type  EQ  "HTMLTABLES") {
				startHighlight("HTMLTABLES");
			} else if (type  EQ  "HTMLFORMS") {
				startHighlight("HTMLFORMS");
			} else if (type EQ "MXML") {
				startHighlight("MXML");
			} else if (type EQ "ACTIONSCRIPTTAG") {
				startHighlight("ACTIONSCRIPTTAG");
			} else { // type is HTML
				startHighlight("HTML");
			}
			variables.isTag=true;
		}
		bufferAppend("&lt;");
		</cfscript>
    </cffunction>
	<cffunction name="endTag" access="private" output="false">
    	<cflog text="Ending Tag"/>
		<cfscript>
		bufferAppend("&gt;");
		if (NOT variables.isCommented AND NOT variables.isValue) {
			endHighlight();
			variables.isTag=false;
		}
		</cfscript>
    </cffunction>
	<cffunction name="startValue" access="private" output="false">
    	<cfscript>
		if (NOT variables.isCommented) {
			if (variables.isCFSETTag OR variables.isScript) {
				startHighlight("SCRIPTVALUE");
			} else if (variables.isActionscript) {
				startHighlight("ACTIONSCRIPTVALUE");
			} else if (variables.isMXML) {
				startHighlight("MXMLVALUE");
			} else {
				startHighlight("VALUE");
			}
			variables.isValue=true;
		}
		</cfscript>
    </cffunction>
	<cffunction name="endValue" access="private" output="false">
    	<cfscript>
		if (NOT variables.isCommented) {
			endHighlight();
			variables.isValue=false;
		}
		</cfscript>
	</cffunction>
	<cffunction name="startBind" access="private" output="false">
    	<cfscript>
		if (NOT variables.isCommented) {
			startHighlight("BIND");
			bindDef=true;
		}
		</cfscript>
    </cffunction>
	<cffunction name="endBind" access="private" output="false">
    	<cfscript>
		if (NOT variables.isCommented) {
			endHighlight();
			bindDef=false;
		}
		</cfscript>
	</cffunction>
	<cffunction name="startCFSET" access="private" output="false">
    	<cfscript>
		if (NOT variables.isCommented) {
			startHighlight("CFSET");
			variables.isCFSETTag=true;
		}
		</cfscript>
    </cffunction>
	<cffunction name="endCFSET" access="private" output="false">
    	<cfscript>
		if (NOT variables.isCommented) {
			endHighlight();
			bufferAppend("&gt;");
			endHighlight();
			variables.isCFSETTag=false;
		} else {
			bufferAppend("&gt;");
		}
		</cfscript>
    </cffunction>
    <cffunction name="startMXMLTag" access="private" output="false">
    	<cflog text="Starting MXML Tag">
		<cfscript>
		if (NOT variables.isCommented) {
			startHighlight("MXMLATTRIBUTES");
			setStyle("VALUE","color:##900");
			variables.isMXML=true;
		}
		</cfscript>
    </cffunction>
	<cffunction name="endMXMLTag" access="private" output="false">
    	<cflog text="Ending MXML Tag">
		<cfscript>
		if (NOT variables.isCommented) {
			endHighlight();
			bufferAppend("&gt;");
			endHighlight();
			variables.isMXML=false;
		} else {
			bufferAppend("&gt;");
		}
		</cfscript>
    </cffunction>
	<cffunction name="startScript" access="private" output="false">
    	<cflog text="Starting SCRIPT">
		<cfscript>
		if (NOT variables.isCommented) {
			endHighlight();
			startHighlight("SCRIPT");
			variables.isScript=true;
		}
		</cfscript>
	</cffunction>
	<cffunction name="endScript" access="private" output="false">
    	<cflog text="Ending Script">
    	<cfscript>
		if (NOT variables.isCommented) {
			endHighlight();
			variables.isScript=false;
		}
		</cfscript>
	</cffunction>
    <cffunction name="startActionscript" access="private" output="false">
    	<cflog text="Starting ACTIONSCRIPT">
		<cfscript>
		if (NOT variables.isCommented) {
			endHighlight();
			startHighlight("ACTIONSCRIPT");
			variables.isActionscript=true;
		}
		</cfscript>
	</cffunction>
	<cffunction name="endActionscript" access="private" output="false">
    	<cflog text="Ending ACTIONSCRIPT">
		<cfscript>
		if (NOT variables.isCommented) {
			endHighlight();
			variables.isActionscript=false;
		}
		</cfscript>
	</cffunction>
</cfcomponent>