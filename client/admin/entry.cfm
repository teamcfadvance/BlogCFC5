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
			<cfset variables.relatedEntries = application.blog.getRelatedBlogEntries(url.id, true, true)>	
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
		<cfparam name="form.released" default="true">
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
		<cfset form.oldmimetype = getPageContext().getServletContext().getMimeType(form.oldenclosure)>
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
	<cfelse>
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
			<cfset application.blog.saveEntry(url.id, form.title, form.body, moreText, form.alias, form.posted, form.allowcomments, form.oldenclosure, form.oldfilesize, form.oldmimetype, form.released, form.relatedentries, form.sendemail, form.duration, form.subtitle, form.summary, form.keywords )>
		<cfelse>
			<cfset url.id = application.blog.addEntry(form.title, form.body, moreText, form.alias, form.posted, form.allowcomments, form.oldenclosure, form.oldfilesize, form.oldmimetype, form.released, form.relatedentries, form.sendemail, form.duration, form.subtitle, form.summary, form.keywords )>
		</cfif>
		<!--- remove all old cats that arent passed in --->
		<cfif url.id is not "new">
			<cfset application.blog.removeCategories(url.id)>
		</cfif>
		<!--- potentially add new cat --->
		<cfif len(trim(form.newCategory))>
			<cfparam name="form.categories" default="">
			<cfset form.categories = listAppend(form.categories,application.blog.addCategory(form.newCategory, application.blog.makeTitle(newCategory)))>
		</cfif>
		<cfset application.blog.assignCategories(url.id,form.categories)>
		<cfmodule template="../tags/scopecache.cfm" scope="application" clearall="true">
		<cfcookie name="savedtitle" expires="now">
		<cfcookie name="savedbody" expires="now">
		<cflocation url="entries.cfm" addToken="false">
	<cfelse>
		<!--- restore body, since it loses more body --->
		<cfset form.body = origbody>
	</cfif>
</cfif>

<cfset allCats = application.blog.getCategories()>

