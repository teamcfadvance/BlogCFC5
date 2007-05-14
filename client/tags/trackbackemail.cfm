<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : trackbackemail.cfm
	Author       : Raymond Camden 
	Created      : September 27, 2005
	Last Updated : February 28, 2007
	History      : don't log the getEntry (rkc 2/28/07)
	Purpose		 : Handles just the email to notify us about TBs
--->

<!--- id of the TB --->
<cfparam name="attributes.trackback" type="uuid">

<cfset tb = application.blog.getTrackBack(attributes.trackback)>

<cfif structIsEmpty(tb)>
	<cfsetting enablecfoutputonly=false>
	<cfexit method="exitTag">	
</cfif>

<cftry>
	<cfset blogEntry = application.blog.getEntry(tb.entryid,false)>
	<cfcatch>
		<cfsetting enablecfoutputonly=false>
		<cfexit method="exitTag">	
	</cfcatch>
</cftry>

<!--- make TB killer link --->
<cfset tbKiller = application.rootURL & "/trackback.cfm?kill=#attributes.trackback#">

<cfset subject = application.resourceBundle.getResource("trackbackaddedtoentry") & ": " & application.blog.getProperty("blogTitle") & " / " & application.resourceBundle.getResource("entry") & ": " & blogEntry.title>
<cfsavecontent variable="email">
<cfoutput>
#application.resourceBundle.getResource("trackbackaddedtoblogentry")#:	#blogEntry.title#
#application.resourceBundle.getResource("trackbackadded")#: 		#application.localeUtils.dateLocaleFormat(now())# / #application.localeUtils.timeLocaleFormat(now())#
#application.resourceBundle.getResource("blogname")#:	 		#tb.blogname#
#application.resourceBundle.getResource("title")#:	 			#tb.title#
URL:				#tb.posturl#
#application.resourceBundle.getResource("excerpt")#:
#tb.excerpt#

#application.resourceBundle.getResource("deletetrackbacklink")#:
#tbKiller#

------------------------------------------------------------
This blog powered by BlogCFC #application.blog.getVersion()#
Created by Raymond Camden (ray@camdenfamily.com)
</cfoutput>
</cfsavecontent>

<cfset addy = application.blog.getProperty("owneremail")>
<cfif application.blog.getProperty("mailserver") is "">
	<cfmail to="#addy#" from="#addy#" subject="#subject#">#email#</cfmail>
<cfelse>
	<cfmail to="#addy#" from="#addy#" subject="#subject#"
		server="#application.blog.getProperty("mailserver")#" username="#application.blog.getProperty("mailusername")#" password="#application.blog.getProperty("mailpassword")#">#email#</cfmail>
</cfif>

<cfsetting enablecfoutputonly=false>
<cfexit method="exitTag">