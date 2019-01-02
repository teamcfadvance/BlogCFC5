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

	<cfset subject = request.rb("commentaddedtoblog") & ": " & application.blog.getProperty("blogTitle") & " / " & request.rb("entry") & ": " & entry.title>
	<cfsavecontent variable="email">
	<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Comment Subscription</title>
</head>
<body id="blogcommentmail" style="font:10pt Arial,sans-serif;padding: 10px;">
	<table cellspacing=0>
		<tr id="header">
			<td colspan=2 style="font-size: 14pt;padding:0 0 6px 0;border-bottom:1px solid ##e4e8af;">Comment Added to <a href="#application.blog.makeLink(entry.id)###c#c.id#" style="color:##7d8524;text-decoration:none;">#htmlEditFormat(application.blog.getProperty("blogTitle"))# : #entry.title#</a></td>
		</tr>
		<tr><td colspan=2 style="height:10px"></td></tr>
		<tr id="content" style="padding: 20px;">
			<td id="comment" style="width:75%;">
#application.utils.ParagraphFormat2(htmlEditFormat(c.comment))#
			</td>
			<td id="commentor" valign=top style="width:25%;background-color: ##edf0c9;height:100%">
				<div id="avatar" style="text-align: center;margin:30px 0 0 0;padding:20px 0 20px 0;width: 100%;height: 100%;">
					<img src="http://www.gravatar.com/avatar/#lcase(hash(c.email))#?s=80&amp;r=pg&amp;d=#application.rooturl#/images/gravatar.gif" id="avatar_image" border=0 title="#c.name#'s Gravatar" style="width:80px;height:80px;padding:5px;background:white; border:1px solid ##e4e8af;" />
					<div id="commentorname" style="text-align: center;padding:20 0 20px 0;"><cfif len(c.website)><a href="#c.website#" style="color:##7d8524;text-decoration:none;"></cfif>#c.name#<cfif len(c.website)></a></cfif></div>
				</div>
			</td>
		</tr>
		<tr><td colspan=2 style="height:10px"></td></tr>
		<tr id="footer">
			<td style="border-top:1px solid ##e4e8af;padding:0 10px 0 0;"><a href="http://blogcfc.com/" style="color:##7d8524;text-decoration:none;"><img src="#application.rooturl#/images/logo.png" border=0/></a></td>
			<td id="footerlinks" nowrap style="margin:5px;text-align:right;border-top:1px solid ##e4e8af;padding:0 10px 0 0;">
				%unsubscribe%
				<div id="createdby" style="font-size:8pt;padding:20px 0 0 0;bottom:0px;text-align:right;">
					Created by <a href="http://www.coldfusionjedi.com" style="color:##7d8524;text-decoration:none;">Raymond Camden</a>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>
	</cfoutput>
	</cfsavecontent>
	
	<cfset application.blog.notifyEntry(entryid=c.entryidfk, message=trim(email), subject=subject, from=c.email, noadmin=true, commentid=c.id, html=true)>

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