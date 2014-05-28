<!---
Docs: This file has access to:

themeurl - rooturl to theme
settings - struct of all blog settings
entry - struct of data for the entry
body - it's entry.body + morebody together in one easy to consume package
postcommenturl - url to point your form at for adding comments
commentadded - boolean if comment added
commenterrors - array of comment errors
comments - query of comments
categories - list of cats for the entry
categoryids - list of cat idf
commentsAllowed - boolean if comments allowed
hasComments - boolean if entry has comments

relatedentries - to be done
link to helper udfs like replaceLinks?
--->

<cfset entrylink = renderEntryLink(entry.id)>

<cfoutput>
<h2>#entry.title#</h2>
<div class="byline">Posted by #entry.name# on #dateFormat(entry.posted)# #timeFormat(entry.posted)# in  #renderCategoryListLink(categories)#</div>

#paragraphformat(body)#

<h2>Comments</h2>
<cfif hasComments>

	<cfloop query="comments">
		<div id="c#id#" class="comment<cfif currentRow mod 2>Alt</cfif>">
			<div class="commentBody">
			<img src="http://www.gravatar.com/avatar/#lcase(hash(email))#?s=40&amp;r=pg&amp;d=#themeurl#/images/gravatar.gif" alt="#name#'s Gravatar" border="0" />
			#paragraphFormat(comment)#
			</div>
			<div class="commentByLine">
			<a href="#entryLink###c#id#">##</a> Posted by <cfif len(website)><a href="#website#" rel="nofollow">#name#</a><cfelse>#name#</cfif> 
			| #dateFormat(posted, "short")# #timeFormat(posted)#
			</div>
		</div>
					
	</cfloop>
<cfelse>

	<p>
	This poor entry has no comments.
	</p>
	
</cfif>
</cfoutput>



