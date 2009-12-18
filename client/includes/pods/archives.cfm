<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : archives.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : February 28, 2007
	History      : Use SES urls (rkc 4/18/06)
				 : Don't hide empty cats (rkc 5/10/06)
				 : add norel/nofollow, thanks Rob (rkc 2/28/07)
	Purpose		 : Display archives
--->

<cfmodule template="../../tags/scopecache.cfm" cachename="pod_archives" scope="application" timeout="#application.timeout#">

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("archivesbysubject")#">

	<cfset cats = application.blog.getCategories()>
	<cfloop query="cats">
		<cfoutput><a href="#application.blog.makeCategoryLink(categoryid)#" title="#categoryName# RSS">#categoryName# (#entryCount#)</a> [<a href="#application.rootURL#/rss.cfm?mode=full&amp;mode2=cat&amp;catid=#categoryid#" rel="noindex,nofollow">RSS</a>]<br /></cfoutput>
	</cfloop>
	
</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>