<cfmodule template="../tags/adminlayout.cfm" title="Entry Editor">

	<cfoutput>
	<link rel="stylesheet" type="text/css" href="#application.rooturl#/includes/tab.css">
	<script type="text/javascript" src="#application.rooturl#/includes/tabber.js"></script>
	<script type="text/javascript">
	//Used to hide tabber flash
	document.write('<style type="text/css">.tabber{display:none;}<\/style>');
	</script>
	</cfoutput>

	<cfif not structKeyExists(form, "preview")>

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
		<form action="entry.cfm?id=#url.id#" method="post" enctype="multipart/form-data" name="editForm" id="editForm">

		<div class="tabber">

		<div class="tabbertab" title="Main">	
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
		<script type="text/javascript" src="#application.rooturl#/includes/spry/xpath.js"></script>
		<script type="text/javascript" src="#application.rooturl#/includes/spry/SpryData.js"></script>
		<script type="text/javascript">
		var dsCategories = new Spry.Data.XMLDataSet("spryproxy.cfm?method=getcategories", "categories/category");
		var dsEntries = new Spry.Data.XMLDataSet("spryproxy.cfm?method=getentries&category={dsCategories::CATEGORYID}", "entries/entry");		
		
		function addEntry(id) { 
			// was this ID already added?
			for(var i = 0; i < document.editForm.cbRelatedEntries.length; i++) {
				if(document.editForm.cbRelatedEntries.options[i].value == id) return;
			}
			
			//sets the hidden form field
			if(document.editForm.relatedentries.value == '') document.editForm.relatedentries.value = id;
			else document.editForm.relatedentries.value = document.editForm.relatedentries.value + "," + id;

			//We can't pass in the title as it may have a ', and with Spry I can't pre-filter the content for JS safeness.
			//So I passed in row num, which should equal the option
			var data = dsEntries.getData();
			for(var i = 0; i < data.length; i++) {
				if(data[i]["ID"] == id) title = data[i]["TITLE"];	
			}
			//sets the new combox 
			var opt = new Option(title,id);
			document.editForm.cbRelatedEntries.options[document.editForm.cbRelatedEntries.options.length] = opt;
		}
		
		function removeSelected() {
			for(var i = document.editForm.cbRelatedEntries.length-1; i >= 0; i--) {
				if(document.editForm.cbRelatedEntries.options[i].selected) document.editForm.cbRelatedEntries.options[i] = null;
			}
			//quickly regen the hidden field
			document.editForm.relatedentries.value = '';
			for(var i = 0; i < document.editForm.cbRelatedEntries.length; i++) {
				if(document.editForm.relatedentries.value == '') document.editForm.relatedentries.value = document.editForm.cbRelatedEntries.options[i].value;
				else document.editForm.relatedentries.value = document.editForm.relatedentries.value + "," + document.editForm.cbRelatedEntries.options[i].value;				
			}			
		}
		
		//for image upload
		function imgUpload() {
			var imgWin = window.open('#application.rooturl#/admin/imgwin.cfm','imgWin','width=400,height=100,toolbar=0,resizeable=1,menubar=0');	
		}
		
		function newImage(str) {
			var imgstr = '<img src="#application.rooturl#/images/#application.imageroot#/' + str + '">';
			var textbox = document.getElementById('body');
			textbox.value = textbox.value + '\n' + imgstr;
		}

		//for image browse
		function imgBrowse() {
			var imgBrowse = window.open('#application.rooturl#/admin/imgbrowse.cfm','imgBrowse','width=800,height=800,toolbar=1,resizeable=1,menubar=1,scrollbars=1');	
		}

		<cfif url.id eq 0>
		//used to save your form info (title/body) in case your browser crashes
		function saveText() {
			var titleField = Spry.$("title");
			var bodyField = Spry.$("body");
			var expire = new Date();
			expire.setDate(expire.getDate()+7);
			
			//write title to cookie
			var cookieString = 'SAVEDTITLE='+escape(titleField.value)+'; expires='+expire.toGMTString()+'; path=/';
			document.cookie = cookieString;
			cookieString = 'SAVEDBODY='+escape(bodyField.value)+'; expires='+expire.toGMTString()+'; path=/';
			document.cookie = cookieString;
			window.setTimeout('saveText()',5000);
		}
		
		window.setTimeout('saveText()',5000);
		</cfif>
		</script>

		<table width="75%"	>
			<tr>
				<td align="right">title:</td>
				<td><input type="text" name="title" id="title" value="#htmlEditFormat(form.title)#" class="txtField" maxlength="100"></td>
			</tr>
			<tr valign="top">
				<td align="right">body:</td>
				<td>
				</cfoutput><cfmodule template="../tags/textarea.cfm" fieldname="body" value="#htmlEditFormat(form.body)#" class="txtArea"><cfoutput>
				<br />
				<a href="javascript:imgUpload()">[Upload and Insert Image]</a> / <a href="javascript:imgBrowse()">[Browse Image Library]</a>
				</td>
			</tr>
			<tr valign="top">
				<td align="right">categories:</td>
				<td><cfif allCats.recordCount><select name="categories" multiple size=4 class="txtDropdown">
				<cfloop query="allCats">
				<option value="#categoryID#" <cfif isDefined("form.categories") and listFind(form.categories,categoryID)>selected</cfif>>#categoryName#</option>
				</cfloop>
				</select><br></cfif>
				 </td>
			</tr>
			<tr valign="top">
				<td align="right">new category:</td>
				<td><input type="text" name="newcategory" value="#htmlEditFormat(form.newcategory)#" class="txtField" maxlength="50"></td>
			</tr>
			<tr><td colspan="2"><br /></td></tr>		
			<tr valign="top">
				<td align="right">enclosure:</td>
				<td>
				<input type="hidden" name="oldenclosure" value="#form.oldenclosure#">
				<input type="hidden" name="oldfilesize" value="#form.oldfilesize#">
				<input type="hidden" name="oldmimetype" value="#form.oldmimetype#">
				<input type="file" name="enclosure" style="width:100%"> 
				or manually enter a file name (must exist under encloses folder) 
				<input type="text" name="manualenclosure">
				
				<cfif len(form.oldenclosure)><br /><br />#listLast(form.oldenclosure,"/\")# <input type="submit" name="delete_enclosure" value="#application.resourceBundle.getResource("deleteenclosure")#"></cfif>

				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="cancel" value="Cancel" onClick="return confirm('Are you sure you want to cancel this entry?')"> <input type="submit" name="preview" value="Preview"> <input type="submit" name="save" value="Save"></td>
			</tr>
		</table>
		</div>
		</cfoutput>
		
		<!--- tab 2 --->
		<cfoutput>
		<div class="tabbertab" title="Additional Settings">	
			<table>
			<tr>
				<td align="right">posted:</td>
				<td><input type="text" name="posted" value="#form.posted#" class="txtField" maxlength="100"></td>
			</tr>			
			<tr valign="top">
				<td>related entries:</td>
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0" style="padding: 5px;">
					<tr>
						<td width="50%"><strong>Categories</strong></td>
						<td width="50%">
				  			<div style="float:left;"><strong>Entries</strong></div> 
							<div style="float:right; padding-right: .5em;"> 
								Sort By:  
								<a href="javascript:void(0);" id="sortLinkDate" onclick="dsEntries.sort('POSTED','toggle')" style="color:rgb(0, 0, 255);">Date</a> |  
								<a href="javascript:void(0);" id="sortLinkTitle" onclick="dsEntries.sort('TITLE','toggle')" style="color:rgb(128, 128, 128);">Title</a>  
							</div>
						</td>
		        	</tr>
			        <tr>
		    	      <td style="padding-right: 5px;">
						<div id="Categories_DIV" spry:region="dsCategories">
						<select id="Categories_DropDown" onchange="dsCategories.setCurrentRow(this.selectedIndex)" multiple="multiple" size="4" style="width:100%;" >
						<option spry:repeat="dsCategories" id="{CATEGORYID}">{CATEGORYNAME}</option>
						</select>
						</div>
		    	      </td>
		        	  <td><!---dsEntries.setCurrentRow(this.selectedIndex)--->
						<div id="Entries_DIV" spry:region="dsEntries">
						<select id="Entries_DropDown" onchange="addEntry(this.options[this.selectedIndex].value);" size="4" style="width:100%;" >
						<option spry:repeat="dsEntries" value="{ID}">{TITLE}</option>
						</select>
						</div>
		        	  </td>
			        </tr>
			        <tr>
			        	<td width="100%" colspan="2"><strong>Current Related Entries</strong></td>
			        </tr>
			        <tr valign="top">
			        	<td width="100%" colspan="2">
			        	<input type="hidden" name="relatedentries" value="#form.relatedentries#">
						<select id="cbRelatedEntries" name="cbRelatedEntries" multiple="multiple" size="4" style="width: 70%;" >
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
						<input type="button" value="Remove Selected" onClick="removeSelected()">
			        	</td>
			        </tr>
					</table>
				</td>
			</tr>
				
			<tr>
				<td align="right">alias:</td>
				<td><input type="text" name="alias" value="#form.alias#" class="txtField" maxlength="100"></td>
			</tr>
			<tr>
				<td align="right">iTunes Subtitle:</td>
				<td><input type="text" name="subtitle" value="#form.subtitle#" class="txtField" maxlength="100"></td>
			</tr>
			<tr>
				<td align="right">iTunes Keywords:</td>
				<td><input type="text" name="keywords" value="#form.keywords#" class="txtField" maxlength="100"></td>
			</tr>
			<tr>
				<td align="right">iTunes Summary:</td>
				<td></cfoutput><cfmodule template="../tags/textarea.cfm" fieldname="summary" value="#htmlEditFormat(form.summary)#" class="txtArea"><cfoutput></td>
			</tr>
			<tr>
				<td align="right">duration:</td>
				<td><input type="text" name="duration" value="#form.duration#" class="txtField" maxlength="10"></td>
			</tr>
			<tr>
				<td align="right">allow comments:</td>
				<td>
				<select name="allowcomments">
				<option value="true" <cfif form.allowcomments is "true">selected</cfif>>Yes</option>
				<option value="false" <cfif form.allowcomments is "false">selected</cfif>>No</option>
				</select>
				</td>
			</tr>
			<tr>
				<td align="right">send blog entry<br />to subscribers:</td>
				<td>
				<select name="sendemail">
				<option value="true" <cfif form.sendemail is "true">selected</cfif>>Yes</option>
				<option value="false" <cfif form.sendemail is "false">selected</cfif>>No</option>
				</select>
				</td>
			</tr>
			<tr>
				<td align="right">released:</td>
				<td>
				<select name="released">
				<option value="true" <cfif form.released is "true">selected</cfif>>Yes</option>
				<option value="false" <cfif form.released is "false">selected</cfif>>No</option>
				</select>
				</td>
			</tr>
			<tr>
        	    <td>&nbsp;</td>
            	<td><input type="submit" name="cancel" value="Cancel" onClick="return confirm('Are you sure you want to cancel this entry?')"> <input type="submit" name="preview" value="Preview"> <input type="submit" name="save" value="Save"></td>
			</tr>				
			</table>
		</div>
		</cfoutput>
		
		<!--- end all tabs --->
		<cfoutput>
		</div>
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
