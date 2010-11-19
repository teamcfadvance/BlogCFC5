

<cfset dataError = false>
<cfset thisItem = listlast(cgi.path_info, "/")>

<cftry>
	<cfset entryData = application.blog.getEntry(thisItem)>
	<cfset comments = application.blog.getCommentCount(thisItem)>	
	<!---catch an attept to load an unreleased entry--->
	<cfif NOT entryData.released>
		<cfset dataError = true>	
	</cfif>
	
<cfcatch type="any">
	<cfset dataError = true>
</cfcatch>

</cftry>
<cfoutput>
	<div id="#hash(thisItem)#">
	    <div class="toolbar">
	        <h1>Post Detail</h1>
	        <a class="button back" href="##">Back</a>
	    </div>
	
		<cfif dataError>		
			<div class="body">
				There was an error attempting to load the post.
			</div>
		<cfelse>
			<div class="body">
				<p style="font-size:12px;">				
					<span style="font-size: 14px;">#entryData.title#</span><br><br>
					<strong>Posted:</strong> #application.localeUtils.dateLocaleFormat(entryData.posted)# #application.localeUtils.timeLocaleFormat(entryData.posted)#<br/>
					<strong>By:</strong> #entryData.name#<br>
					<strong>Categories:</strong> 
					<cfset lastid = listLast(structKeyList(entryData.categories))>
					<cfloop item="catid" collection="#entryData.categories#">
						#entryData.categories[catid]#<cfif catid is not lastid>, </cfif>
					</cfloop><br/>
					<cfif len(entryData.enclosure)><cfoutput>Download: <a href="#application.rooturl#/enclosures/#urlEncodedFormat(getFileFromPath(entryData.enclosure))#">#getFileFromPath(entryData.enclosure)#</a></cfoutput></cfif>																	
				</p>
			</div>
			
			<div style="padding: 10px 10px 0 10px;">
				<div>
					<!---
						pre render rereplace is here to correct rendering issue caused by the renderer
					--->
					<cfsavecontent variable="pBody">
					#REReplace("<p>" & entryData.body & "</p>", "\r+\n\r+\n", "</p><BR><p>", "ALL")#
					<BR>
					#REReplace("<p>" & entryData.morebody & "</p>", "\r+\n\r+\n", "</p><BR><p>", "ALL")#
					</cfsavecontent>
					
					<!--- overrides jqtouch's default handling of links by 
					adding blank target to links  and rel attribute to all images --->
					<cfset linkRep = '<a target="_blank"'>
					<cfset pBody = replaceNoCase(pBody, '<a', linkRep, 'all')>
					
					<cfset imgRep = '<img rel="external"'>
					<cfset pBody = replaceNoCase(pBody, '<img', imgRep, 'all')>
					
					#application.blog.renderEntry(pBody,true,'', true)#
				</div>					
			</div>			
		
			<cfif comments>
			<ul class="edgetoedge" >	
				<li style="text-align: center;"><a href="postComments.cfm/#thisItem#">View Comments</a></li>
			</ul>
			
			</cfif>
		</cfif>
	</div>

</cfoutput>