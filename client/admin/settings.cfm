<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/admin/index.cfm
	Author       : Raymond Camden
	Created      : 04/12/06
	Last Updated : 4/13/06
	History      : Various changes, forgotten keys, new keys (rkc 9/5/06)
				 : Comment moderation support (tr 12/7/06)
				 : support new properties (rkc 12/14/06)
				 : change moderate postings to moderate comments (rkc 4/13/07)
--->

<cfif not application.settings>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<!--- quick utility func to change foo,moo to foo<newline>moo and reverse --->
<cfscript>
function toLines(str) { return replace(str, ",", chr(10), "all"); }
function toList(str) {
	str = replace(str, chr(10), "", "all");
	str = replace(str, chr(13), ",", "all");
	return str;
}
</cfscript>


<cfset settings = application.blog.getProperties()>
<cfset validDBTypes = application.blog.getValidDBTypes()>

<cfloop item="setting" collection="#settings#">
	<cfparam name="form.#setting#" default="#settings[setting]#">
</cfloop>
<!---
we can use all the settings, but username and password may get overwritten
by a login attempt, see this bug report:
http://blogcfc.riaforge.org/index.cfm?event=page.issue&issueid=4CEC3A8A-C919-ED1E-17FD790A1A7DE997
--->
<cfparam name="form.dsn_username" default="#settings.username#">
<cfparam name="form.dsn_password" default="#settings.password#">

