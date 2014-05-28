<cfset cats = application.entryService.getCategories()>
<cfloop query="cats">
	<cfif entryCount gt 50>
		<cfoutput><a href="#application.entryService.makeCategoryLink(categoryid)#" title="#categoryName# RSS">#categoryName# (#entryCount#)</a> [<a href="#application.settings.rootURL#/rss.cfm?mode=full&amp;mode2=cat&amp;catid=#categoryid#" rel="noindex,nofollow">RSS</a>]<br /></cfoutput>
	</cfif>
</cfloop>
<cfoutput>yo i made you at #now()#</cfoutput>
