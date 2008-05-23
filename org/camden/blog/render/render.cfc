<cfcomponent displayName="Render - Core Rendering CFC" output="false">

<cffunction name="renderDisplay" output="false">
	<cfargument name="string" required="false" default="">
	<cfset var md = getMetaData(this)>
	<cfset var x = "">
	
	<cfloop index="x" from="1" to="#arrayLen(md.functions)#">
		<cfif md.functions[x].name is "display">
			<cfset arguments.string = processTags(arguments.string, listLast(md.name,"."), "display")>
			<cfreturn arguments.string>
		</cfif>
	</cfloop>
	<!--- do nothing --->
	<cfreturn arguments.string>	
</cffunction>

<!---
I am passed a string, a tag, and a method to call.
I find all instances of your tag <xxx>, I get the args, 
and I call your method. What you return I replace in the string.
--->
<cffunction name="processTags">
	<cfargument name="string" required="true">
	<cfargument name="tag" required="true">
	<cfargument name="method" required="true">
	<cfset var result = "">
	<cfset var tags = getTags(arguments.string, arguments.tag)>
	<cfset var x = "">
	<cfset var key = "">
		
	<cfloop index="x" from="1" to="#arrayLen(tags)#">
		<!--- first, call method with args --->
		<cfinvoke method="#arguments.method#" returnVariable="result">
			<cfloop item="key" collection="#tags[x].args#">
				<cfinvokeargument name="#key#" value="#tags[x].args[key]#">
			</cfloop>
		</cfinvoke>
		<cfset arguments.string = replace(arguments.string, tags[x].match, trim(result))>
	</cfloop>
	
	<cfreturn arguments.string>
</cffunction>

<!---
The purpose of this function is to look in a string for all
cases of <XXX. It will return an array of structs such that each
struct has:
	POS: position of match
	LEN: len of match
	ARGS: A structure of arguments and values
		
So, I can say, getTags("amazon") and it could return
	
matches[1].pos=100
matches[1].len=221
matches[1].match=the match
matches[1].args[asin] = ....
matches[1].args[affiliate] = ...
--->
<cffunction name="getTags" output="false">
	<cfargument name="string" required="true">
	<cfargument name="tag" required="true">
	<cfset var result = arrayNew(1)>
	<cfset var matches = reFindAll("<#arguments.tag#.*?>", arguments.string)>
	<cfset var x = "">
	<cfset var argString = "">
	<cfset var argPair = "">
	<cfset var arg = "">
	<cfset var value = "">
	
	<cfif matches.pos[1] is not 0>
	
		<cfloop index="x" from="1" to="#arrayLen(matches.pos)#">
			<cfset result[arrayLen(result)+1] = structNew()>
			<cfset result[arrayLen(result)].pos = matches.pos[x]>
			<cfset result[arrayLen(result)].len = matches.len[x]>
			<cfset result[arrayLen(result)].match = mid(arguments.string, matches.pos[x], matches.len[x])>
			<cfset result[arrayLen(result)].args = structNew()>
			
			<cfset argString = replace(result[arrayLen(result)].match, "<#arguments.tag#","")>
			<cfset argString = replace(argString, "/>","")>
			<cfset argString = replace(argString, ">","")>
			<cfset argString = trim(argString)>
	
			<cfif len(argString)>
				<cfloop index="argPair" list="#argString#" delimiters=" ">
					<cfif listLen(argPair, "=") is 2>
						<cfset arg = listFirst(argPair, "=")>
						<cfset value = listLast(argPair, "=")>
						<cflog file="blogrender" text="arg=#arg#, value=#value#">
						<cfif value is """""">
							<cfset value = "">
						<cfelse>
							<cfif left(value, 1) is """">
								<cfset value = right(value, len(value)-1)>
							</cfif>
							<cfif right(value, 1) is """">
								<cfset value = left(value, len(value)-1)>
							</cfif>
						</cfif>
						<cfset result[arrayLen(result)].args[arg] = value>
					</cfif>
				</cfloop>
			</cfif>
			<cfset result[arrayLen(result)].argString = argString>
		</cfloop>

	</cfif>
	
	<cfreturn result>
</cffunction>

<!---
 Returns all the matches of a regular expression within a string.
 
 @param regex 	 Regular expression. (Required)
 @param text 	 String to search. (Required)
 @return Returns a structure. 
 @author Ben Forta (ben@forta.com) 
 @version 1, July 15, 2005 
--->
<cffunction name="reFindAll" output="true" returnType="struct">
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
      <cfset subex=reFind(arguments.regex, arguments.text, pos, true)>
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