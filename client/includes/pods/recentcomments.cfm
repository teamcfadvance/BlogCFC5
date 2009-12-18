<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : recent.cfm
	Author       : Sam Farmer
	Created      : April 13, 2006
	Last Updated : November 17, 2007
	History      : left was cropping off links mid html. (rkc 6/9/06)
				 : Pass 25 as the max length for links in comments (rkc 7/21/06)
				 : Wasn't properly localized (rkc 8/24/06)
				 : forgot to disable cfoutputonly (rkc 11/17/07)
	Purpose		 : Display recent comments
--->

<cfmodule template="../../tags/scopecache.cfm" cachename="#application.applicationname#_rc" scope="application" timeout="#application.timeout#">

<cfset numComments = 5>
<cfset lenComment = 100>

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("recentcomments")#">
	<cfset getComments = application.blog.getRecentComments(numComments)>
	<cfloop query="getComments">
		<cfset formattedComment = comment>
		<cfif len(formattedComment) gt len(lenComment)>
			<cfset formattedComment = left(formattedComment, lenComment)>
		</cfif>
		<cfset formattedComment = caller.replaceLinks(formattedComment,25)>
		<cfoutput><p><a href="#application.blog.makeLink(getComments.entryID)#">#getComments.title#</a><br />
		#getComments.name# #application.resourceBundle.getResource("said")#: #formattedComment#<cfif len(comment) gt lenComment>...</cfif>
		<a href="#application.blog.makeLink(getComments.entryID)###c#getComments.id#">[#application.resourceBundle.getResource("more")#]</a></p></cfoutput>
	</cfloop>
	<cfif not getComments.recordCount>
		<cfoutput>#application.resourceBundle.getResource("norecentcomments")#</cfoutput>
	</cfif>


</cfmodule>

</cfmodule>

<cfsetting enablecfoutputonly=false>