<cfif structKeyExists(form, "cancel")>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif structKeyExists(form, "save")>
	<cfset errors = arrayNew(1)>

	<cfif not len(trim(form.blogtitle))>
		<cfset arrayAppend(errors, "Your blog must have a title.")>
	</cfif>

	<cfif not len(trim(form.blogurl))>
		<cfset arrayAppend(errors, "Your blog url cannot be blank.")>
	<cfelseif right(form.blogurl, 9) is not "index.cfm">
		<cfset arrayAppend(errors, "The blogurl setting must end with index.cfm.")>
	</cfif>

	<cfif len(trim(form.commentsfrom)) and not application.utils.isEmail(form.commentsfrom)>
		<cfset arrayAppend(errors, "The commentsfrom setting must be a valid email address.")>
	</cfif>

	<cfif len(trim(form.failto)) and not application.utils.isEmail(form.failto)>
		<cfset arrayAppend(errors, "The failto setting must be a valid email address.")>
	</cfif>

	<cfif len(trim(form.maxentries)) and not isNumeric(form.maxentries)>
		<cfset arrayAppend(errors, "Max entries must be numeric.")>
	</cfif>

	<cfif len(trim(form.maxentriesadmin)) and not isNumeric(form.maxentriesadmin)>
		<cfset arrayAppend(errors, "Max entries Admin must be numeric.")>
	</cfif>

	<cfif len(trim(form.offset)) and not isNumeric(form.offset)>
		<cfset arrayAppend(errors, "Offset must be numeric.")>
	</cfif>

	<cfset form.pingurls = toList(form.pingurls)>

	<cfif not len(trim(form.dsn))>
		<cfset arrayAppend(errors, "Your blog must have a dsn.")>
	</cfif>

	<cfif not len(trim(form.locale))>
		<cfset arrayAppend(errors, "Your blog must have a locale.")>
	</cfif>

	<cfset form.ipblocklist = toList(form.ipblocklist)>
	<cfset form.trackbackspamlist = listSort(toList(form.trackbackspamlist),"textnocase")>

	<cfif not arrayLen(errors)>
		<!--- copy dsn_* --->
		<cfset form.username = form.dsn_username>
		<cfset form.password = form.dsn_password>

		<!--- make a list of the keys we will send. --->
		<cfset keylist = "blogtitle,blogdescription,blogkeywords,blogurl,commentsfrom,maxentries,maxentriesadmin,offset,pingurls,dsn,blogdbtype,locale,ipblocklist,moderate,usetweetbacks,trackbackspamlist,mailserver,mailusername,mailpassword,usecaptcha,allowgravatars,owneremail,username,password,filebrowse,imageroot,itunessubtitle,itunessummary,ituneskeywords,itunesauthor,itunesimage,itunesexplicit,usecfp,failto">
		<cfloop index="key" list="#keylist#">
			<cfif structKeyExists(form, key)>
				<cfset application.blog.setProperty(key, trim(form[key]))>
			</cfif>
		</cfloop>
		<cflocation url="settings.cfm?reinit=1&settingsupdated=1" addToken="false">
	</cfif>
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="Settings">

	<cfif structKeyExists(url, "settingsupdated")>
		<cfoutput>
			<div style="margin: 15px 0; padding: 15px; border: 5px solid ##008000; background-color: ##80ff00; color: ##000000; font-weight: bold; text-align: center;">
				Your settings have been updated and your cache refreshed.
			</div>
		</cfoutput>
	</cfif>

	<cfoutput>
	<p>
	Please edit your settings below. <b>Be warned:</b> A mistake here can make both the blog and this
	administrator unreachable. Be careful! ("Here be dragons...")
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
	</cfif>

	<cfoutput>
	<script>
		function editDatasource() {
			document.getElementById('datasource_edit').style.display='block';
			document.getElementById('datasource_ro').style.display='none';
			document.getElementById('datasource_editbutton').style.display='none';
		}
	</script>
	<form action="settings.cfm" method="post" name="settingsForm">
	<fieldset>
		<legend>Blog Information</legend>
		<ul>
			<li><label for="blogtitle">blog title:</label><input type="text" name="blogtitle" value="#htmlEditFormat(form.blogtitle)#" class="txtField" maxlength="255"></li>
			<li><label for="blogdescription">blog description:</label><textarea name="blogdescription" class="txtAreaShort">#htmlEditFormat(form.blogdescription)#</textarea></li>
			<li><label for="blogkeywords">blog keywords:</label><input type="text" name="blogkeywords" value="#htmlEditFormat(form.blogkeywords)#" class="txtField" maxlength="255"></li>
			<li><label for="owneremail">owner email:</label><input type="text" name="owneremail" value="#htmlEditFormat(form.owneremail)#" class="txtField" maxlength="255"></li>
			<li><label for="failto">fail to:</label><input type="text" name="failto" value="#htmlEditFormat(form.failto)#" class="txtField" maxlength="255"></li>
			<li><label for="blogurl">blog url:</label><input type="text" name="blogurl" value="#form.blogurl#" class="txtField" maxlength="255"></li>
		</ul>
	</fieldset>
	<fieldset>
		<legend>Content Settings</legend>
		<ul>		
			<li><label for="commentsfrom">comments sent from:</label><input type="text" name="commentsfrom" value="#form.commentsfrom#" class="txtField" maxlength="255"></li>
			<li><label for="maxentries">max entries:</label><input type="text" name="maxentries" value="#form.maxentries#" class="txtField" maxlength="255"></li>
		    <li><label for="maxentriesadmin">max entries admin:</label><input type="text" name="maxentriesadmin" value="#form.maxentriesadmin#" class="txtField" maxlength="255"></li>
			<li><label for="offset">offset:</label><input type="text" name="offset" value="#form.offset#" class="txtField" maxlength="255"></li>
			<li><label for="pingurls">ping urls:</label><textarea name="pingurls" class="txtAreaShort">#toLines(form.pingurls)#</textarea></li>
			<li><label for="locale">locale:</label><input type="text" name="locale" value="#form.locale#" class="txtField" maxlength="50"></li>
		</ul>
	</fieldset>
	<fieldset>
		<legend>Content Controls / Security</legend>
		<ul>
			<li><label for="ipblocklist">ip block list:</label><textarea name="ipblocklist" class="txtAreaShort">#toLines(form.ipblocklist)#</textarea></li>
			<li><label for="moderate">moderate comments:</label>
				<input type="radio" name="moderate" value="yes" <cfif form.moderate>checked</cfif>/> Yes
				<input type="radio" name="moderate" value="no" <cfif not form.moderate>checked</cfif>/> No
			</li>
			<li><label for="">use captcha:</label>
				<input type="radio" name="usecaptcha" value="yes" <cfif form.usecaptcha>checked</cfif>/> Yes
				<input type="radio" name="usecaptcha" value="no" <cfif not form.usecaptcha>checked</cfif>/> No
			</li>
			<li><label for="usecfp">use cfFormProtect:</label>
				<input type="radio" name="usecfp" value="yes" <cfif form.usecfp>checked</cfif>/> Yes
				<input type="radio" name="usecfp" value="no" <cfif not form.usecfp>checked</cfif>/> No
			</li>
			<li><label for="usetweetbacks">use tweetbacks:</label>
				<input type="radio" name="usetweetbacks" value="yes" <cfif form.usetweetbacks>checked</cfif>/> Yes
				<input type="radio" name="usetweetbacks" value="no" <cfif not form.usetweetbacks>checked</cfif>/> No
			</li>

			<li><label for="trackbackspamlist">spamlist:</label><textarea name="trackbackspamlist" class="txtAreaShort">#toLines(form.trackbackspamlist)#</textarea></li>
			<li><label for="allowgravatars">allow gravatars:</label>
				<input type="radio" name="allowgravatars" value="yes" <cfif form.allowgravatars>checked</cfif>/> Yes
				<input type="radio" name="allowgravatars" value="no" <cfif not form.allowgravatars>checked</cfif>/> No
			</li>
			<li><label for="filebrowse">show file manager:</label>
				<input type="radio" name="filebrowse" value="yes" <cfif form.filebrowse>checked</cfif>/> Yes
				<input type="radio" name="filebrowse" value="no" <cfif not form.filebrowse>checked</cfif>/> No
			</li>
			<li><label for="imageroot">image root for dynamic images:</label><input type="text" name="imageroot" value="#form.imageroot#" class="txtField" maxlength="50"></li>
		</ul>
	</fieldset>
	<fieldset id="datasource_edit" style='display:none'>
		<legend>Data Source (Edit mode)</legend>
		<ul>
			<li><label for="dsn">dsn:</label><input type="text" name="dsn" value="#form.dsn#" class="txtField" maxlength="50"></li>
			<li><label for="blogdbtype">blog database type:</label>
				<select name="blogdbtype">
				<cfloop index="dbtype" list="#validDBTypes#">
				<option value="#dbtype#" <cfif form.blogdbtype is dbtype>selected</cfif>>#dbtype#</option>
				</cfloop>
				</select>
			</li>
			<li><label for="dsn_username">dsn username:</label><input type="text" name="dsn_username" value="#form.dsn_username#" class="txtField" maxlength="255"></li>
			<li><label for="dsn_password">dsn password:</label><input type="text" name="dsn_password" value="#form.dsn_password#" class="txtField" maxlength="255"></li>
		</ul>
	</fieldset>
	<fieldset id="datasource_ro">
		<legend>Data Source</legend>
		<ul>
			<li><label>dsn:</label>#htmleditformat(form.dsn)#&nbsp;</li>
			<li><label>blog database type:</label>#htmleditformat(form.blogdbtype)#&nbsp;</li>
			<li><label>dsn username:</label>#htmleditformat(form.dsn_username)#&nbsp;</li>
			<li><label>dsn password:</label>#htmleditformat(form.dsn_password)#&nbsp;</li>
		</ul>
		<div class="buttonbar" id="datasource_editbutton">
			<a href="javascript:editDatasource();" class="button">Edit Data Source</a>
		</div>
	</fieldset>
	
	<fieldset>
		<legend>Mail Settings</legend>
		<ul>
			<li><label for="mailserver">mail server:</label><input type="text" name="mailserver" value="#form.mailserver#" class="txtField" maxlength="50"></li>
			<li><label for="mailusername">mail username:</label><input type="text" name="mailusername" value="#form.mailusername#" class="txtField" maxlength="50"></li>
			<li><label for="mailpassword">mail password:</label><input type="text" name="mailpassword" value="#form.mailpassword#" class="txtField" maxlength="50"></li>
		</ul>
	</fieldset>
	<fieldset>
		<legend>Podcasting</legend>
		<ul>
			<li><label for="itunessubtitle">itunes Subtitle:</label><input type="text" name="itunessubtitle" value="#form.itunessubtitle#" class="txtField" maxlength="50"></li>
			<li><label for="itunessummary">itunes Summary:</label><input type="text" name="itunessummary" value="#form.itunessummary#" class="txtField" maxlength="50"></li>
			<li><label for="ituneskeywords">itunes Keywords:</label><input type="text" name="ituneskeywords" value="#form.ituneskeywords#" class="txtField" maxlength="50"></li>
			<li><label for="itunesauthor">itunes Author:</label><input type="text" name="itunesauthor" value="#form.itunesauthor#" class="txtField" maxlength="50"></li>
			<li><label for="itunesimage">itunes Image:</label><input type="text" name="itunesimage" value="#form.itunesimage#" class="txtField" maxlength="50"></li>
			<li><label for="itunesexplicit">itunes Explicit:</label>
				<input type="radio" name="itunesexplicit" value="yes" <cfif form.itunesexplicit>checked</cfif>/> Yes
				<input type="radio" name="itunesexplicit" value="no" <cfif not form.itunesexplicit>checked</cfif>/> No
			</li>
		</ul>
	</fieldset>
	<div class="buttonbar">
		<a href="settings.cfm" class="button">Cancel Changes</a> <a href="javascript:document.settingsForm.submit();" class="button">Save Settings</a>
	</div>
	<input type="hidden" name="save" value="1">
	</form>
	</cfoutput>


</cfmodule>

<cfsetting enablecfoutputonly=false>