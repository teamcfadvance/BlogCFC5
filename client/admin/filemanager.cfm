<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/filemanager.cfm
	Author       : Raymond Camden 
	Created      : 09/14/06
	Last Updated : 3/9/07
	History      : Removed UDF to udf.cfm (rkc 11/29/06)
				 : Check filebrowse prop (rkc 12/12/06)
				 : Security fix (rkc 3/9/07)
--->

<cfif not application.filebrowse>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfset rootDirectory = getDirectoryFromPath(getCurrentTemplatePath())>
<cfset rootDirectory = reReplaceNoCase(rootDirectory, "[\\/]admin", "")>
<cfparam name="url.dir" default="/">

<!--- do not allow any .. --->
<cfif find("..", url.dir)>
	<cfset url.dir = "/">
</cfif>

<cfset currentDirectory = rootDirectory & url.dir>

<cfif structKeyExists(url, "download")>
	<cfset fullfile = currentDirectory & url.download>
	<cfif fileExists(fullFile)>
		<cfheader name="Content-disposition" value="attachment;filename=#url.download#">		
		<cfcontent file="#fullfile#" type="application/unknown">		
	</cfif>
</cfif>

<cfif structKeyExists(url, "delete")>
	<cfset fullfile = currentDirectory & url.delete>
	<cfif fileExists(fullFile)>
		<cffile action="delete" file="#fullfile#">
	</cfif>
</cfif>

<cfif structKeyExists(form, "cancel")>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "fileupload")>
	<cffile action="upload" filefield="form.newfile" destination="#currentDirectory#" nameconflict="overwrite">
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="File Manager">

	<cfoutput>
	<p>
	This tool lets you manage the files on your blog. <b>WARNING: Deletes are FINAL.</b> 
	If you do not know what you are doing, step away from the browser. 
	</p>
	</cfoutput>
	
	<cfif structKeyExists(variables, "errors") and arrayLen(errors)>
		<cfoutput>
		<div class="errors">
		Please correct the following error(s):
		<ul>
		<cfloop index="x" from="1" to="#arrayLen(errors)#">
		<li>#errors[x]#</li>
		</cfloop>
		</ul>
		</div>
		</cfoutput>
	</cfif>

	<cfdirectory name="files" directory="#currentDirectory#" sort="type asc">
	
	<cfoutput>
	<table border="1" width="100%">
		<tr bgcolor="##e0e0e0">
			<td colspan="3"><b>Current Directory:</b> #url.dir#</td>
			<td align="center">
			<cfif url.dir is not "/">
			<cfset higherdir = replace(url.dir, "/" & listLast(currentDirectory, "/"), "")>
			<a href="filemanager.cfm?dir=#higherdir#"><img src="#application.rooturl#/images/arrow_up.png" title="Go up one directory" border="0"></a>
			<cfelse>
			&nbsp;
			</cfif>
			</td>
		</tr>
		<cfloop query="files">
		<tr <cfif currentRow mod 2>bgcolor="##fffecf"</cfif>>
			<td>
			<cfif type is "Dir">
				<img src="#application.rooturl#/images/folder.png"> <a href="filemanager.cfm?dir=#url.dir##urlencodedformat(name)#/">#name#</a>
			<cfelse>
				<cfswitch expression="#listLast(name,".")#">
					<cfcase value="xls,ods">
						<cfset img = "page_white_excel.png">
					</cfcase>
					<cfcase value="ppt">
						<cfset img = "page_white_powerpoint.png">
					</cfcase>
					<cfcase value="doc,odt">
						<cfset img = "page_white_word.png">
					</cfcase>										
					<cfcase value="cfm">
						<cfset img = "page_white_coldfusion.png">
					</cfcase>
					<cfcase value="zip">
						<cfset img = "page_white_compressed.png">
					</cfcase>
					<cfcase value="gif,jpg,png">
						<cfset img = "photo.png">
					</cfcase>
					<cfdefaultcase>
						<cfset img = "page_white_text.png">
					</cfdefaultcase>
					
				</cfswitch>

				<img src="#application.rooturl#/images/#img#"> #name#

			</cfif>
			</td>
			<td><cfif type is not "Dir">#kbytes(size)#<cfelse>&nbsp;</cfif></td>
			<td>#dateFormat(datelastmodified)# #timeFormat(datelastmodified)#</td>
			<td width="50" align="center">
			<cfif type is not "Dir">
				<a href="filemanager.cfm?dir=#urlencodedformat(url.dir)#&download=#urlEncodedFormat(name)#"><img src="#application.rooturl#/images/disk.png" border="0" title="Download"></a>
				<a href="filemanager.cfm?dir=#urlencodedformat(url.dir)#&delete=#urlEncodedFormat(name)#" onClick="return confirm('Are you sure?')"><img src="#application.rooturl#/images/bin_closed.png" border="0" title="Delete"></a>
			<cfelse>
				&nbsp;
			</cfif>
			</td>
		</tr>
		</cfloop>
		<tr>
			<td colspan="4" align="right">
			<form action="filemanager.cfm?dir=#urlencodedformat(url.dir)#" method="post" enctype="multipart/form-data">
			<input type="file" name="newfile"> <input type="submit" name="fileupload" value="Upload File">
			</form>
			</td>
		</tr>
	</table>
	</cfoutput>
		
</cfmodule>

<cfsetting enablecfoutputonly=false>