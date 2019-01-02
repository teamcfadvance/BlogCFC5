<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\entry.cfm
	Author       : Raymond Camden 
	Created      : 04/07/06
	Last Updated : 1/14/08
	History      : Nuked old history for 5.7 (rkc 4/13/07)
				   Don't save text when editing existing entries (rkc 4/13/07)
				   Delete cookies on cancel (rkc 5/18/07)
				   Yet another date fix (rkc 1/14/08)
--->

<cftry>
	<cfif url.id neq 0>
		<cfset entry = application.blog.getEntry(url.id,true)>
		<cfif len(entry.morebody)>
			<cfset entry.body = entry.body & "<more/>" & entry.morebody>
		</cfif>

		<cfparam name="form.title" default="#entry.title#">
		<cfparam name="form.body" default="#entry.body#">
		<cfparam name="form.posted" default="#entry.posted#">
		<cfparam name="form.alias" default="#entry.alias#">
		<cfparam name="form.allowcomments" default="#entry.allowcomments#">
		<cfparam name="form.oldenclosure" default="#entry.enclosure#">
		<cfparam name="form.oldfilesize" default="#entry.filesize#">
		<cfparam name="form.oldmimetype" default="#entry.mimetype#">
		<cfparam name="form.released" default="#entry.released#">
		<cfparam name="form.duration" default="#entry.duration#">
		<cfparam name="form.keywords" default="#entry.keywords#">
		<cfparam name="form.subtitle" default="#entry.subtitle#">
		<cfparam name="form.summary" default="#entry.summary#">
		<cfif form.released>
			<cfparam name="form.sendemail" default="false">
		<cfelse>
			<cfparam name="form.sendemail" default="true">
		</cfif>
		
		
		<!--- handle case where form submitted, cant use cfparam --->
		<cfif not isDefined("form.save") and not isDefined("form.preview")>
			<cfset form.categories = structKeyList(entry.categories)>
			<cfset variables.relatedEntries = application.blog.getRelatedBlogEntries(url.id, true, true, true)>	
			<cfset form.relatedEntries = valueList(relatedEntries.id)>
		</cfif>
		
		
	<cfelse>
	
		<!--- look for savedtitle, savedbody from cookie, but only if not POSTing --->
		<cfif not structKeyExists(form, "title") and structKeyExists(cookie, "savedtitle")>
			<cfset form.title = cookie.savedtitle>
		</cfif>
		<cfif not structKeyExists(form, "body") and structKeyExists(cookie, "savedbody")>
			<cfset form.body = cookie.savedbody>
		</cfif>
			
		<cfif not isDefined("form.save") and not isDefined("form.return") and not isDefined("form.preview")>
			<cfset form.categories = "">
		</cfif>
		<cfparam name="form.title" default="">
		<cfparam name="form.body" default="">
		<cfparam name="form.alias" default="">
		<cfparam name="form.posted" default="#dateAdd("h", application.blog.getProperty("offset"), now())#">
		<cfparam name="form.allowcomments" default="">
		<cfparam name="form.oldenclosure" default="">
		<cfparam name="form.oldfilesize" default="0">
		<cfparam name="form.oldmimetype" default="">
		<!--- default released to false if no perms to release --->
		<cfparam name="form.released" default="#application.blog.isBlogAuthorized('ReleaseEntries')#">
		<cfparam name="form.duration" default="">
		<cfparam name="form.keywords" default="">
		<cfparam name="form.subtitle" default="">
		<cfparam name="form.summary" default="">
		<cfparam name="form.relatedEntries" default="">
		<cfparam name="form.sendemail" default="true">
	</cfif>
	<cfcatch>
		<!--- <cflocation url="entries.cfm" addToken="false"> --->
		<cfrethrow>
	</cfcatch>
</cftry>

<cfset allCats = application.blog.getCategories()>

<cfparam name="form.newcategory" default="">

<cfif structKeyExists(form, "cancel")>
	<cfcookie name="savedtitle" expires="now">
	<cfcookie name="savedbody" expires="now">
	<cflocation url="entries.cfm" addToken="false">
</cfif>

