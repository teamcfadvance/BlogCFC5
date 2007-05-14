<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
   Name : pages.cfm
   Author : William Haun (based on archives.cfm by Raymond Camden) (mods by Hatton)
   Created : August 19, 2006
   Last Updated :
   History :
--->

<cfset pages_qry = application.page.getPages() />

   
<cfmodule template="../../tags/podlayout.cfm" title="NAVIGATION">
	<cfoutput><a href="#application.rootURL#">Home</a><br /></cfoutput>

	<cfloop query="pages_qry">
		<cfoutput><a href="#application.rootURL#/page.cfm/#alias#">#title#</a><br /></cfoutput>
	</cfloop>
      
</cfmodule>
      
<cfsetting enablecfoutputonly=false />
