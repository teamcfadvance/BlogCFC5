

<cfparam name="attributes.title" default="">
<cfparam name="attributes.showHome" default="false">
<cfparam name="attributes.id" default="blogHeader">

<div data-role="header" data-theme="<cfoutput>#application.primaryTheme#</cfoutput>" data-position="fixed" data-id="<cfoutput>#attributes.id#</cfoutput>"  <cfif attributes.showHome EQ 1>data-backbtn="false"</cfif>>	
	<cfif attributes.showHome NEQ 1>
		<a href="index.cfm?" data-icon="arrow-l" data-rel="back" data-direction="reverse">Back</a>
	</cfif>
	<h1><cfoutput>#attributes.title#</cfoutput></h1>
	<cfif attributes.showHome NEQ 1>		
		<a href="index.cfm?" data-icon="home" data-iconpos="notext" data-direction="reverse" class="ui-btn-right">Home</a>
	</cfif>
</div>