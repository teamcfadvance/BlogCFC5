<!---
Docs: This file has access to:

entries - query of entries
renderEntryLink(id) - pass the id, get the URL for the tnry
renderCategoryLink(cat) - pass a category name, get the link
renderCategoryListLink(cats) - pass a list, I'll return a nice, comma-delimited list of links and labels, with spaces too. Hot.
renderEnclosureLink(enclosure)
renderPrinterLink(id) - links to the print utility
renderSendLink(id) - links to the send utility
previousLink - if blank, no link to go back. if not blank, the link for more stuff
nextLink - see above, reverse it - hammer time
start - what row you started on
totalentries - total number of blog entries
settings - struct of all blog settings
themeurl - rooturl to theme
--->

<!---
<h2>Viewing Entries</h2>
<hr/>

<cfloop query="entries">
	<cfoutput>
	<div class="entry">
	<h1><a href="#renderEntryLink(id)#">#title#</a></h1>
	<h3>Posted at #dateFormat(posted)# #timeFormat(posted)# by #name#</h3>
	<h3>Posted in #renderCategoryListLink(categories)#</h3>
	#body#
	</cfoutput>
	</div>
</cfloop>

<p/>

<cfif len(previousLink)>
	<cfoutput><a href="#previousLink#">Older Crap</a></cfoutput>
</cfif>

<cfif len(previousLink) and len(nextLink)>
/
</cfif>
	
<cfif len(nextLink)>
	<cfoutput><a href="#nextLink#">Next Crap</a></cfoutput>
</cfif>	
--->

<cfif entries.recordCount is 0>
	<div class="body">
	Sorry, no entries can be displayed.
	</div>	
</cfif>

<cfloop query="entries">
	
	<cfoutput><div class="entry<cfif entries.currentRow EQ entries.recordCount>Last</cfif>"></cfoutput>
	
	<cfoutput>
	<h1><a href="#renderEntryLink(id)#">#title#</a></h1>
	
	<div class="byline">Posted At : #dateFormat(posted)# #timeFormat(posted)# 
	<cfif len(name)>| Posted By : <!---<a href="#application.blog.makeUserLink(name)#">#name#</a>--->#name#</cfif><br />
	Related Categories :#renderCategoryListLink(categories)#
	</div>
	</cfoutput>

	<cfoutput>		
	<div class="body">
	#paragraphformat(body)#

	<!--- STICK IN THE MP3 PLAYER --->
	<cfif enclosure contains "mp3">
		<cfset alternative=replace(getFileFromPath(enclosure),".mp3","") />
		<div class="audioPlayerParent">
			<div id="#alternative#" class="audioPlayer">
			</div>
		</div>
		<script type="text/javascript">
		// <![CDATA[
			var flashvars = {};
			// unique ID
			flashvars.playerID = "#alternative#";
			// load the file
			flashvars.soundFile= "#settings.rooturl#/enclosures/#getFileFromPath(enclosure)#";
			// Load width and Height again to fix IE bug
			flashvars.width = "470";
			flashvars.height = "24";
			// Add custom variables
			var params = {};
			params.allowScriptAccess = "sameDomain";
			params.quality = "high";
			params.allowfullscreen = "true";
			params.wmode = "transparent";
			var attributes = false;
			swfobject.embedSWF("#settings.rooturl#/includes/audio-player/player.swf", "#alternative#", "470", "24", "8.0.0","/includes/audio-player/expressinstall.swf", flashvars, params, attributes);
		// ]]>
		</script>
	</cfif>
	
	<cfif len(morebody)>
	<p align="right">
	<a href="#renderEntryLink(id)###more">[More]</a>
	</p>
	</cfif>
	</div>
	</cfoutput>

	<cfoutput>
	<div class="byline">
	</cfoutput>
	<cfif allowcomments or commentCount neq ""><cfoutput><img src="#themeurl#/images/comment.gif" align="middle" title="Comments" height="16" width="16" /> <a href="#renderEntryLink(id)###comments">Comments (<cfif commentCount is "">0<cfelse>#commentCount#</cfif>)</a> | </cfoutput></cfif>
	<cfoutput><img src="#themeurl#/images/printer.gif" align="middle" title="Print" height="16" width="16" /> <a href="#renderPrintLink(id)#" rel="nofollow">Print</a> | </cfoutput>
	<cfoutput><img src="#themeurl#/images/email.gif" align="middle" title="Send" height="16" width="16" /> <a href="#renderSendLink(id)#" rel="nofollow">Send</a> | </cfoutput>
	<cfif len(enclosure)><cfoutput><img src="#themeurl#/images/disk.png" align="middle" title="Download" height="16" width="16" /> <a href="#renderEnclosureLink(enclosure)#">Download</a> | </cfoutput></cfif>
	<cfoutput>
	#views# Views |  
	<!-- AddThis Button BEGIN -->
	<a href="http://www.addthis.com/bookmark.php?v=250" onmouseover="return addthis_open(this, '', '#URLEncodedFormat(renderEntryLink(id))#', '#URLEncodedFormat(settings.blogtitle)#')" onmouseout="addthis_close()" onclick="return addthis_sendto()"><img src="http://s7.addthis.com/static/btn/lg-share-en.gif" width="125" height="16" alt="Bookmark and Share" style="border:0"/></a><script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a20091556eefead"></script>
	<!-- AddThis Button END -->
	</div>
	</cfoutput>

	<!--- this div ends the entry div --->
	<cfoutput>
	</div>
	</cfoutput>

</cfloop>

<cfif len(previouslink) or len(nextlink)>

	<cfoutput>
	<p align="right">
	</cfoutput>
		
	<cfif len(previouslink)>
	
		<cfoutput>
		<a href="#previouslink#">Previous Entries</a>
		</cfoutput>

	</cfif>
		
	<cfif len(previouslink) and len(nextlink)>
		<cfoutput> / </cfoutput>
	</cfif>
		
	<cfif len(nextlink)>
		
		<cfoutput>
		<a href="#nextlink#">More Entries</a>
		</cfoutput>

	</cfif>

	<cfoutput>
	</p>
	</cfoutput>
	
</cfif>