<cfif isDefined("form.delete_enclosure")>
	<cfif len(form.oldenclosure) and fileExists(form.oldenclosure)>
		<cffile action="delete" file="#form.oldenclosure#">
	</cfif>
	<cfset form.oldenclosure = "">
	<cfset form.oldfilesize = "0">
	<cfset form.oldmimetype = "">
	<!--- We need to set a msg to warn folks that they need to save the entry --->
	<cfif url.id is not "new">
		<cfset message = application.resourceBundle.getResource("enclosureentrywarning")>
	</cfif>
</cfif>

<!--- 
Enclosure logic move out to always run. Thinking is that it needs to run on preview.
--->
<cfif isDefined("form.enclosure") and len(trim(form.enclosure))>
	<cfset destination = expandPath("../enclosures")>
	<!--- first off, potentially make the folder --->
	<cfif not directoryExists(destination)>
		<cfdirectory action="create" directory="#destination#">
	</cfif>
	
	<cffile action="upload" filefield="enclosure" destination="#destination#" nameconflict="makeunique">
	<cfif cffile.filewassaved>
		<cfset form.oldenclosure = cffile.serverDirectory & "/" & cffile.serverFile>
		<cfset form.oldfilesize = cffile.filesize>
		<cfset form.oldmimetype = cffile.contenttype & "/" & cffile.contentsubtype>
	</cfif>
<cfelseif isDefined("form.manualenclosure") and len(trim(form.manualenclosure))>
	<cfset destination = expandPath("../enclosures")>
	<!--- first off, potentially make the folder --->
	<cfif not directoryExists(destination)>
		<cfdirectory action="create" directory="#destination#">
	</cfif>
	<cfif fileExists(destination & "/" & form.manualenclosure)>
		<cfset form.oldenclosure = destination & "/" & form.manualenclosure>
		<cfdirectory action="list" directory="#destination#" filter="#form.manualenclosure#" name="getfile">
		<cfset form.oldfilesize = getfile.size>
		<!---
		Thanks: http://www.coldfusionmuse.com/index.cfm/2006/8/2/mime.types
		--->
		<cftry>
			<cfset form.oldmimetype = getPageContext().getServletContext().getMimeType(form.oldenclosure)>
			<cfcatch>
				<!--- silently fail for BD.Net --->
			</cfcatch>
		</cftry>
		<cfif not isDefined("form.oldmimetype")>
			<cfset form.oldmimetype = "application/unknown">
		</cfif>
	</cfif>
</cfif>

<cfif not isNumeric(form.oldfilesize)>
	<cfset form.oldfilesize = 0>
</cfif>

