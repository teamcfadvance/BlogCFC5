<cfset cats = application.entryService.getCategories()>
<cfloop query="cats">
	<cfoutput><a href="#application.entryService.makeCategoryLink(categoryid)#" title="#categoryName# RSS">#categoryName# (#entryCount#)</a> [<a href="#application.settings.rootURL#/rss.cfm?mode=full&amp;mode2=cat&amp;catid=#categoryid#" rel="noindex,nofollow">RSS</a>]<br /></cfoutput>
</cfloop>
