<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/comments.cfm
	Author       : Raymond Camden 
	Created      : 04/06/06
	Last Updated : 7/13/06
	History      : Support entrytitle (rkc 7/7/06)
				 : Show link (rkc 7/13/06)
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.blog.deleteComment(u)>
	</cfloop>
</cfif>

<cfset comments = application.blog.getComments(sortdir="desc")>

<cfmodule template="../tags/adminlayout.cfm" title="Comments">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif comments.recordCount gt 1>
		#comments.recordcount# comments
		<cfelseif comments.recordCount is 1>
		1 comment
		<cfelse>
		0 comments
		</cfif>.
	</p>
	</cfoutput>

	<cfmodule template="../tags/datatable.cfm" data="#comments#" editlink="comment.cfm" label="Comments"
			  linkcol="comment" defaultsort="posted" defaultdir="desc" showAdd="false">
		<cfmodule template="../tags/datacol.cfm" colname="name" label="Name" width="150" />
		<cfmodule template="../tags/datacol.cfm" colname="entrytitle" label="Entry" width="300" left="100" />
		<cfmodule template="../tags/datacol.cfm" colname="posted" label="Posted" format="datetime" width="150" />
		<cfmodule template="../tags/datacol.cfm" colname="comment" label="Comment" left="100"/>
		<cfmodule template="../tags/datacol.cfm" label="View" data="<a href=""#application.rooturl#/index.cfm?mode=entry&entry=$entryidfk$##c$id$"">View</a>" sort="false"/>		
	</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>