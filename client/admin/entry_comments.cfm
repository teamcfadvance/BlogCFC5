<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/entry_comments.cfm
	Author       : Dan G. Switzer, II
	Created      : 11/11/07
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.blog.deleteComment(u)>
	</cfloop>
</cfif>

<cfset sSortDir = "desc" />

<cfset comments = application.blog.getComments(id=url.id, sortdir=sSortDir)>

<cfoutput>
<html>
<head>
	<title>Entry Comments</title>
	<link rel="stylesheet" type="text/css" href="#application.rooturl#/includes/admin.css" media="screen" />
	<style type="text/css">
		body {
			background-image: none;
			font-family: Arial;
		}
	</style>

	<script type="text/javascript">
		window.onload = adjustIframeSize;

		function adjustIframeSize(){
			var el = document.getElementById("commentsBody");

			parent.document.getElementById("commentsFrame").style.height = el.offsetHeight + "px";
		}
	</script>
</head>
<body id="commentsBody">
	<p>
		This entry currently has
			<cfif comments.recordCount gt 1>
			#numberFormat(comments.recordcount)# comments.
			<cfelseif comments.recordCount is 1>
			1 comment.
			<cfelse>
			0 comments.
			</cfif>
	</p>
</cfoutput>

<cfmodule template="../tags/datatable.cfm" data="#comments#" editlink="comment.cfm" label="Comments"
		  linkcol="none" defaultsort="posted" defaultdir="#sSortDir#" showAdd="false" queryString="id=#url.id#" perpage="10">
	<cfmodule template="../tags/datacol.cfm" colname="name" label="Name" width="150" />
	<cfmodule template="../tags/datacol.cfm" colname="posted" label="Posted" format="datetime" width="150" />
	<cfmodule template="../tags/datacol.cfm" colname="comment" label="Comment" width="300"/>
	<cfmodule template="../tags/datacol.cfm" label="View" data="<a href=""#application.rooturl#/admin/comment.cfm?id=$id$"" target=""_top"">View</a>" sort="false"/>
</cfmodule>

<cfoutput>
</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly=false>