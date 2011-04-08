
<!---
	articles may be defined if this was included in index file on initial load
--->
<cfif not IsDefined('articles')>
	<cfparam name="url.page" default="1">
	<cfif not isNumeric(url.page) or url.page lte 0 or round(url.page) neq url.page>
		<cfset url.page = 1>
	</cfif>

	<cfset tp = (application.mobilePageMax *(url.page-1)) + 1>
	<cfif tp EQ 0>
		<cfset tp = 1>
	</cfif>
	<cfset params.startrow = tp>
	<cfset params.maxEntries = application.mobilePageMax>
	
	
	<cfset articleData = application.blog.getEntries(params)>
	<cfset articles = articleData.entries>
	<cfset pages = ceiling(articleData.totalEntries/params.maxEntries)>

</cfif>

<cfoutput query="articles">
		<cfset comCnt = application.blog.getCommentCount(id)>
		<li style="white-space: normal;"><a href="postDetail.cfm?post=#id#" style="white-space: normal;">#title#</a> <span class="ui-li-count">#comCnt#</span></li>
</cfoutput>

