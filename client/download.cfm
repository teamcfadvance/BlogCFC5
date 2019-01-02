<!--- 
Description: Page for tracking downloads from within BlogCFC

Entering: N/A
Exiting: N/A

Dependencies: N/A
Expecting: N/A

Modification History
Date       Modifier                Modification
******************************************************
1/13/07  Jeff Houser, DotComIt   Created
1/19/07		Jeff Houser			modified 
--->

<cfscript>
	url = application.utils.parseSES();
</cfscript>


<!---- added a default directory to give the option to change it 
	This won't work using SES URLs and multiple directory levels deep
--->
<cfparam name="url.dir" default="enclosures">
<!---- added to track downloads downloads vs on-line views --->
<cfparam name="url.online" default="0">

<!--- code copied from print.cfm 
JH DotComIt 5/25/07 want to allow for downloads w/o an Blog Entry ID
---->
<cfif not isDefined("url.id") and not isDefined("url.file")>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<!--- make sure that we have an ID before trying to retrieve that entry --->
<cfif isDefined("url.id")>
	<cftry>
		<cfset entry = application.blog.getEntry(url.id,true,0)>
		<cfcatch>
			<cflocation url="index.cfm" addToken="false">
		</cfcatch>
	</cftry>
<cfelse>
	<!--- JH DotComIt 5/25/07 
		this is for tracking the download of files not associated with an blog entry--->
	<cfset entry.id = 0>
	<cfset entry.enclosure = url.file>
</cfif>
<!--- End code copied from print.cfm ---->

<!---- Log the download ---->
<cfset application.downloadtracker.logEnclosureDownload(entry.id,entry.enclosure,url.dir,url.online)>

<cfoutput>
	#application.rooturl#/#url.dir#/#urlEncodedFormat(getFileFromPath(entry.enclosure))#
</cfoutput>

<cflocation url="#application.rooturl#/#url.dir#/#urlEncodedFormat(getFileFromPath(entry.enclosure))#">

<cfsetting enablecfoutputonly=false>	


