<cfsetting enablecfoutputonly=true showdebugoutput=false>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\spryproxy.cfm
	Author       : Raymond Camden 
	Created      : 07/11/06
	Last Updated : 07/16/06
	History      : two changes in relation to differences in bd.net. (rkc 7/16/06)
--->

<cffunction name="queryToXML" returnType="string" access="public" output="false" hint="Converts a query to XML">
	<cfargument name="data" type="query" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">
	<cfargument name="cDataCols" type="string" required="false" default="">
	
	<cfset var s = createObject('java','java.lang.StringBuffer')>
	
	<cfset var col = "">
	<cfset var columns = arguments.data.columnlist>
	<cfset var txt = "">

	<cfset s.append("<?xml version=""1.0"" encoding=""UTF-8""?>")>
	<cfset s.append("<#arguments.rootelement#>")>
	
	<cfloop query="arguments.data">
		<cfset s.append("<#arguments.itemelement#>")>

		<cfloop index="col" list="#columns#">
			<cfset txt = arguments.data[col][currentRow]>
			<cfif isSimpleValue(txt)>
				<cfif listFindNoCase(arguments.cDataCols, col)>
					<cfset txt = "<![CDATA[" & txt & "]]" & ">">
				<cfelse>
					<cfset txt = xmlFormat(txt)>
				</cfif>
			<cfelse>
				<cfset txt = "">
			</cfif>

			<cfset s.append("<#ucase(col)#>#txt#</#ucase(col)#>")>

		</cfloop>
		
		<cfset s.append("</#arguments.itemelement#>")>	
	</cfloop>
	
	<cfset s.append("</#arguments.rootelement#>")>
	
	<cfif structKeyExists(server, "bluedragon")>
		<cfreturn toString(s.toString())>
	<cfelse>
		<cfreturn s.toString()>
	</cfif>
</cffunction>

<cfparam name="url.method" default="">

<cfswitch expression="#url.method#">

	<cfcase value="getcategories">
		<cfset categories = application.blog.getCategories()>
        <cfcontent type="text/xml; charset=utf-8"><cfoutput>#queryToXML(categories, "categories", "category")#</cfoutput>
	</cfcase>

	<cfcase value="getentries">
		<cfif structKeyExists(url, "category")>
			<cfset params = structNew()>
			<cfset params.byCat = url.category>
			<cfset params.mode = "short">
			<cfset params.maxEntries = 9999999>
			<cfset entryData = application.blog.getEntries(params)>
			<cfset entries = entryData.entries>
			<cfquery name="entries" dbtype="query">
			select	id, title, posted
			from	entries
			</cfquery>
	        <cfcontent type="text/xml; charset=utf-8"><cfoutput>#queryToXML(entries, "entries", "entry")#</cfoutput>
	
		</cfif>
	</cfcase>
	
</cfswitch>

<cfsetting enablecfoutputonly=false>