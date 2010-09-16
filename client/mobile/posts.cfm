
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

</cfif>

<cfoutput query="articles">
		<li class="arrow" style="padding: 7px 10px 7px 10px;"><a href="postDetail.cfm/#id#"><span style="font-size: 14px;">#left(title, 35)#<cfif len(title) GT 35>...</cfif></span></a></li>
</cfoutput>