<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Send
	Author       : Raymond Camden 
	Created      : April 15, 2006
	Last Updated : February 28, 2007
	History      : Use mailserver/u/p in send (rkc 6/25/06)
				 : rb use, captcha (rkc 8/20/06)
				 : CSS mods by Scott Stroz (rkc 8/24/06)
				 : htmlEditFormat the title (rkc 10/12/06)
				 : Don't log the getEntry (rkc 2/28/07)
	Purpose		 : Sends a blog entry
--->

<cfif not isDefined("url.id")>
	<cflocation url="/" addToken="false">
<cfelse>
	<cftry>
		<cfset entry = application.blog.getEntry(url.id,true)>
		<cfcatch>
			<cflocation url="/" addToken="false">
		</cfcatch>
	</cftry>
</cfif>

<cfset showForm = true>
<cfparam name="form.email" default="">
<cfparam name="form.remail" default="">
<cfparam name="form.notes" default="">
<cfparam name="form.captchaText" default="">

<cfif structKeyExists(form, "send")>
	<cfset errorStr = "">
	<cfif not len(trim(form.email)) or not isEmail(form.email)>
		<cfset errorStr = errorStr & rb("mustincludeemail") & "<br />">
	</cfif>
	<cfif not len(trim(form.remail)) or not isEmail(form.remail)>
		<cfset errorStr = errorStr & rb("mustincludereceiveremail") & "<br />">
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
	
		<cfsavecontent variable="body">
			<cfoutput>
			<p>
			The following blog entry was sent to you from: <b>#form.email#</b><br />
			It came from the blog: <b>#htmlEditFormat(application.blog.getProperty("blogtitle"))#</b><br />
			The entry is titled: <b>#entry.title#</b><br />
			The entry can be found here: <b><a href="#application.blog.makeLink(entry.id)#">#application.blog.makeLink(entry.id)#</a></b>
			</p>
			
			<cfif len(form.notes)>
			<p>
			The following notes were included:<br />
			<b>#form.notes#</b>
			</p>
			<p>
			<hr />
			</p>
			</cfif>
			#application.blog.renderEntry(entry.body)#
			<cfif len(entry.morebody)>#application.blog.renderEntry(entry.morebody)#</cfif>
			</cfoutput>
		</cfsavecontent>
		
		<cfset application.utils.mail(
				to=form.remail,
				from=form.email,
				cc=application.blog.getProperty("owneremail"),
				subject="#rb("blogentryfrom")#: #application.blog.getProperty("blogtitle")#",
				type="html",
				body=body,
				mailserver=application.blog.getProperty("mailserver"),
				mailusername=application.blog.getProperty("mailusername"),
				mailpassword=application.blog.getProperty("mailpassword")
					)>
												
		<cfset showForm = false>

	</cfif>
	
</cfif>

<cfmodule template="tags/layout.cfm" title="#rb("send")#">
	
	
	<cfoutput>
	<div class="date"><b>#rb("sendentry")#: #entry.title#</b></div>
	
	<div class="body">
	
	<cfif showForm>

	<p>
	#rb("sendform")#
	</p>

	<cfif isDefined("errorStr") and len(errorStr)>
		<cfoutput><b>#rb("correctissues")#:</b><ul>#errorStr#</ul></cfoutput>
	</cfif>
	
		<form action="#cgi.script_name#?#cgi.query_string#" method="post">
    <fieldset id="sendForm">
	     <div>
	      <label for="email">#rb("youremailaddress")#:</label>
	      <input type="text" id="email" name="email" value="#form.email#" style="width:300px;" />
	    </div>
	     <div>
	      <label for="remail">#rb("receiveremailaddress")#:</label>
	      <input type="text" id="remail" name="remail" value="#form.remail#" style="width:300px;" />
	    </div>
	     <div>
	      <label for="remail">#rb("optionalnotes")#:</label>
	      <textarea name="notes" id="notes">#form.notes#</textarea>
	    </div>
		<cfif application.useCaptcha>
			<cfset variables.captcha = application.captcha.createHashReference() />
	    <div>
				<input type="hidden" name="captchaHash" value="#variables.captcha.hash#" />
				<label for="captchaText" class="longLabel">#rb("captchatext")#:</label>
				<input type="text" name="captchaText" size="6" /><br />
				<img src="#application.blog.getRootURL()#showCaptcha.cfm?hashReference=#variables.captcha.hash#" vspace="5" />
	    </div>
		</cfif>	
	    <div>
	      <input type="submit" id="submit" name="send" value="#rb("sendentry")#" />
	     </div>
    </fieldset>

		</form>

	<cfelse>
	
		<p>
		#rb("entrysent")#
		</p>
		
	</cfif>
	
	</div>
	</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>