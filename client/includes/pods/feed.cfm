<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
   Name			: feed.cfm
   Author 		: Raymond Camden
   Created 		: September 20, 2006
   Last Updated : November 17, 2007
   History 		: Forgot the enableoutputonly false

	Note - this pod is meant to allow you to easily show
	another site's RSS feed on your blog. You should 
	edit the title to match the site you are hitting. 
	You may also need to edit the xmlSearch tag based
	on the type of RSS feed you are using.
--->


<cfmodule template="../../tags/podlayout.cfm" title="Latest from MXNA">

<cfmodule template="../../tags/scopecache.cfm" scope="application" cachename="feed" timeout="#60*60#">

	<cftry>
		<cfset theURL = "http://weblogs.macromedia.com/mxna/xml/rss.cfm?query=byMostRecent&amp;languages=1">
		<cfhttp url="#theURL#" timeout="5">

		<cfset xml = xmlParse(cfhttp.filecontent)>
		<cfset items = xmlSearch(xml, "//*[local-name() = 'item']")>
		<cfloop index="x" from="1" to="#min(arrayLen(items),5)#">
			<cfset item = items[x]>
			<cfoutput>
			<a href="#item.link.xmlText#">#item.title.xmlText#</a><br>
			</cfoutput>
		</cfloop>
		<cfcatch>
			<cfoutput>
			Feed temporarily down.
			</cfoutput>
		</cfcatch>
	</cftry>
			
</cfmodule>
	
</cfmodule>
<cfsetting enablecfoutputonly=false>
