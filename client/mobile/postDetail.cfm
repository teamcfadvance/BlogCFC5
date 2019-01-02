

<cfset dataError = false>

<cftry>
	<cfset thisItem = url.post>
	<cfset entryData = application.blog.getEntry(thisItem)>
	<cfset commentsCnt = application.blog.getCommentCount(thisItem)>	
	<cfif commentsCnt>	
		<cfset comments = application.blog.getComments(thisItem)>	
	</cfif>
	<!---catch an attept to load an unreleased entry--->
	<cfif NOT entryData.released>
		<cfset dataError = true>	
	</cfif>
	
<cfcatch type="any">
	<cfset dataError = true>
</cfcatch>

</cftry>



<cfoutput>

<div data-role="page" data-theme="#application.primaryTheme#">


	<cf_header title="Post Detail" showHome="2" id="blogHeader">
	<div data-role="content" data-theme="b">
		<cfif dataError>	
			There was an error attempting to load the post.
		<cfelse>
		
			<ul data-role="listview" data-theme="d" data-inset="true" > 
				<li>		
					<h2 style="white-space: normal;"><span>#entryData.title#</span></h2> 
					
					
				</li>
				<li>
					<p style="padding-top: 5px;"><strong>Posted:</strong> #application.localeUtils.dateLocaleFormat(entryData.posted)# #application.localeUtils.timeLocaleFormat(entryData.posted)#</p>
					<p><strong>By:</strong> #entryData.name#</p> 
					<p>
						<strong>Categories:</strong> 
						<cfset lastid = listLast(structKeyList(entryData.categories))>
						<cfloop item="catid" collection="#entryData.categories#">
							#entryData.categories[catid]#<cfif catid is not lastid>, </cfif>
						</cfloop>
					</p>
				</li>
			</ul>
			<div data-inset="true">
				<div>
					<!---
						pre render rereplace is here to correct rendering issue caused by the renderer
					--->
					<cfsavecontent variable="pBody">
					#REReplace("<p>" & entryData.body & "</p>", "\r+\n\r+\n", "</p><p>", "ALL")#
					#REReplace("<p>" & entryData.morebody & "</p>", "\r+\n\r+\n", "</p><p>", "ALL")#
					</cfsavecontent>
					
					<!--- overrides mobile's default handling of links by 
					adding blank target to links  and rel attribute to all images --->
					<cfset linkRep = '<a target="_blank"'>
					<cfset pBody = replaceNoCase(pBody, '<a', linkRep, 'all')>
					
					<cfset imgRep = '<img rel="external"'>
					<cfset pBody = replaceNoCase(pBody, '<img', imgRep, 'all')>
					
					#application.blog.renderEntry(pBody,true,'', true)#
				</div>					
			</div>
			
			<cfif commentsCnt>
			
			
			
				<div data-role="collapsible" data-collapsed="true"  data-theme="e"> 
					<h3>Comments</h3> 
						
					<cfloop query="comments">
						<div class="ui-bar ui-bar-b">
						<p>
							<cfif application.gravatarsAllowed>
								<img src="http://www.gravatar.com/avatar/#lcase(hash(comments.email))#?s=40&amp;r=pg&amp;d=#application.rooturl#/images/gravatar.png" alt="#comments.name#'s Gravatar" border="0" align="left" style="padding-right: 10px;"/>
							</cfif>
							#comments.name#<BR>
							<!---<a href="#website#">#website#</a><BR>--->
							#application.localeUtils.dateLocaleFormat(comments.posted)# #application.localeUtils.timeLocaleFormat(comments.posted)#
							</p>
							<cfif application.gravatarsAllowed>
							
							</cfif>
						</div>
						<div class="ui-body ui-body-b">
							<p>
								#application.utils.ParagraphFormat2(application.utils.replaceLinks(comments.comment))#
							</p>
						</div>	
					</cfloop>
				</div>			
			</cfif>
		
		</cfif>
	</div><!-- /content -->	
	
	
	
	<cf_footer />
	<!-- /footer --> 
	
	
</div><!-- /page -->

</cfoutput>
