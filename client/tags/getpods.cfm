<cfparam name="attributes.dirlevel" default="">

<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : GetPods.cfm
	Author       : Scott Pinkston 
	Created      : October 13, 2006
	Last Updated : October 16, 2006
	Purpose		 : Add pod controls
	History      : Added fileExists check
				   boyzoid -changed structSort to numeric sort 

JH DotComIt 2/21/09 
Hacked to work w/ Flextras site outside of BlogCFC.  Also turned pod calls into custom tags so i could pass in the dirlevel variable and other values

12/30/2018: Merged into main blogCFC code and a bunch of those previous hacks removed as no longer relevant. Left the dirlevel variable, though, even though not used in current form.

--->
  
	<cfset podDir = getDirectoryFromPath(getCurrentTemplatePath()) & "../includes/pods/">

	<cfset podList = application.pod.getpods(podDir)>
	<cfset podList = structsort(podlist.pods,"numeric")>
	
	<!--- see if the metadata exists, if not we will load all pods --->
	<cfif arraylen(podlist)>
		<cfloop from="1" to="#arraylen(podlist)#" index="pod">
			<cfif fileExists(podDir & "/#podlist[pod]#")>
<!--- 				<cfinclude template="../includes/pods/#podlist[pod]#">
 --->
		<cfmodule template="../includes/pods/#podlist[pod]#" dirlevel="#attributes.dirlevel#">
			</cfif>
		</cfloop>

	<cfelse>
			<cfdirectory action="list" filter="*.cfm" directory="#podDir#" name="Pods">

			<cfoutput query="pods">
				<cfif fileExists(podDir & "/#name#")>
<!--- 					<cfinclude template="../includes/pods/#name#"> --->
		<cfmodule template="../includes/pods/#podlist[pod]#" dirlevel="#attributes.dirlevel#">
				</cfif>
			</cfoutput>
	</cfif>	

<cfsetting enablecfoutputonly=false>

<!--- eof --->