<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : c:\projects\blog\client\trackbacks.cfm
	Author       : Dave Lobb 
	Created      : 09/22/05
	Last Updated : 8/20/06
	History      : Ray modified it for 4.0
				   Use of rb (rkc 8/20/06)
--->

<cfparam name="form.blog_name" default="">
<cfparam name="form.title" default="">
<cfparam name="form.excerpt" default="">
<cfparam name="form.url" default="">

<cfif not isDefined("url.id") or not application.trackbacksAllowed>
	<cfabort>
</cfif>

<cfif isDefined("url.delete") and isUserInRole("admin")>
	<cfset application.blog.deleteTrackback(url.delete)>
</cfif>

<cfif isDefined("form.addtrackback")>
	<cfset errorStr = "">

	<cfif not len(trim(form.blog_name))>
		<cfset errorStr = errorStr & rb("mustincludeblogname") & "<br>">
	</cfif>

	<cfif not len(trim(form.title))>
		<cfset errorStr = errorStr & rb("mustincludeblogtitle") & "<br>">
	</cfif>

	<cfif not len(trim(form.excerpt))>
		<cfset errorStr = errorStr & rb("mustincludeblogexcerpt") & "<br>">
	</cfif>

	<cfif not len(trim(form.url)) or not isURL(form.url)>
		<cfset errorStr = errorStr & rb("mustincludeblogentryurl") & "<br>">
	</cfif>

	<cfif not len(errorStr)>
		<cfset id = application.blog.addTrackBack(form.title, form.url, form.blog_name, form.excerpt, url.id)>
		<!--- Form a message about the TB --->
		<cfif id is not "">
			<cfmodule template="tags/trackbackemail.cfm" trackback="#id#" />
			<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
		</cfif>
		<cfset form.blog_name = "">
		<cfset form.title = "">
		<cfset form.excerpt = "">
		<cfset form.url = "">

		<!--- reload page and close this up --->
		<cfoutput>
		<script>
		window.opener.location.reload();
		window.close();
		</script>
		</cfoutput>
		<cfabort>

	</cfif>

</cfif>

<cfset params.byEntry = url.id>
<cfset article = application.blog.getEntries(params)>

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" />

<html>
<head>
	<title>#application.blog.getProperty("blogTitle")# : Trackbacks for #article.title#</title>
	<link rel="stylesheet" href="#application.rootURL#/includes/style.css" type="text/css"/>
</head>

<body style="background:##ffffff;">
</cfoutput>


<cfoutput>
<div class="date">Add TrackBack</div>
<div class="body">
<cfif isDefined("errorStr") and len(errorStr)>
	<cfoutput><b>#rb("correctissues")#:</b><ul>#errorStr#</ul></cfoutput>
</cfif>
<form action="#cgi.script_name#?id=#url.id#" method="post" enctype="application/x-www-form-urlencoded" id="tbForm">

<fieldset class="sideBySide">
<label for="blogName">Your Blog Name:</label>
<input type="text" id="blogName" name="blog_name" value="#form.blog_name#" maxlength="255" />
</fieldset>
<fieldset class="sideBySide">
<label for="title">Your Blog Entry Title:</label>
<input type="text" id="title" name="title" value="#form.title#" maxlength="255" />
</fieldset>
<fieldset>
<label for="excerpt">Excerpt from your Blog:</label><br/>
<textarea id="excerpt" name="excerpt" cols=50 rows=10>#form.excerpt#</textarea>
</fieldset>
<fieldset class="sideBySide">
<label for="url">Your Blog Entry URL:</label>
<input type="text" id="url" name="url" value="#form.url#" maxlength="255" />
</fieldset>
<fieldset style="text-align:center">
<input id="submit" type="submit" name="addtrackback" value="#rb("post")#" />
</fieldset>
</form> 
</div>

<cfif isUserInRole("admin")>
<div class="date">Send TrackBack</div>
<div class="body">
<script language="javascript">
	function setAction() {
		if (document.sendtb.trackbackURL.value == "") {
			alert('Please provide the trackback url');
			return false;
		}
		else {
			document.sendtb.action = document.sendtb.trackbackURL.value;
			document.sendtb.submit();
			return true;
		}
		
	}
</script>
<form action="" name="sendtb" method="post" enctype="application/x-www-form-urlencoded" onSubmit="return setAction();">
<fieldset class="sideBySide">
<label for="blogName">Your Blog Name:</label>
<input type="text" id="blogName" name="blog_name" value="#form.blog_name#" maxlength="255" />
</fieldset>
<fieldset class="sideBySide">
<label for="title">Your Blog Entry Title:</label>
<input type="text" id="title" name="title" value="#form.title#" maxlength="255" />
</fieldset>
<fieldset>
<label for="excerpt">Excerpt from your Blog:</label><br/>
<textarea id="excerpt" name="excerpt" cols=50 rows=10>#form.excerpt#</textarea>
</fieldset>
<fieldset class="sideBySide">
<label for="url">Your Blog Entry URL:</label>
<input type="text" id="url" name="url" value="#form.url#" maxlength="255" />
</fieldset>
<fieldset style="text-align:center">
<input id="submit" type="submit" name="addtrackback" value="#rb("post")#" />
</fieldset>

</form> 

</div>
</cfif>
</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly=false>