<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : addcomment.cfm
	Author       : Raymond Camden 
	Created      : February 11, 2003
	Last Updated : October 8, 2007
	History      : Reset history for version 5.0
				 : Lengths allowed for name/email were 100, needed to be 50
				 : Cancel confirmation (rkc 8/1/06)
				 : rb use (rkc 8/20/06)
				 : Scott updates the design a bit (ss 8/24/06)
				 : Default form.captchaText (rkc 10/21/06)
				 : Don't log the getentry (rkc 2/28/07)
				 : Don't mail if moderating (rkc 4/13/07)
	Purpose		 : Adds comments
--->

<cfif not isDefined("form.addcomment")>
	<cfif isDefined("cookie.blog_name")>
		<cfset form.name = cookie.blog_name>
		<cfset form.rememberMe = true>
	</cfif>
	<cfif isDefined("cookie.blog_email")>
		<cfset form.email = cookie.blog_email>
		<cfset form.rememberMe = true>
	</cfif>
	<!--- RBB 11/02/2005: Added new website check --->
	<cfif isDefined("cookie.blog_website")>
		<cfset form.website = cookie.blog_website>
		<cfset form.rememberMe = true>
	</cfif>	
</cfif>

<cfparam name="form.name" default="">
<cfparam name="form.email" default="">
<!--- RBB 11/02/2005: Added new website parameter --->
<cfparam name="form.website" default="http://">
<cfparam name="form.comments" default="">
<cfparam name="form.rememberMe" default="false">
<cfparam name="form.subscribe" default="false">
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

<cfif isDefined("form.addcomment") and entry.allowcomments>
	<cfset form.name = trim(form.name)>
	<cfset form.email = trim(form.email)>
	<!--- RBB 11/02/2005: Added new website option --->
	<cfset form.website = trim(form.website)>
	<cfset form.comments = trim(form.comments)>

	<!-- if website is just http://, remove it --->
	<cfif form.website is "http://">
		<cfset form.website = "">
	</cfif>
	
	<cfset errorStr = "">

	<cfif not len(form.name)>
		<cfset errorStr = errorStr & rb("mustincludename") & "<br>">
	</cfif>
	<cfif not len(form.email) or not isEmail(form.email)>
		<cfset errorStr = errorStr & rb("mustincludeemail") & "<br>">
	</cfif>
	<cfif len(form.website) and not isURL(form.website)>
		<cfset errorStr = errorStr & rb("invalidurl") & "<br>">
	</cfif>
	
	<cfif not len(form.comments)>
		<cfset errorStr = errorStr & rb("mustincludecomments") & "<br>">
	</cfif>
	
	<!--- captcha validation --->
	<cfif application.useCaptcha>
		<cfif not len(form.captchaText)>
		   <cfset errorStr = errorStr & "Please enter the Captcha text.<br>">
		<cfelseif NOT application.captcha.validateCaptcha(form.captchaHash,form.captchaText)>
		   <cfset errorStr = errorStr & "The captcha text you have entered is incorrect.<br>">
		</cfif>
	</cfif>
	<!--- cfformprotect --->
	<cfif application.usecfp>
		<cfset cffp = createObject("component","cfformprotect.cffpVerify").init() />
		<!--- now we can test the form submission --->
		<cfif not cffp.testSubmission(form)>
			<cfset errorStr = errorStr & "Your comment has been flagged as spam.<br>">
		</cfif> 
	</cfif>
		
	<cfif not len(errorStr)>
	  <!--- RBB 11/02/2005: added website to commentID --->
	  	<cftry>
			<cfset commentID = application.blog.addComment(url.id,left(form.name,50), left(form.email,50), left(form.website,255), form.comments, form.subscribe)>
			<!--- Form a message about the comment --->
			<cfset subject = rb("commentaddedtoblog") & ": " & application.blog.getProperty("blogTitle") & " / " & rb("entry") & ": " & entry.title>
			<cfset commentTime = dateAdd("h", application.blog.getProperty("offset"), now())>
			<cfsavecontent variable="email">
			<cfoutput>
#rb("commentaddedtoblogentry")#:	#entry.title#
#rb("commentadded")#: 		#application.localeUtils.dateLocaleFormat(commentTime)# / #application.localeUtils.timeLocaleFormat(commentTime)#
#rb("commentmadeby")#:	 	#form.name# <cfif len(form.website)>(#form.website#)</cfif>
#rb("ipofposter")#:			#cgi.REMOTE_ADDR#
URL: #application.blog.makeLink(url.id)###c#commentID#

	
#form.comments#
	
