<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\login.cfm
	Author       : Raymond Camden 
	Created      : 04/13/06
	Last Updated : 10/28/06
	History      : Fix for timeout w/ enclosure (rkc 10/28/06)
--->


<cfmodule template="../tags/adminlayout.cfm" title="Logon">

<cfset qs = cgi.query_string>
<cfset qs = reReplace(qs, "logout=[^&]+", "")>

<cfoutput>
<form action="#cgi.script_name#?#qs#" method="post" enctype="multipart/form-data">
<!--- copy additional fields --->
<cfloop item="field" collection="#form#">
	<!--- the isSimpleValue is probably a bit much.... --->
	<cfif field is "enclosure" and len(trim(form.enclosure))>
		<input type="hidden" name="enclosureerror" value="true">
	<cfelseif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
		<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
	</cfif>
</cfloop>
<table>
	<tr>
		<td><b>#application.resourceBundle.getResource("username")#</b></td>
		<td><input type="text" name="username"></td>
	</tr>
	<tr>
		<td><b>#application.resourceBundle.getResource("password")#</b></td>
		<td><input type="password" name="password"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" value="#application.resourceBundle.getResource("login")#"></td>
	</tr>
</table>
</form>

<script language="javaScript" TYPE="text/javascript">
<!--
document.forms[0].username.focus();
//-->
</script>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>