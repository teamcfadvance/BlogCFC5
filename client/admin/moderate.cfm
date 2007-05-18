<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/moderate.cfm
	Author       : Trent Richardson
	Created      : 12/7/06
	Last Updated : 5/18/07
	History      : Handle sending email for moderated comments. Note the sucky duplication of the email
	 			   here. I need to fix that in the future. (rkc 4/13/07)
	 			 : Call approveCOmment, and use 'Moderated' for ip. I may just hide the whole line (rkc 5/18/07)
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.blog.deleteComment(u)>
	</cfloop>
</cfif>

<cfif structKeyExists(url, "approve")>
	<cfset c = application.blog.getComment(url.approve)>
	<cfset entry = application.blog.getEntry(c.entryidfk)>
	<cfset application.blog.approveComment(url.approve)>

	<cfset subject = rb("commentaddedtoblog") & ": " & application.blog.getProperty("blogTitle") & " / " & rb("entry") & ": " & entry.title>
	<cfsavecontent variable="email">
	<cfoutput>
#rb("commentaddedtoblogentry")#:	#entry.title#
#rb("commentadded")#: 		#application.localeUtils.dateLocaleFormat(now())# / #application.localeUtils.timeLocaleFormat(now())#
#rb("commentmadeby")#:	 	#c.name# <cfif len(c.website)>(#c.website#)</cfif>
#rb("ipofposter")#:			Moderated
URL: #application.blog.makeLink(entry.id)###c#c.id#

	
#c.comment#
	
------------------------------------------------------------
#rb("unsubscribe")#: %unsubscribe%
This blog powered by BlogCFC #application.blog.getVersion()#
Created by Raymond Camden (ray@camdenfamily.com)
			</cfoutput>
	</cfsavecontent>
	
	<cfset application.blog.notifyEntry(entryid=c.entryidfk, message=trim(email), subject=subject, from=c.email, noadmin=true)>

</cfif>

<!--- changed to get unmoderated comments 12-5-2006 by Trent Richardson --->
<cfset comments = application.blog.getUnmoderatedComments(sortdir="desc")>

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
		</cfif> to moderate.
	</p>
	</cfoutput>

	<cfmodule template="../tags/datatable.cfm" data="#comments#" editlink="comment.cfm" label="Comments"
			  linkcol="comment" defaultsort="posted" defaultdir="desc" showAdd="false">
		<cfmodule template="../tags/datacol.cfm" colname="name" label="Name" width="150" />
		<cfmodule template="../tags/datacol.cfm" colname="entrytitle" label="Entry" width="300" left="100" />
		<cfmodule template="../tags/datacol.cfm" colname="posted" label="Posted" format="datetime" width="150" />
		<cfmodule template="../tags/datacol.cfm" colname="comment" label="Comment" left="100"/>
		<cfmodule template="../tags/datacol.cfm" label="Approve Comment" data="<a href=""#application.rooturl#/admin/moderate.cfm?approve=$id$"">Approve</a>" sort="false"/>		
	</cfmodule>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>