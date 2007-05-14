<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/imgwin.cfm
	Author       : Raymond Camden 
	Created      : 9/15/06
	Last Updated : 12/14/06
	History      : Use imageroot (rkc 12/14/06)
--->

<cfset imageDirectory = expandPath("../images/") & application.imageroot>

<cfif structKeyExists(form, "upload") and len(trim(form.newimage))>

	<cfif not directoryExists(imageDirectory)>
		<cfdirectory action="create" directory="#imageDirectory#">
	</cfif>
	
	<cffile action="upload" filefield="form.newimage" destination="#imageDirectory#" nameconflict="makeunique">

	<cfif not listFindNoCase("gif,jpg,png", cffile.serverFileExt)>
		<cfset notImageFlag = true>
		<cffile action="delete" file="#cffile.serverDirectory#/#cffile.serverFile#">
	<cfelse>
		<cfset fileName = cffile.serverFile>
		<cfoutput>
		<script>
		opener.newImage('#jsStringFormat(filename)#');
		window.close();
		</script>
		</cfoutput>
		<cfabort>
	</cfif>
	
</cfif>

<cfif structKeyExists(variables, "notImageFlag")>
	<cfoutput>
	File upload wasn't a valid image.
	</cfoutput>
</cfif>

<cfoutput>
<form action="imgwin.cfm" method="post" enctype="multipart/form-data">
<input type="file" name="newimage"> <input type="submit" name="upload" value="Upload Image">
</form>
</cfoutput>

<cfsetting enablecfoutputonly=false>
