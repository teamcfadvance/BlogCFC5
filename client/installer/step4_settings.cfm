
<cfif structKeyExists(form, "submit")>

	<cfloop item="field" collection="#form#">
		<cfif field neq "fieldnames" and field neq "submit">
			<cfset setProfileString(application.iniFile, session.blogname, field, form[field])>
			<cfif field is "blogurl">
				<cfset session.blogurl = form.blogurl>
			</cfif>
		</cfif>
	</cfloop>

	<cflocation url="step5_done.cfm" addToken="false">

</cfif>

<cf_layout title="Step 4: Basic Settings">

<script>
$(document).ready(function(){
	$("#settingForm").validate()
})
</script>
<p>
In this step we are going to fill in some basic settings. Some of these are optional and any setting can be changed later. For a full list of settings, log on
to your BlogCFC Administrator and use the Settings link.
</p>

<form method="post" id="settingForm">
<b>Your email address:</b> <input type="text" name="owneremail" class="required"><br/>
<b>Your blog URL (should end in index.cfm, ie: http://www.foo.com/index.cfm) :</b> <input type="text" name="blogurl" class="required url"><br/>
<b>Your blog's title:</b> <input type="text" name="blogtitle" class="required"><br/>
<b>A short description for your blog:</b> <input type="text" name="blogdescription"><br/>
<b>A set of keywords that describe your blog:</b> <input type="text" name="blogkeywords"><br/>
<b>If you need to specify a mail server, you can set it here:</b> <input type="text" name="mailserver"><br/>
<b>If that mail server requires a username, specify it here:</b> <input type="text" name="mailusername"><br/>
<b>If that mail server requires a password, specify it here:</b> <input type="text" name="mailpassword"><br/>
<b>Use CAPTCHA to protect from Spam?</b> <select name="usecaptcha"><option value="yes">Yes</option><option value="no">No</option></select><br/>
<b>Enable cfFormProtect for more spam protection?</b> <select name="usecfp"><option value="yes">Yes</option><option value="no">No</option></select><br/>
<b>Enable commenht moderation for ultimate spam protection?</b> <select name="moderate"><option value="yes">Yes</option><option value="no">No</option></select><br/>
<b>Use Gravatars in comments??</b> <select name="allowgravatars"><option value="yes">Yes</option><option value="no">No</option></select><br/>
<input type="submit" name="submit" value="Save Settings">
</form>

</cf_layout>
