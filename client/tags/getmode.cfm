<!---
	Name         : c:\projects\blog\client\tags\getmode.cfm
	Author       : Raymond Camden 
	Created      : 02/09/06
	Last Updated : 4/13/07
	History      : Removed date filter (rkc 10/28/06)
				 : Put it back in (rkc 10/30/06)
				 : releasedonly (rkc 4/13/07)
--->


<cfparam name="url.mode" default="">
<cfparam name="attributes.r_params" type="variableName">

<cfset params = structNew()>
<!--- 
	  SES parsing is abstracted out. This file is getting a bit large so I want to keep things nice and simple.
	  Plus if folks don't like this, they can just get rid of it.
	  Of course, the Blog makes use of it... but I'll worry about that later.
--->
<cfmodule template="parseses.cfm" />

<!--- starting index --->
<cfparam name="url.startrow" default="1">
<cfif not isNumeric(url.startrow) or url.startrow lte 0 or round(url.startrow) neq url.startrow>
	<cfset url.startrow = 1>
</cfif>
<!--- handle people passing super big #s --->
<cfif application.isColdFusionMX7 and not isValid("integer", url.startrow)>
	<cfset url.startrow = 1>
</cfif>
<cfset params.startrow = url.startrow>
<cfset params.maxEntries = application.maxEntries>

<!--- Handle cleaning of day, month, year --->
<cfif isDefined("url.day") and (not isNumeric(url.day) or val(url.day) is not url.day)>
	<cfset structDelete(url,"day")>
</cfif>
<cfif isDefined("url.month") and (not isNumeric(url.month) or val(url.month) is not url.month)>
	<cfset structDelete(url,"month")>
</cfif>
<cfif isDefined("url.year") and (not isNumeric(url.year) or val(url.year) is not url.year)>
	<cfset structDelete(url,"year")>
</cfif>

<cfif url.mode is "day" and isDefined("url.day") and isDefined("url.month") and url.month gte 1 and url.month lte 12 and isDefined("url.year")>
	<cfset params.byDay = val(url.day)>
	<cfset params.byMonth = val(url.month)>
	<cfset params.byYear = val(url.year)>
	<cfset month = val(url.month)>
	<cfset year = val(url.year)>
<cfelseif url.mode is "month" and isDefined("url.month") and url.month gte 1 and url.month lte 12 and isDefined("url.year")>
	<cfset params.byMonth = val(url.month)>
	<cfset params.byYear = val(url.year)>
	<cfset month = val(url.month)>
	<cfset year = val(url.year)>
<cfelseif url.mode is "cat" and isDefined("url.catid")>
	<cfset params.byCat = url.catid>
<cfelseif url.mode is "search" and (isDefined("form.search") or isDefined("url.search"))>
	<cfif isDefined("url.search")>
		<cfset form.search = url.search>
	</cfif>
	<cfset params.searchTerms = htmlEditFormat(form.search)>
	<!--- dont log pages --->
	<cfif url.startrow neq 1>
		<cfset params.dontlogsearch = true>
	</cfif>
<cfelseif url.mode is "entry" and isDefined("url.entry")>
	<cfset params.byEntry = url.entry>
<cfelseif url.mode is "alias" and isDefined("url.alias") and len(trim(url.alias))>
	<cfset params.byAlias = url.alias>
<cfelse>
	<cfset url.mode = "">
</cfif>

<!--- 
	Released only. Ensures admins wont see unreleased on main page.
--->
<cfset params.releasedonly = true>

<cfset caller[attributes.r_params] = params>

<cfexit method="exitTag">