<cfif isDefined("form.save")>

	<cfset errors = arrayNew(1)>
	<cfif not len(trim(form.title))>
		<cfset arrayAppend(errors, application.resourceBundle.getResource("mustincludetitle"))>
	<cfelse>
		<cfset form.title = trim(form.title)>
	</cfif>
	<!--- Set the locale --->
	<cfif not application.isColdFusionMX7>
		<cfset setLocale(application.localeUtils.java2CF())>
	<cfelse>
		<cfset setLocale(application.blog.getProperty("locale"))>
	</cfif>
	<cfif not lsIsDate(form.posted)>
		<cfset arrayAppend(errors, application.resourceBundle.getResource("invaliddate"))>
	</cfif>
	<cfif not len(trim(form.body))>
		<cfset arrayAppend(errors, application.resourceBundle.getResource("mustincludebody"))>
		<cfset origbody = "">
	<cfelse>
		<cfset form.body = trim(form.body)>
		
		<!--- Fix damn smart quotes. Thank you Microsoft! --->
		<!--- This line taken from Nathan Dintenfas' SafeText UDF --->
		<!--- www.cflib.org/udf.cfm/safetext --->
		<cfset form.body = replaceList(form.body,chr(8216) & "," & chr(8217) & "," & chr(8220) & "," & chr(8221) & "," & chr(8212) & "," & chr(8213) & "," & chr(8230),"',',"","",--,--,...")>

		<cfset origbody = form.body>

		<!--- Handle potential <more/> --->
		<!--- fix by Andrew --->
		<cfset strMoreTag = "<more/>">
		<cfset moreStart = findNoCase(strMoreTag,form.body)>
		<cfif moreStart gt 1>
			<cfset moreText = trim(mid(form.body,(moreStart+len(strMoreTag)),len(form.body)))>
			<cfset form.body = trim(left(form.body,moreStart-1))>
		<cfelseif moreStart is 1>
			<cfset arrayAppend(errors, application.resourceBundle.getResource("mustincludebody"))>
		<cfelse>
			<cfset moreText = "">
		</cfif>

	</cfif>
	
	<cfif (not isDefined("form.categories") or form.categories is "") and not len(trim(form.newCategory))>
		<cfset arrayAppend(errors, application.resourceBundle.getResource("mustincludecategory"))>
	<cfelseif application.blog.isBlogAuthorized('AddCategory')>
		<cfset form.newCategory = trim(htmlEditFormat(form.newCategory))>
		<!--- double check if existing --->
		<cfset cats = valueList(allCats.categoryName)>
		<cfif listFindNoCase(cats, form.newCategory)>
			<!--- This category already existed, loop and find id --->
			<cfloop query="allCats">
				<cfif form.newCategory is categoryName>
					<cfif not isDefined("form.categories")>
						<cfset form.categories = "">
					</cfif>
					<cfset form.categories = listAppend(form.categories, categoryID)>
					<cfset form.newcategory = "">
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfif len(form.alias)>
		<cfset form.alias = trim(htmlEditFormat(form.alias))>
	<cfelse>
		<!--- Auto create the alias --->
		<cfset form.alias = application.blog.makeTitle(form.title)>
	</cfif>
		
	<!---
	The purpose of this code:
	
	If you try to add an entry with an enclosure and your session timed out,
	you get forced back to login.cfm. I can't recreate the form w/ your file upload.
	So on login.cfm I notice it - and add a special form var named enclosureerror. 
	I throw an error to the user so he knows to re-pick the file fo rupload.
	--->
	<cfif structKeyExists(form, "enclosureerror")>
		<cfset arrayAppend(errors, "Your enclosure was removed because your session timed out. Please upload it again.")>
	</cfif>
		
	<cfif not arrayLen(errors)>
	
		<!--- convert datetime to native --->
		<cfset form.posted = lsParseDateTime(form.posted)>
		
		<!--- Before we save, modify the posted time by -1 * posted --->
		<cfset form.posted = dateAdd("h", -1 * application.blog.getProperty("offset"), form.posted)>

		<cfif isDefined("variables.entry")>
			<!--- Begin: Shane Zehnder | released posts should have the post date of when they're released --->
			<cfif (form.released eq "true") and (entry.released eq "false") and (dateCompare(dateAdd("h", application.blog.getProperty("offset"), form.posted), now()) lt 0)>
				<cfset form.posted = dateAdd("h", application.blog.getProperty("offset"), now()) />
			</cfif>
			<!--- End: Shane Zehnder --->

			<cfset application.blog.saveEntry(url.id, form.title, form.body, moreText, form.alias, form.posted, form.allowcomments, form.oldenclosure, form.oldfilesize, form.oldmimetype, form.released, form.relatedentries, form.sendemail, form.duration, form.subtitle, form.summary, form.keywords )>
		<cfelse>
			<cfif not application.blog.isBlogAuthorized('ReleaseEntries')>
				<cfset form.released = 0>
			</cfif>
			<cfset url.id = application.blog.addEntry(form.title, form.body, moreText, form.alias, form.posted, form.allowcomments, form.oldenclosure, form.oldfilesize, form.oldmimetype, form.released, form.relatedentries, form.sendemail, form.duration, form.subtitle, form.summary, form.keywords )>
		</cfif>
		<!--- remove all old cats that arent passed in --->
		<cfif url.id is not "new">
			<cfset application.blog.removeCategories(url.id)>
		</cfif>
		<!--- potentially add new cat --->
		<cfif len(trim(form.newCategory)) and application.blog.isBlogAuthorized('AddCategory')>
			<cfparam name="form.categories" default="">
			<cfset form.categories = listAppend(form.categories,application.blog.addCategory(form.newCategory, application.blog.makeTitle(newCategory)))>
		</cfif>
		<cfset application.blog.assignCategories(url.id,form.categories)>
		<cfmodule template="../tags/scopecache.cfm" scope="application" clearall="true">
		<cfcookie name="savedtitle" expires="now">
		<cfcookie name="savedbody" expires="now">
		<!--- force category cache refresh --->
		<cfset application.blog.getCategories(false)>

		<cflocation url="entries.cfm" addToken="false">
	<cfelse>
		<!--- restore body, since it loses more body --->
		<cfset form.body = origbody>
	</cfif>
