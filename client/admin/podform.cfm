<cfsetting enablecfoutputonly = "true">
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Pods Display
	Author       : Scott Pinkston 
	Created      : October 14, 2006
	Last Updated : 
	History      : 
--->
  
<!--- ********************** --->
<cfset podTemplateStart = 
"<cfsetting enablecfoutputonly='true'>
<cfprocessingdirective pageencoding='utf-8'>
<!---
   Name : __PAGENAME__
   Author : PodGenerator (based on archives.cfm by Raymond Camden) 
--->

<cfmodule template='../../tags/podlayout.cfm' title='__TITLE__'>
<!--- 
Your Pod text goes here - 
Remember it has to be in cfoutput 
tags or it will not be displayed 
--->
<cfoutput>
">

<cfset podTemplateEnd = "
</cfoutput>		
</cfmodule>
<cfsetting enablecfoutputonly='false'/>">
<!--- ********************** --->

<cfmodule template="../tags/adminlayout.cfm" title="Pods">
	
	<cfoutput>
	<br />	
	<fieldset>
		<legend>Create new Pod</legend>
			<cfform action="pod.cfm" method="post">
				Pod Name: <cfinput validateat="onBlur" validate="regular_expression" pattern="[A-Za-z]" message="Please enter only Alpha characters for the Pod Title" type="text" name="NewPod" size="25"><br>
				<textarea rows="30" cols="75" name="NewPodText">
#podTemplateStart# 
					
#podTemplateEnd#
				</textarea>
				<br><input type="submit" value="Create New Pod">	
			</cfform>
		Note: The file will be created in the includes/pods folder.<br />
	</fieldset>
	</cfoutput>
</cfmodule>


<cfsetting enablecfoutputonly="false">

<!--- eof --->