------------------------------------------------------------
#rb("unsubscribe")#: %unsubscribe%
This blog powered by BlogCFC #application.blog.getVersion()#
Created by Raymond Camden (http://www.coldfusionjedi.com)
			</cfoutput>
			</cfsavecontent>
	
			<cfinvoke component="#application.blog#" method="notifyEntry">
				<cfinvokeargument name="entryid" value="#entry.id#">
				<cfinvokeargument name="message" value="#trim(email)#">
				<cfinvokeargument name="subject" value="#subject#">
				<cfinvokeargument name="from" value="#form.email#">
				<cfif application.commentmoderation>
					<cfinvokeargument name="adminonly" value="true">
				</cfif>										
				<cfinvokeargument name="commentid" value="#commentid#">
			</cfinvoke>
								
			<cfcatch>
				<cfif cfcatch.message is not "Comment blocked for spam.">
					<cfrethrow>
				<cfelse>
					<cfset errorStr = errorStr & "Your comment has been flagged as spam.<br>">		
				</cfif>
			</cfcatch>
			
		</cftry>
		
		<cfif not len(errorStr)>		
			<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
			<cfset comments = application.blog.getComments(url.id)>
			<!--- clear form data --->
			<cfif form.rememberMe>
				<cfcookie name="blog_name" value="#trim(htmlEditFormat(form.name))#" expires="never">
				<cfcookie name="blog_email" value="#trim(htmlEditFormat(form.email))#" expires="never">
	      		<!--- RBB 11/02/2005: Added new website cookie --->
				<cfcookie name="blog_website" value="#trim(htmlEditFormat(form.website))#" expires="never">
			<cfelse>
				<cfcookie name="blog_name" expires="now">
				<cfcookie name="blog_email" expires="now">
				<!--- RBB 11/02/2005: Added new website form var --->
				<cfset form.name = "">
				<cfset form.email = "">
				<cfset form.website = "">
			</cfif>
			<cfset form.comments = "">
			
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
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" />

<html>
<head>
	<cfoutput><title>#application.blog.getProperty("blogTitle")# : #rb("addcomments")#</title></cfoutput>
	<link rel="stylesheet" href="includes/style.css" type="text/css"/>
	<meta content="text/html; charset=UTF-8" http-equiv="content-type">
</head>

<body id="popUpFormBody">

<cfoutput>
<div class="date">#rb("comments")#: #entry.title#</div>
<div class="body">
</cfoutput>

<cfif entry.allowcomments>
	
	
	<cfif isDefined("errorStr") and len(errorStr)>
		<cfoutput><b>#rb("correctissues")#:</b><ul>#errorStr#</ul></cfoutput>
	</cfif>
	<cfoutput>
	<form action="#application.rootURL#/addcomment.cfm?#cgi.query_string#" method="post">
	<cfif application.usecfp>
		<cfinclude template="cfformprotect/cffp.cfm">
	</cfif>
  <fieldset id="commentForm">
    	<legend>#rb("postyourcomments")#</legend>
  <div>
		<label for="name">#rb("name")#:</label>
		<input type="text" id="name" name="name" value="#form.name#">
  </div>
  <div>
		<label for="email">#rb("emailaddress")#:</label>
		<input type="text" id="email" name="email" value="#form.email#">
  </div>
  <div>
		<label for="website">#rb("website")#:</label>
		<input type="text" id="website" name="website" value="#form.website#">
  </div>
  <div>
		<label for="comments">#rb("comments")#:</label>
		<textarea name="comments" id="comments">#form.comments#</textarea>
  </div>
	<cfif application.useCaptcha>
    <div>
		<cfset variables.captcha = application.captcha.createHashReference() />
		<input type="hidden" name="captchaHash" value="#variables.captcha.hash#" />
		<label for="captchaText" class="longLabel">#rb("captchatext")#:</label>
		<input type="text" name="captchaText" size="6" /><br>
		<img src="#application.blog.getRootURL()#showCaptcha.cfm?hashReference=#variables.captcha.hash#" align="right" vspace="5"/>
  </div>
	</cfif>
  <div>
		<label for="rememberMe" class="longLabel">#rb("remembermyinfo")#:</label>
		<input type="checkbox" class="checkBox" id="rememberMe" name="rememberMe" value="1" <cfif isBoolean(form.rememberMe) and form.rememberMe>checked</cfif>>
  </div>
  <div>
		<label for="subscribe" class="longLabel">#rb("subscribe")#:</label>
		<input type="checkbox" class="checkBox" id="subscribe" name="subscribe" value="1" <cfif isBoolean(form.subscribe) and form.subscribe>checked</cfif>>
  </div>
	<p style="clear:both">#rb("subscribetext")#</p>
  <div style="text-align:center">
		<input type="reset" id="reset" value="#rb("cancel")#" onClick="if(confirm('#rb("cancelconfirm")#')) { window.close(); } else { return false; }"> <input type="submit" id="submit" name="addcomment" value="#rb("post")#">
    </div>
</fieldset>
	</form>
	</cfoutput>
	
<cfelse>

	<cfoutput>
	<p>#rb("commentsnotallowed")#</p>
	</cfoutput>
	
</cfif>
</div>

</body>
</html>