<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : addsub.cfm
	Author       : Raymond Camden 
	Created      : July 1, 2008
	Last Updated : 
	History      : 
	Purpose		 : Allows you to subscribe to a comment
--->

<cfif not isDefined("form.addsub")>
	<cfif isDefined("cookie.blog_email")>
		<cfset form.email = cookie.blog_email>
		<cfset form.rememberMe = true>
	</cfif>	
</cfif>

<cfparam name="form.email" default="">
<cfparam name="form.rememberMe" default="false">
<cfparam name="form.captchaText" default="">

<cfset closeMe = false>
<cfif not isDefined("url.id")>
	<cfset closeMe = true>
<cfelse>
	<cftry>
		<cfset entry = application.blog.getEntry(url.id,true)>
		<cfcatch>
			<cfset closeMe = true>
		</cfcatch>
	</cftry>
</cfif>
<cfif closeMe>
	<cfoutput>
	<script>
	window.close();
	</script>
	</cfoutput>
	<cfabort>
</cfif>

<cfif isDefined("form.addsub") and entry.allowcomments>
	<cfset form.email = trim(form.email)>

	
	<cfset errorStr = "">

	<cfif not len(form.email) or not isEmail(form.email)>
		<cfset errorStr = errorStr & rb("mustincludeemail") & "<br />">
	</cfif>

	<!--- captcha validation --->
	<cfif application.useCaptcha>
		<cfif not len(form.captchaText)>
		   <cfset errorStr = errorStr & "Please enter the Captcha text.<br />">
		<cfelseif NOT application.captcha.validateCaptcha(form.captchaHash,form.captchaText)>
		   <cfset errorStr = errorStr & "The captcha text you have entered is incorrect.<br />">
		</cfif>
	</cfif>
		
	<cfif not len(errorStr)>
	
		<!--- Subs basically use the comment system with an empty comment and a commentonly flag. --->
		<cfset commentID = application.blog.addComment(url.id,'', left(form.email,50), '', '', true,true)>

		<!--- clear form data --->
		<cfif form.rememberMe>
			<cfcookie name="blog_email" value="#trim(htmlEditFormat(form.email))#" expires="never">
		<cfelse>
			<cfcookie name="blog_email" expires="now">
			<!--- RBB 11/02/2005: Added new website form var --->
			<cfset form.email = "">
		</cfif>
		
		<cfoutput>
		<script>
		window.close();
		</script>
		</cfoutput>
		<cfabort>
		
	</cfif>	
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<cfoutput><title>#application.blog.getProperty("blogTitle")# : #rb("addsub")#</title></cfoutput>
	<link rel="stylesheet" href="includes/style.css" type="text/css" />
	<meta content="text/html; charset=UTF-8" http-equiv="content-type" />
</head>

<body id="popUpFormBody">

<cfoutput>
<div class="date">#rb("comments")#: #entry.title#</div>
<div class="body">
</cfoutput>

<cfif entry.allowcomments>
	
	<cfif isDefined("errorStr") and len(errorStr)>
		<cfoutput><b>#rb("correctissues")#:</b><br/>#errorStr#</cfoutput>
	</cfif>
	<cfoutput>
	<form action="#application.rootURL#/addsub.cfm?#cgi.query_string#" method="post">

  <fieldset id="commentForm">
    	<legend>#rb("addsub")#</legend>
  <div>
		<label for="email">#rb("emailaddress")#:</label>
		<input type="text" id="email" name="email" value="#form.email#" />
  </div>
	<cfif application.useCaptcha>
    <div>
		<cfset variables.captcha = application.captcha.createHashReference() />
		<input type="hidden" name="captchaHash" value="#variables.captcha.hash#" />
		<label for="captchaText" class="longLabel">#rb("captchatext")#:</label>
		<input type="text" name="captchaText" id="captchaText" size="6" /><br />
		<img src="#application.blog.getRootURL()#showCaptcha.cfm?hashReference=#variables.captcha.hash#" align="right" alt="Captcha" vspace="5" />
  </div>
	</cfif>
  <div>
		<label for="rememberMe" class="longLabel">#rb("remembermyinfo")#:</label>
		<input type="checkbox" class="checkBox" id="rememberMe" name="rememberMe" value="1" <cfif isBoolean(form.rememberMe) and form.rememberMe>checked="checked"</cfif> />
  </div>
  <div style="text-align:center">
		<input type="reset" id="reset" value="#rb("cancel")#" onclick="if(confirm('#rb("cancelconfirm")#')) { window.close(); } else { return false; }" /> <input type="submit" id="submit" name="addsub" value="#rb("subscribe")#" />
    </div>
</fieldset>
	</form>
	</cfoutput>
	
<cfelse>

	<cfoutput>
	<p>#rb("subnotallowed")#</p>
	</cfoutput>
	
</cfif>
</div>

</body>
</html>