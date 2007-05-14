<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Pods Display
	Author       : Scott Pinkston 
	Created      : October 14, 2006
	Last Updated : 
	History      : 
--->
 
<cfset dir = expandPath("../includes/pods")>

<cfif structKeyExists(url,"deletePod") and fileExists(dir & "/#url.deletePod#")>
	<cffile action="delete" file="#dir#/#url.deletePod#">
</cfif>

<!--- Get all of the cfm files in the pod folder ---->
<cfdirectory directory="#dir#" name="pods" filter="*.cfm">

<!--- Get the active pods and their sort order --->
<cfset podMetaData = application.pod.getInfo(dir)>

<!--- Add field to the query returned from cfdirectory --->
<cfset queryAddColumn(pods, "sortOrder", arrayNew(1))>

<cfloop query="pods">
	<cfif structKeyExists(podMetaData.pods,name)>
			<cfset querySetCell(pods, "sortOrder", podMetaData.pods[name], currentRow)>
		<cfelse>
			<cfset querySetCell(pods, "sortOrder", "", currentRow)>
	</cfif>
</cfloop>


<cfmodule template="../tags/adminlayout.cfm" title="Pods">

	<cfoutput>
	<p>Total Available Pods: #pods.recordcount# Total Active: #StructCount(podMetaData.pods)# </p>
	Select the Pods you want to display, and enter a numeric value for the sort order.<br />
	
	
	<form action="pod.cfm" method="post" name="PodUpdate">
	<table class="adminListTable">
	<tr class="adminListHeader">
		<td width="50">Show</td>
		<td>Name</td>
		<td>Actions</td>
		<td width="100">Sort Order</td>
	</tr>
	</cfoutput>

	<cfoutput query="pods">
		<tr class="adminList<cfif currentRow mod 2>1</cfif>">
			<td><input type="checkbox" name="ShowPods" value="#name#" <cfif len(sortOrder)>checked</cfif>></td>
			<td>#name#</td>
			<td>[<a href="showpods.cfm?pod=#name#" target="PodWin" onclick="window.open(this.href,this.target,'width=215,height=400');return false;">Show sample output</a> ] [<a href="pods.cfm?deletePod=#name#">Delete Pod</a>]</td>
			<td align="center"><input type="text" name="#name#" value="#sortOrder#" size="3" tabindex="#currentrow#"></td>
		</tr>
	</cfoutput>
	 
	<cfoutput></table>
		<div align="right" style="margin-right:15px;">
			[<a href="podform.cfm">Add New Pod</a> ] 
			[<a href="Javascript: document.PodUpdate.submit()">Update Pods</a> ]   
		</div>
	</form>
	</cfoutput>
	
</cfmodule>


<cfsetting enablecfoutputonly=false>