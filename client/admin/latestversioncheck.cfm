<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">

<cftry>
	<cfset serviceURL = "http://www.blogcfc.com/system/version/latest.cfm">
	<cfhttp url="#serviceURL#" result="result">
	<cfset data = xmlParse(result.fileContent)>
	<cfset latestVersion = data.version.number.xmlText>
	<cfset latestUpdate = data.version.updated.xmlText>
	<cfset latestDescription = data.version.description.xmlText>
	
	<cfif latestVersion neq application.blog.getVersion()>
		<cfoutput>
		<div style="margin: 15px 0; padding: 15px; border: 5px solid ##ffff00;; background-color: ##e4e961;">
		<p>
		<b>Your BlogCFC install may be out of the date!</b><br/>
		The latest released version of BlogCFC is <b>#latestVersion#</b> updated on <b>#DateFormat(latestUpdate, 'long')#</b>.
		<p><b>Updates for this version include:</b></p>
		#latestDescription#
		</p>
		</cfoutput>
	<cfelse>
		<cfoutput><p>Your BlogCFC install is up to date!</p></cfoutput>
	</cfif>
	<cfcatch>
		<cfoutput><p>Unable to correctly contact the update site.</p></cfoutput>
	</cfcatch>
</cftry>