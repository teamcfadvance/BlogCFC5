<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/imgbrowse.cfm
	Author       : Raymond Camden 
	Created      : 11/29/06
	Last Updated : 12/14/06
	History      : support imageroot (rkc 12/14/06)
--->

<cfset imageDirectory = expandPath("../images/") & application.imageroot>

<cfif not directoryExists(imageDirectory)>
	<cfdirectory action="create" directory="#imageDirectory#">
</cfif>

<cfparam name="url.dir" default="/">
<cfset currentDirectory = imageDirectory & url.dir>
<cfdirectory name="files" directory="#currentDirectory#" sort="type asc">

<!--- filter to gif,jpg,png --->
<cfquery name="files" dbtype="query">
select	*
from	files
where	upper(name) like '%.JPG'
or		upper(name) like '%.GIF'
or		upper(name) like '%.PNG'
or type = 'Dir'
</cfquery>

<cfoutput>
<html>

<head>
<title>Image Browser</title>
<link rel="stylesheet" type="text/css" href="#application.rooturl#/includes/admin_popup.css" media="screen" />
<script>
function showImage(url) {
	cWin = window.open(url,"cWin","width=500,height=500,menubar=no,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
}

function insertIt(url) {
	opener.newImage(url);
	window.close();
}
</script>
</head>

<body>

<div id="content">
<table border="1" width="100%">
	<tr bgcolor="##e0e0e0">
		<td colspan="3"><b>Current Directory:</b> #url.dir#</td>
		<td align="center">
		<cfif url.dir is not "/">
		<cfset higherdir = replace(url.dir, "/" & listLast(currentDirectory, "/"), "")>
		<a href="#cgi.script_name#?dir=#higherdir#"><img src="#application.rooturl#/images/arrow_up.png" title="Go up one directory" border="0"></a>
		<cfelse>
		&nbsp;
		</cfif>
		</td>
	</tr>
	<cfloop query="files">
	<tr <cfif currentRow mod 2>bgcolor="##fffecf"</cfif>>
		<td>
		<cfif type is "Dir">
			<img src="#application.rooturl#/images/folder.png"> <a href="#cgi.script_name#?dir=#url.dir##urlencodedformat(name)#/">#name#</a>
		<cfelse>
			<cfset img = "photo.png">
			<img src="#application.rooturl#/images/#img#"> #name#
		</cfif>
		</td>
		<td><cfif type is not "Dir">#kbytes(size)#<cfelse>&nbsp;</cfif></td>
		<td><cfif type is not "Dir"><a href="javaScript:showImage('#urlEncodedFormat("../images/#application.imageroot#/#url.dir#/#name#")#')"><img src="../images/#application.imageroot#/#url.dir#/#name#" width="50" height"50" align="absmiddle" border="0"></a><cfelse>&nbsp;</cfif></td>
		<td width="50" align="center">
		<cfif type is not "Dir">
			<!--- quick mod - this apps uses / by default while imgwin isnt, so remove a solo / --->
			<cfset theurl = right(url.dir & name, len(url.dir & name) - 1)>			
			<a href="javaScript:insertIt('#theurl#')">Insert</a>
		<cfelse>
			&nbsp;
		</cfif>
		</td>
	</tr>
	</cfloop>
</table>
</div>

</body>
</html>
</cfoutput>


<cfsetting enablecfoutputonly=false>
