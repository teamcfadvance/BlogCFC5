<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">

<cfset serviceURL = "http://www.blogcfc.com/system/version/latest.cfm">
<cfhttp url="#serviceURL#" result="result">
<cfset data = xmlParse(result.fileContent)>
<cfset latestVersion = data.version.number.xmlText>
<cfset latestDescription = data.version.description.xmlText>

<cfif latestVersion neq application.blog.getVersion()>
	<cfoutput>
	<p>
	<b>Your BlogCFC install may be out of the date!</b><br/>
	The latest released version of BlogCFC is #latestVersion#. Updates for this version include:<br/>
	#latestDescription#
	</p>
	</cfoutput>
<cfelse>
	<cfoutput><p>Your BlogCFC install is up to date!</p></cfoutput>
</cfif>