</cfif>

<cfset allCats = application.blog.getCategories()>

<cfmodule template="../tags/adminlayout.cfm" title="Entry Editor">


	<cfif not structKeyExists(form, "preview")>

		<cfif len(application.imageroot)>
			<cfset sImgRoot = application.imageroot />
		<cfelse>
			<cfset sImgRoot = "/images/" />
		</cfif>
		
		<cfoutput>
		<script type="text/javascript">
		$(document).ready(function() {
			
			//create tabs
			$("##entrytabs").tabs()
	
			//handles searching
			getEntries = function() {
				$("##entries_dropdown").removeOption(/./);
				var id = $("##categories_dropdown option:selected").val()
				if(id==null) id=""
				var text = $("##titlefilter").val()
				text = $.trim(text)
				if(id == "" && text == "") return
				$("##entries_dropdown").ajaxAddOption("proxy.cfm?category="+id+"&text="+escape(text)+'&rand='+ Math.round(new Date().getTime()),{}, false)
			}
					
			$("##titlefilter").keyup(getEntries)
			
			//listen for select change on related
			$("##categories_dropdown").change(getEntries)
			
			$("##entries_dropdown").change(function () {
				var selid = $("option:selected", $(this)).val()
				var text = $("option:selected", $(this)).text()

				if($("##cbRelatedEntries").containsOption(selid)) return
			
				//sets the hidden form field
				var relEntry = $("##relatedentries")
				if(relEntry.val() == "") relEntry.val(selid)
				else relEntry.val(relEntry.val() + "," + selid)

				$("##cbRelatedEntries").addOption(selid,text,false)

			})

			$("##cbRelatedEntries").change(function() {
				var selid = $("option:selected", $(this)).val()
				
				if(selid == null) return
				$("##cbRelatedEntries").removeOption(selid)

				//quickly regen the hidden field
				var relEntry = $("##relatedentries")
				relEntry.val('')
				$("##cbRelatedEntries option").each(function() {
					var id = $(this).val()
					if(relEntry.val() == '') relEntry.val(id)
					else relEntry.val(relEntry.val() + "," + id)
				})
			})

			$("##uploadImage").click(function() {
				var imgWin = window.open('#application.rooturl#/admin/imgwin.cfm','imgWin','width=400,height=100,toolbar=0,resizeable=1,menubar=0')
				return false
			})			
			
			$("##browseImage").click(function() {
				var imgBrowse = window.open('#application.rooturl#/admin/imgbrowse.cfm','imgBrowse','width=800,height=800,toolbar=1,resizeable=1,menubar=1,scrollbars=1')	
				return false
			})


		})

		function newImage(str) {
			var imgstr = '<img src="#application.rooturl##application.utils.fixUrl("/#sImgRoot#/")#' + str + '" />';
			$("##body").val($("##body").val() + '\n' + imgstr)
		}

		<cfif url.id eq 0>
		//used to save your form info (title/body) in case your browser crashes
		function saveText() {
			var titleField = $("##title").val()
			var bodyField = $("##body").val()
			var expire = new Date();
			expire.setDate(expire.getDate()+7);
			
			//write title to cookie
			var cookieString = 'SAVEDTITLE='+escape(titleField)+'; expires='+expire.toGMTString()+'; path=/';
			document.cookie = cookieString;
			cookieString = 'SAVEDBODY='+escape(bodyField)+'; expires='+expire.toGMTString()+'; path=/';
			document.cookie = cookieString;
			window.setTimeout('saveText()',5000);
		}
		
		window.setTimeout('saveText()',5000);
		</cfif>
		</script>
		</cfoutput>
	
		<!--- 
		Ok, so this line below here has been the cuase of MUCH pain in agony. The problem is in noticing
		when you save and ensuring you have a valid date. I don't know why this is so evil, but it caused
		me a lot of trouble a few months back. A new bug cropped up where if you hit the 'new entry'
		url direct (entry.cfm?id=0), the date would default to odbc date. So now the logic ensures
		that you either have NO form post, of a form post with username from the login. 
		
		I can bet I'll be back here one day soon.
		--->
		<cfif lsIsDate(form.posted) and (not isDefined("form.fieldnames") or isDefined("form.username"))>
			<cfset form.posted = createODBCDateTime(form.posted)>
			<cfset form.posted = application.localeUtils.dateLocaleFormat(form.posted,"short") & " " & application.localeUtils.timeLocaleFormat(form.posted)>
		</cfif>

		<!--- tabs --->
		<cfoutput>
		<form action="entry.cfm?id=#url.id#" method="post" enctype="multipart/form-data" name="editForm" id="editForm" class="inlineLabels">

		<div id="entrytabs">

			<ul>
				<li><a href="##main"><span>Main</span></a></li>
				<li><a href="##additional"><span>Additional Settings</span></a></li>
				<li><a href="##related"><span>Related Entries</span></a></li>				
				<cfif url.id neq 0><li><a href="##comments"><span>Comments</span></a></li></cfif>
			</ul>
			
		<div id="main">	
		<p>
		You can use &lt;code&gt;....&lt;/code&gt; to add formatting to code blocks.<br />
		You can dynamically include textblocks using &lt;textblock label="..."&gt;.<br />
		If you want to show only a portion of your entry on the home page, separate your content with the &lt;more/&gt; tag.
		</p>		
		</cfoutput>
		
		<cfif structKeyExists(variables, "errors") and arrayLen(errors)>
			<cfoutput>
			<div class="errors">
			Please correct the following error(s):
			<ul>
			<cfloop index="x" from="1" to="#arrayLen(errors)#">
			<li>#errors[x]#</li>
			</cfloop>
			</ul>
			</div>
			</cfoutput>
		<cfelseif structKeyExists(variables, "message")>
			<cfoutput>
			<div class="message">
			#message#
			</div>
			</cfoutput>
		</cfif>
		
		<cfoutput>
		<fieldset class="inlineLabels">
		<div class="ctrlHolder">
			<label for="title">Title: </label>
			<input type="text" name="title" id="title" value="#htmlEditFormat(form.title)#" maxlength="100" class="textInput">
		</div>
		</fieldset>
		<fieldset class="blockLabels">
		<div class="ctrlHolder">
			<label for="body">Body: </label>
			</cfoutput><cfmodule template="../tags/textarea.cfm" fieldname="body" value="#htmlEditFormat(form.body)#" style="width:100%;min-height:500px"><cfoutput>		
			<br />
			<a href="" id="uploadImage">[Upload and Insert Image]</a> / <a href="" id="browseImage">[Browse Image Library]</a>
		</div>
		</fieldset>
		<fieldset class="inlineLabels">		
		<div class="ctrlHolder">
			<label for="categories">Categories: </label>
			<cfif allCats.recordCount><select name="categories" id="categories" multiple="multiple" size="4">
				<cfloop query="allCats">
				<option value="#categoryID#" <cfif isDefined("form.categories") and listFind(form.categories,categoryID)>selected</cfif>>#categoryName#</option>
				</cfloop>
				</select>
			</cfif>
		</div>
		</fieldset>
		<cfif application.blog.isBlogAuthorized('AddCategory')>
		<fieldset class="inlineLabels">		
		<div class="ctrlHolder">
			<label for="newcategory">Add  a New Category: </label>
			<input type="text" name="newcategory" id="newcategory" value="#htmlEditFormat(form.newcategory)#" maxlength="50">
		</div>
		</fieldset>
		</cfif>
		<fieldset class="inlineLabels">		
		<div class="ctrlHolder">
			<input type="hidden" name="oldenclosure" value="#form.oldenclosure#">
			<input type="hidden" name="oldfilesize" value="#form.oldfilesize#">
			<input type="hidden" name="oldmimetype" value="#form.oldmimetype#">
				<cfif len(form.oldenclosure)>#listLast(form.oldenclosure,"/\")# <input type="submit" name="delete_enclosure" value="#application.resourceBundle.getResource("deleteenclosure")#"><br/>
					<!--- JH dotComIT 11/7/07 added download link --->
					Download Link: <a href="#application.rooturl#/download.cfm/id/#id#/online/1/#urlEncodedFormat(getFileFromPath(oldenclosure))#">#application.rooturl#/download.cfm/id/#id#/online/1/#urlEncodedFormat(getFileFromPath(oldenclosure))#</a>
				<Cfelse>
					Download Link: Won't show up until you save the entry and the UniqueID is generated
				</cfif>
			<label for="enclosure">Enclosure: </label>
			<input name="enclosure" id="enclosure" size="30" type="file" class="fileUpload" />
		</div>	
		</fieldset>
		<fieldset class="inlineLabels">				
		<div class="ctrlHolder">
			<label for="manualenclosure">Manually Set Enclosure: </label>
			<input type="text" name="manualenclosure" id="manualenclosure" class="textInput">
		</div>		
		</fieldset>
		<cfif len(form.oldenclosure)>
		<div class="ctrlHolder">
		#listLast(form.oldenclosure,"/\")# <input type="submit" name="delete_enclosure" value="#application.resourceBundle.getResource("deleteenclosure")#">	
		</div>
		</cfif>
		</fieldset>
			
		</div>
		</cfoutput>
		
		<!--- tab 2 --->
		<cfoutput>

		<div id="additional">	
			<fieldset class="inlineLabels">
			<div class="ctrlHolder">
				<label for="posted">Posted: </label>
				<input type="text" name="posted" id="posted" value="#form.posted#" maxlength="100" class="textInput">
			</div>
			<div class="ctrlHolder">
				<label for="alias">Alias: </label>
				<input type="text" name="alias" id="alias" value="#form.alias#" maxlength="100" class="textInput">
			</div>
			<div class="ctrlHolder">
				<label for="allowcomments">Allow Comments: </label>
				<select name="allowcomments" id="allowcomments">
				<option value="true" <cfif form.allowcomments is "true">selected</cfif>>Yes</option>
				<option value="false" <cfif form.allowcomments is "false">selected</cfif>>No</option>
				</select>
			</div>
			<div class="ctrlHolder">
				<label for="sendemail">Email Blog Entry: </label>
				<select name="sendemail" id="sendemail">
				<option value="true" <cfif form.sendemail is "true">selected</cfif>>Yes</option>
				<option value="false" <cfif form.sendemail is "false">selected</cfif>>No</option>
				</select>
			</div>
			<div class="ctrlHolder">
				<label for="released">Released: </label>
				<cfif application.blog.isBlogAuthorized('ReleaseEntries')>
					<select name="released" id="released">
					<option value="true" <cfif form.released is "true">selected</cfif>>Yes</option>
					<option value="false" <cfif form.released is "false">selected</cfif>>No</option>
					</select>
				<cfelse>
					#yesNoFormat(form.released)#
				</cfif>
			</div>
			<div class="ctrlHolder">
				<label for="subtitle">iTunes Subtitle: </label>
				<input type="text" name="subtitle" id="subtitle" value="#form.subtitle#" maxlength="100" class="textInput">
			</div>
			<div class="ctrlHolder">
				<label for="keywords">iTunes Keywords: </label>
				<input type="text" name="keywords" id="keywords" value="#form.keywords#" maxlength="100" class="textInput">
			</div>
			<div class="ctrlHolder">
				<label for="keywords">iTunes Keywords: </label>
				<input type="text" name="keywords" id="keywords" value="#form.keywords#" maxlength="100" class="textInput">
			</div>
			<div class="ctrlHolder">
				<label for="summary">iTunes Summary: </label>
				</cfoutput><cfmodule template="../tags/textarea.cfm" fieldname="summary" value="#htmlEditFormat(form.summary)#" style="min-height:250px"><cfoutput>
			</div>
			<div class="ctrlHolder">
				<label for="duration">Duration: </label>
				<input type="text" name="duration" id="duration" value="#form.duration#" maxlength="10" class="textInput">
			</div>
			</fieldset>
		</div>

		<div id="related">	
			<p>
			Use the form below to search for and add related entries to this blog entry. When you relate one blog entry to another, you automatically create a connection from that entry back to this one. 
			To add a related entry, use either of the below filters to retrieve matching blog entries. (Note that the entries listed only contain the previous 200 blog entries posted that match your criteria.)
			Click an entry to add it to the list of currently related entries.
			</p>

			<fieldset class="inlineLabels">
			<div class="ctrlHolder">
				<label for="titlefilter">Filter By Text: </label>
				<input type="text" name="titlefilter" id="titlefilter" maxlength="100" class="textInput">
			</div>
			<div class="ctrlHolder">
				<label for="categories_dropdown">Filter by Category: </label>
				<select id="categories_dropdown" size="4" style="width:50%">
				<cfloop query="allCats">
				<option value="#categoryid#">#categoryname#</option>
				</cfloop>
				</select>
			</div>
			</fieldset>
			<fieldset class="blockLabels">
			<div class="ctrlHolder">
				<label for="entries_dropdown">Entries: </label>
				<select id="entries_dropdown" size="4" style="width:100%;cursor:pointer;">
				</select>
			</div>
			<div class="ctrlHolder">
	        	<input type="hidden" name="relatedentries" id="relatedentries" value="#form.relatedentries#">
				<label for="cbRelatedEntries">Current Related Entries: (clicking removes an entry)</label>
					<select id="cbRelatedEntries" name="cbRelatedEntries" multiple="multiple" size="4" style="width: 100%;cursor:pointer;" >
					<cfif structKeyExists(variables, "relatedEntries")>
						<cfloop query="relatedEntries">
						<option value="#id#">#title#</option>
						</cfloop>
					<cfelse>
						<cfloop list="#form.relatedentries#" index="i">
						<option value="#i#">#application.blog.getEntry(i).title#</option>
						</cfloop>
					</cfif>
					</select>
				</div>
			</fieldset>

		</div>
		
		<cfif url.id neq 0>
		<div id="comments">
				<iframe
					src="entry_comments.cfm?id=#url.id#" 
					id="commentsFrame"
					name="commentsFrame"
					style="width: 100%; min-height: 500px; overflow-y: hidden;"
					scrolling="false"
					frameborder="0" 
					marginheight="0" 
					marginwidth="0"></iframe>
		</div>
		</cfif>
		
		<!--- closes tabs area --->
		</div>

		<p>
		<input type="submit" name="cancel" value="Cancel" onClick="return confirm('Are you sure you want to cancel this entry?')"> <input type="submit" name="preview" value="Preview"> <input type="submit" name="save" value="Save">
		</p>
		
		</form>
		</cfoutput>

	<cfelse>

		<cfif not application.isColdFusionMX7>
			<cfset setLocale(application.localeUtils.java2CF())>
		<cfelse>
			<cfset setLocale(application.blog.getProperty("locale"))>
		</cfif>

		<cfset posted = lsParseDateTime(form.posted)>
		<cfset posted = dateAdd("h", -1 * application.blog.getProperty("offset"), posted)>
		
		<cfparam name="form.categories" default="">
		
		<!--- Handles previews. --->
		<cfoutput>
		<div class="previewEntry">
		<h1>#form.title#</h1>
		
		<div style="margin-bottom: 10px">#application.resourceBundle.getResource("postedat")# : #application.localeUtils.dateLocaleFormat(posted)# #application.localeUtils.timeLocaleFormat(posted)#
		| #application.resourceBundle.getResource("postedby")# : #application.blog.getNameForUser(getAuthUser())#<br />
		#application.resourceBundle.getResource("relatedcategories")#:
		<cfloop index="x" from=1 to="#listLen(form.categories)#">
		<a href="#application.blog.makeCategoryLink(listGetAt(form.categories,x))#">#application.blog.getCategory(listGetAt(form.categories,x)).categoryname#</a><cfif x is not listLen(form.categories)>,</cfif>
		</cfloop>
		</div>
		
		#application.blog.renderEntry(form.body,false,form.oldenclosure)#
		</div>
		</cfoutput>
		
		<cfoutput>
		<form action="entry.cfm?#cgi.query_string#" method="post">
		<cfloop item="key" collection="#form#">
			<cfif not listFindNoCase("preview,fieldnames,enclosure,username", key)>
				<input type="hidden" name="#key#" value="#htmlEditFormat(form[key])#">
			</cfif>
		</cfloop>
		<input type="submit" name="return" value="Return"> <input type="submit" name="save" value="Save">
		</form>
		</cfoutput>

	</cfif>
	
</cfmodule>


<cfsetting enablecfoutputonly=false>
