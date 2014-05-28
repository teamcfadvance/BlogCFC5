
<!--- Logic here determines what we are doing - getting entries, a entry, page, etc --->
<cf_getmode r_params="params">

<cfif not structKeyExists(params, "byalias")>

	<cfset entryData = application.entryService.getEntries(params)>
	<cfset previousLink = "">
	<cfset nextLink = "">

	<cfif (url.startRow gt 1) or (entryData.totalEntries gte url.startRow + application.settings.maxEntries)>

		<!--- get path if not /index.cfm --->
		<cfset path = rereplace(cgi.path_info, "(.*?)/index.cfm", "")>
		
		<!--- clean out startrow from query string --->
		<cfset qs = cgi.query_string>
		<!--- handle: http://www.coldfusionjedi.com/forums/messages.cfm?threadid=4DF1ED1F-19B9-E658-9D12DBFBCA680CC6 --->
		<cfset qs = reReplace(qs, "<.*?>", "", "all")>
		<cfset qs = reReplace(qs, "[\<\>]", "", "all")>
	
		<cfset qs = reReplaceNoCase(qs, "&*startrow=[\-0-9]+", "")>
		<cfif isDefined("form.search") and len(trim(form.search)) and not structKeyExists(url, "search")>
			<cfset qs = qs & "&amp;search=#htmlEditFormat(form.search)#">
		</cfif>
				
		<cfif url.startRow gt 1>
	
			<cfset prevqs = qs & "&amp;startRow=" & (url.startRow - application.settings..maxEntries)>
			<cfset previousLink = "#application.settings.blogurl#/#path#?#prevqs#">
				
		</cfif>

		<cfif entryData.totalEntries gte url.startRow + application.settings.maxEntries>
			
			<cfset nextqs = qs & "&amp;startRow=" & (url.startRow + application.settings.maxEntries)>
			<cfset nextLink = "#application.settings.blogurl#/#path#?#nextqs#">
		</cfif>
		
	</cfif>
	<cfset content = application.themeService.renderEntries(entryData,params.startrow,previousLink,nextLink)>

<cfelse>

	<cfset entryData = application.entryService.getEntries(params)>
	<cfset content = application.themeService.renderEntry(entryData)>

</cfif>

<cfset title = application.settings.blogtitle>

<cfoutput>#application.themeService.renderLayout(title,content)#</cfoutput>