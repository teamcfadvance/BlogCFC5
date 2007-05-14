<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : pod.cfm
	Author       : Scott Pinkston 
	Created      : October 13, 2006
	Last Updated : 
	History      : initial
--->

<cfset dir = expandPath("../includes/pods")>

<!---  
Check for adding pods, return to the pods page after processing
---->
<cfif structKeyExists(form,"newPod") and len(form.newpod)>
	
	<cfset newPodTitle = form.newPod>
	<cfset form.newPod = reReplace(form.newPod," ","_","ALL")>
	<cfset form.newPod = reReplace(form.newPod,",","","ALL")>
	<cfset form.newPod = reReplace(form.newPod,"'","","ALL")>
	
	<cfset form.newPodText = reReplace(form.newPodText,"__PAGENAME__","#form.newPod#.cfm")>
	<cfset form.newPodText = reReplace(form.newPodText,"__PAGENAME__","#form.newPod#")>
	<cfset form.newPodText = reReplace(form.newPodText,"__TITLE__","#newPodTitle#")>
	
	<cffile action="write" output="#form.newPodText#" file="#dir#/#form.newPod#.cfm">
	<cflocation url="pods.cfm" addtoken="no">
</cfif>

<!--- 
Sorting the forms based on code from this thread:
http://www.houseoffusion.com/groups/CF-Talk/thread.cfm/threadid:32626
--->

<cfscript>   
function sortForm(f) {
	var sortArray = arrayNew(2);    
	var stForm = Duplicate(f);       
	var keys = structKeyArray(stForm);    
	var sortedKeys = "";       
	
	for (i=1; i LTE arrayLen(keys); i=i+1) {
		if (NOT isNumeric(stForm[keys[i]])) {
		 structDelete(stForm, keys[i]);     
		}    
	}    
	
	sortedKeys = structSort(stForm, 'numeric');       
	for (i=1; i LTE arrayLen(sortedKeys); i=i+1) {
		sortArray[arrayLen(sortArray)+1][1] = sortedKeys[i];     
		sortArray[arrayLen(sortArray)][2] = stForm[sortedKeys[i]];    
	}   
	return sortArray;   
} 
</cfscript>

<!--- sort the form data ---->
<cfset formSorted = sortForm(form)>

<cfif structKeyExists(form,"showpods")>
		<cfset metadata = structNew()>
		<cfset metadata.pods = structNew()>

		<cfloop from="1" to="#arraylen(formSorted)#" index="i">
			<cfif listContainsNoCase(form.showpods,formSorted[i][1])>
				<cfset metadata.pods[formSorted[i][1]] = i>
			</cfif>
		</cfloop>

		<!--- update metadata --->
		<cfset application.pod.updateInfo(dir, metadata)>
</cfif>

<cflocation url="pods.cfm" addtoken="no">