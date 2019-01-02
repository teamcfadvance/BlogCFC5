<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : error.cfm
	Author       : Raymond Camden 
	Created      : March 20, 2005
	Last Updated : April 20, 2007
	History      : Show error if logged in. (rkc 4/4/05)
				   BD didn't like error.rootcause (rkc 5/27/05)
				   PaulH added locale strings (rkc 7/22/05)
				   Use of rb() (rkc 8/20/06)
				   Left a or 1 in the code, bad Ray (rkc 4/20/07)
	Purpose		 : Handles errors
--->

<!--- Critical error --->
<cfif not structKeyExists(application, "init")>
	<h2>Critical Error</h2>
	<p>
	A critical error has been thrown. Please visit <a href="http://www.blogcfc.com/index.cfm/main/support">BlogCFC support</a>.
	</p>
	<cfif isDefined('error')>
		<cfdump var="#error#">
	</cfif>
	<cfabort>
</cfif>
	
<!--- Send the error report --->
<cfset blogConfig = application.blog.getProperties()>

<cfsavecontent variable="mail">
<cfoutput>
#request.rb("errorOccured")#:<br />
<table border="1" width="100%">
	<tr>
		<td>#request.rb("date")#:</td>
		<td>#dateFormat(now(),"m/d/yy")# #timeFormat(now(),"h:mm tt")#</td>
	</tr>
	<tr>
		<td>#request.rb("scriptName")#:</td>
		<td>#cgi.script_name#?#cgi.query_string#</td>
	</tr>
	<tr>
		<td>#request.rb("browser")#:</td>
		<td>#error.browser#</td>
	</tr>
	<tr>
		<td>#request.rb("referer")#:</td>
		<td>#error.httpreferer#</td>
	</tr>
	<tr>
		<td>#request.rb("message")#:</td>
		<td>#error.message#</td>
	</tr>
	<tr>
		<td>#request.rb("type")#:</td>
		<td>#error.type#</td>
	</tr>
	<cfif structKeyExists(error,"rootcause")>
	<tr>
		<td>#request.rb("rootCause")#:</td>
		<td><cfdump var="#error.rootcause#"></td>
	</tr>
	</cfif>
	<tr>
		<td>#request.rb("tagContext")#:</td>
		<td><cfdump var="#error.tagcontext#"></td>
	</tr>
</table>
</cfoutput>
</cfsavecontent>

<cfif blogConfig.mailserver is "">
	<cfmail to="#blogConfig.owneremail#" from="#blogConfig.owneremail#" type="html" subject="Error Report">#mail#</cfmail>
<cfelse>
	<cfmail to="#blogConfig.owneremail#" from="#blogConfig.owneremail#" type="html" subject="Error Report"
			server="#blogConfig.mailserver#" username="#blogConfig.mailusername#" password="#blogConfig.mailpassword#">#mail#</cfmail>
</cfif>

<cfmodule template="tags/layout.cfm">

	<cfoutput>
	<div class="date">#request.rb("errorpageheader")#</div>
	<div class="body">
	<p>
	#request.rb("errorpagebody")#
	</p>
	<cfif isUserInRole("admin")>
		<cfoutput>#mail#</cfoutput>
	</cfif>
	</div>


	<cfif IsDebugMode()>
Error:
<cfdump var="#error#">

CGI: 
<cfdump var="#cgi#">

Form: 
<cfdump var="#form#">

URL: 
<cfdump var="#url#">

Session:
<cfif IsDefined('session')>
<Cfdump var="#session#">
</cfif>

Application:
<cfif IsDefined('Application')>
<Cfdump var="#Application#">
</cfif>

Request
<Cfdump var="#request#">	
	</cfif>
	</cfoutput>
	
</cfmodule>