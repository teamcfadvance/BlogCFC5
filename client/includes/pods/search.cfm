<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : search.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : February 28, 2007
	History      : added processingdir (rkc 11/10/03)
				   point to index.cfm (rkc 8/5/05)
				   Change link (rkc 10/26/05)
				   Search box (rkc 9/5/06)
				   point to new search (rkc 2/28/07)
	Purpose		 : Display search box
--->

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("search")#">

	<cfoutput>
    <div class="center">
	<form action="#application.rooturl#/search.cfm" method="post" onsubmit="return(this.search.value.length != 0)">
	<p class="center"><input type="text" name="search" size="15" /> <input type="submit" value="#application.resourceBundle.getResource("search")#" /></p>
	</form>
  </div>
	</cfoutput>
		
</cfmodule>
	
<cfsetting enablecfoutputonly=false>