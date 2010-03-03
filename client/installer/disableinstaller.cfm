<cfset app = expandPath("./Application.cfm")>
<cfset killswitch = "Installer has been disabled.<cfabort>">
<cffile action="read" file="#app#" variable="buffer">
<cffile action="write" file="#app#" output="#killswitch# #buffer#">