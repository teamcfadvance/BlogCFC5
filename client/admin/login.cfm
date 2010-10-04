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
<div id="login">
<form name="loginform" action="#cgi.script_name#?#qs#" method="post" enctype="multipart/form-data">
<!--- copy additional fields --->
<cfloop item="field" collection="#form#">
	<!--- the isSimpleValue is probably a bit much.... --->
	<cfif field is "enclosure" and len(trim(form.enclosure))>
		<input type="hidden" name="enclosureerror" value="true">
	<cfelseif not listFindNoCase("username,password", field) and isSimpleValue(form[field])>
		<input type="hidden" name="#field#" value="#htmleditformat(form[field])#">
	</cfif>
</cfloop>
		<table id="logintable">
			<tr>
				<td>#application.resourceBundle.getResource("username")#</td><td><input name="username" type="text" id="username" size="30"></td>
			</tr>
			<tr>
				<td>#application.resourceBundle.getResource("password")#</td><td><input name="password" type="password" id="password" size="30"></td>
			</tr>
			<tr>
				<td></td><td><input type="submit" value="#application.resourceBundle.getResource("login")#"></td>
			</tr>
			<!---<tr>
				<td></td><td><a href="">Forgot username or password?</a></td>
			</tr>--->
			<tr>
				<td colspan=2 nowrap=yes id="loginfooter"><a href="javascript:openAbout();">About</a></td>
			</tr>
		</table>
	</form>
</div>
<div id="about">
	<p>BlogCFC was created by Ray Camden with contributions from many supporters including Scott Stroz, Jeff Coughlin, Charlie Griefer, Paul Hastings, Adam Tuttle, Deanna Schneider, Joe Nicora, Jacob Munson, and Jason Delmore.</p>
	<p>For more information visit <a href="http://www.blogcfc.com/">http://www.blogcfc.com/</a></p>
	<a href="javascript:closeAbout();" class="button" style="float:right;">Close</a>
</div>
<script language="javaScript" TYPE="text/javascript">
<!--
document.forms[0].username.focus();
//-->
function openAbout(){
	document.getElementById('about').style.display = 'block';
}
function closeAbout(){
	document.getElementById('about').style.display = 'none';
}
</script>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly=false>