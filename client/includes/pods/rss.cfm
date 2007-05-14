<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : rss.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : February 28, 2007
	History      : history cleared for 4.0
				 : Nofollow/noindex (rkc 2/28/07)
	Purpose		 : Display rss box
--->

<cfset rssURL = application.rootURL & "/rss.cfm">

<cfmodule template="../../tags/podlayout.cfm" title="RSS">

	<cfoutput>
	<p class="center">
	<a href="#rssURL#?mode=full" rel="noindex,nofollow"><img src="#application.rootURL#/images/rssbutton.gif" border="0"></a><br>
	</p>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>