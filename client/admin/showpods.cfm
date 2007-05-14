<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : ShowPods.cfm
	Author       : Scott Pinkston 
	Created      : October 14, 2006
	Last Updated : 
	History      : 
--->
  
	<cfset dir = expandPath("../includes/pods")>
	
	<cfif fileExists(dir & "/#url.pod#")>
		<cfoutput>
			<html>
				<head>
					<title>Pod</title>
						<link rel="stylesheet" href="#application.rooturl#/includes/layout.css" type="text/css" />
						<link rel="stylesheet" href="#application.rooturl#/includes/style.css" type="text/css" />
				</head>
			<body>
			<div style="background:white;">
			<div id="menu" style="background:white;">
		</cfoutput>
		<cfinclude template="../includes/pods/#url.pod#">
		<cfoutput>
			</div>
			</div>
			</body>
			</html>
		</cfoutput>
	
	</cfif>

<cfsetting enablecfoutputonly="false">