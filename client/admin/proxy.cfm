<cfsetting enablecfoutputonly=true showdebugoutput=false>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\proxy.cfm
	Author       : Raymond Camden 
	Created      : 11/2/09
	Last Updated : 
--->

<cfif structKeyExists(url, "category") or structKeyExists(url, "text")>

	<cfset params = structNew()>
	<cfif structKeyExists(url, "category") and len(url.category)>
		<cfset params.byCat = url.category>
	</cfif>
	<cfif structKeyExists(url, "text") and len(url.text)>
		<cfset params.searchterms = url.text>
	</cfif>
	<cfset params.mode = "short">
	<cfset params.maxEntries = 200>
	<cfset entryData = application.blog.getEntries(params)>
	<cfset entries = entryData.entries>
	<cfquery name="entries" dbtype="query">
	select	id, title, posted
	from	entries
	</cfquery>

	<cfset s = createObject('java','java.lang.StringBuffer')>
	
	<!--- hand craft the json myself, still supporting cf7 --->
	<cfset s.append("{")>

	<cfloop query="entries">
		<cfset s.append("""#id#"":""#htmlEditFormat(title)#"",")>
	</cfloop>

	<cfset s.append("}")>
	<cfoutput>#s.toString()#</cfoutput>
</cfif>