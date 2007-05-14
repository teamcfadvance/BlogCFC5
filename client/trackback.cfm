<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : c:\projects\blog\client\trackbackb.cfm
	Author       : Dave Lobb 
	Created      : 09/22/05
	Last Updated : 2/28/07
	History      : Ray modified it for 4.0
				 : Don't log the getEntry (rkc 2/28/07)
--->

<!--- TBs allowed? --->
<cfif not application.blog.getProperty("allowtrackbacks")><cfabort></cfif>

<!--- Kill TB
This link doesn't authenticate at all, but gives us one click clean up of TBs from email. --->
<cfif isDefined("url.kill") and len(trim(url.kill))>
	<cftry>
		<cfset application.blog.deleteTrackback(url.kill)>
		<cflocation url="#application.rootURL#" addToken="false">
		<cfcatch>
			<!--- silently fail --->
		</cfcatch>
	</cftry>
</cfif>

<cfcontent type="text/xml; charset=UTF-8">

<!--- 
http://www.sixapart.com/pronet/docs/trackback_spec
--->


<cfset response = '<?xml version="1.0" encoding="utf-8"?><response><error>{code}</error>{message}</response>'>
<cfset message = '<message>{error}</message>'>
<cfset error = "">
	
<cfif cgi.REQUEST_METHOD eq "POST">
	<cfparam name="form.title" default="">
	<cfparam name="form.excerpt" default="">
	<cfparam name="form.blog_name" default="">
		
	<!--- must have entry id --->
	<cfif not len(cgi.query_string)>
		<cfset error = "Could not find post - please check trackback URL">
	<cfelse>
		<cfset entry = cgi.query_string>
		<cftry>
			<cfset blogEntry = application.blog.getEntry(entry,true)>
			<!--- must have url --->
			<cfif structKeyExists(form, "url")>
				<cfset id = application.blog.addTrackBack(form.title, form.url, form.blog_name, form.excerpt, entry)>
				<cfif id is not "">
					<!--- Form a message about the TB --->
					<cfmodule template="tags/trackbackemail.cfm" trackback="#id#" />
					<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
				</cfif>
			<cfelse>
				<cfset error = "URL not provided">
			</cfif>

			<cfcatch>
				<!--- person TBed a bad entry --->
				<cfset error = "Bad Entry">
			</cfcatch>
		</cftry>			
	</cfif>
<cfelse>
	<cfset error = "TrackBack request not POSTed">
</cfif>
	
<cfif not len(error)>
	<cfset response = replace(response, "{code}", "0")>
	<cfset response = replace(response, "{message}", "")>
<cfelse>
	<cfset response = replace(response, "{code}", "1")>
	<cfset message = replace(message, "{error}", error)>
	<cfset response = replace(response, "{message}", message)>
</cfif>
	
<cfset getPageContext().getOut().clear()> 
<cfoutput>#trim(response)#</cfoutput>

<cfsetting enablecfoutputonly=false>	

