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

	<cfif len(trim(form.commentsfrom)) and not isEmail(form.commentsfrom)>
		<cfset arrayAppend(errors, "The commentsfrom setting must be a valid email address.")>
	</cfif>

	<cfif len(trim(form.maxentries)) and not isNumeric(form.maxentries)>
		<cfset arrayAppend(errors, "Max entries must be numeric.")>
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
		<cfset keylist = "blogtitle,blogdescription,blogkeywords,blogurl,commentsfrom,maxentries,offset,pingurls,dsn,blogdbtype,locale,ipblocklist,moderate,allowtrackbacks,usetweetbacks,trackbackspamlist,mailserver,mailusername,mailpassword,usecaptcha,allowgravatars,owneremail,username,password,filebrowse,imageroot,itunessubtitle,itunessummary,ituneskeywords,itunesauthor,itunesimage,itunesexplicit,usecfp">
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
			<div style="margin: 15px 0; padding: 15px; border: 5px solid ##cd6f6f; background-color: ##f79992; color: ##c54043; font-weight: bold; text-align: center;">
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
	<form action="settings.cfm" method="post">
	<table>
		<tr>
			<td align="right">blog title:</td>
			<td><input type="text" name="blogtitle" value="#htmlEditFormat(form.blogtitle)#" class="txtField" maxlength="255"></td>
		</tr>
		<tr valign="top">
			<td align="right">blog description:</td>
			<td><textarea name="blogdescription" class="txtAreaShort">#htmlEditFormat(form.blogdescription)#</textarea></td>
		</tr>
		<tr valign="top">
			<td align="right">blog keywords:</td>
			<td><input type="text" name="blogkeywords" value="#htmlEditFormat(form.blogkeywords)#" class="txtField" maxlength="255"></td>
		</tr>
		<tr valign="top">
			<td align="right">owner email:</td>
			<td><input type="text" name="owneremail" value="#htmlEditFormat(form.owneremail)#" class="txtField" maxlength="255"></td>
		</tr>
		<tr>
			<td align="right">blog url:</td>
			<td><input type="text" name="blogurl" value="#form.blogurl#" class="txtField" maxlength="255"></td>
		</tr>
		<tr>
			<td align="right">comments sent from:</td>
			<td><input type="text" name="commentsfrom" value="#form.commentsfrom#" class="txtField" maxlength="255"></td>
		</tr>
		<tr>
			<td align="right">max entries:</td>
			<td><input type="text" name="maxentries" value="#form.maxentries#" class="txtField" maxlength="255"></td>
		</tr>
		<tr>
			<td align="right">offset:</td>
			<td><input type="text" name="offset" value="#form.offset#" class="txtField" maxlength="255"></td>
		</tr>
		<tr valign="top">
			<td align="right">ping urls:</td>
			<td><textarea name="pingurls" class="txtAreaShort">#toLines(form.pingurls)#</textarea></td>
		</tr>
		<tr>
			<td align="right">dsn:</td>
			<td><input type="text" name="dsn" value="#form.dsn#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">blog database type:</td>
			<td>
			<select name="blogdbtype">
			<cfloop index="dbtype" list="#validDBTypes#">
			<option value="#dbtype#" <cfif form.blogdbtype is dbtype>selected</cfif>>#dbtype#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr valign="top">
			<td align="right">dsn username:</td>
			<td><input type="text" name="dsn_username" value="#form.dsn_username#" class="txtField" maxlength="255"></td>
		</tr>
		<tr valign="top">
			<td align="right">dsn password:</td>
			<td><input type="text" name="dsn_password" value="#form.dsn_password#" class="txtField" maxlength="255"></td>
		</tr>
		<tr>
			<td align="right">locale:</td>
			<td><input type="text" name="locale" value="#form.locale#" class="txtField" maxlength="50"></td>
		</tr>
		<tr valign="top">
			<td align="right">ip block list:</td>
			<td><textarea name="ipblocklist" class="txtAreaShort">#toLines(form.ipblocklist)#</textarea></td>
		</tr>
		<tr>
			<td align="right">moderate comments:</td>
			<td>
			<select name="moderate">
			<option value="yes" <cfif form.moderate>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.moderate>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right">use captcha:</td>
			<td>
			<select name="usecaptcha">
			<option value="yes" <cfif form.usecaptcha>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.usecaptcha>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right">use cfFormProtect:</td>
			<td>
			<select name="usecfp">
			<option value="yes" <cfif form.usecfp>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.usecfp>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right">use tweetbacks:</td>
			<td>
			<select name="usetweetbacks">
			<option value="yes" <cfif form.usetweetbacks>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.usetweetbacks>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right">allow trackbacks:</td>
			<td>
			<select name="allowtrackbacks">
			<option value="yes" <cfif form.allowtrackbacks>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.allowtrackbacks>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr valign="top">
			<td align="right">trackback spamlist:</td>
			<td><textarea name="trackbackspamlist" class="txtAreaShort">#toLines(form.trackbackspamlist)#</textarea></td>
		</tr>
		<tr>
			<td align="right">allow gravatars:</td>
			<td>
			<select name="allowgravatars">
			<option value="yes" <cfif form.allowgravatars>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.allowgravatars>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right">show file manager:</td>
			<td>
			<select name="filebrowse">
			<option value="yes" <cfif form.filebrowse>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.filebrowse>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right">image root for dynamic images:</td>
			<td><input type="text" name="imageroot" value="#form.imageroot#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">mail server:</td>
			<td><input type="text" name="mailserver" value="#form.mailserver#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">mail username:</td>
			<td><input type="text" name="mailusername" value="#form.mailusername#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">mail password:</td>
			<td><input type="text" name="mailpassword" value="#form.mailpassword#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td colspan="2">The following entries are specifically related to podcasting.</td>
		</tr>
		<tr>
			<td align="right">itunes Subtitle:</td>
			<td><input type="text" name="itunessubtitle" value="#form.itunessubtitle#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">itunes Summary:</td>
			<td><input type="text" name="itunessummary" value="#form.itunessummary#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">itunes Keywords:</td>
			<td><input type="text" name="ituneskeywords" value="#form.ituneskeywords#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">itunes Author:</td>
			<td><input type="text" name="itunesauthor" value="#form.itunesauthor#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">itunes Image:</td>
			<td><input type="text" name="itunesimage" value="#form.itunesimage#" class="txtField" maxlength="50"></td>
		</tr>
		<tr>
			<td align="right">itunes Explicit:</td>
			<td>
			<select name="itunesexplicit">
			<option value="yes" <cfif form.itunesexplicit>selected</cfif>>Yes</option>
			<option value="no" <cfif not form.itunesexplicit>selected</cfif>>No</option>
			</select>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" name="cancel" value="Cancel"> <input type="submit" name="save" value="Save"></td>
		</tr>
	</table>
	</form>
	</cfoutput>


</cfmodule>

<cfsetting enablecfoutputonly=false>