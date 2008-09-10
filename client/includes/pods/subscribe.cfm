<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : subscribe.cfm
	Author       : Raymond Camden 
	Created      : May 12, 2005
	Last Updated : February 28, 2007
	History      : Send email for verification (rkc 7/7/06)
				 : JavaScript fix, thanks to Charlie (rkc 7/10/06)
				 : Make formfield dynamic, thanks Andy Jarret (rkc 8/20/06)
				 : Forgot to make JS dynamic, thanks Tom C (rkc 10/29/06)
				 : Add a return msg on subscribing. Someone else did this - I forget who.
	Purpose		 : Allow folks to subscribe.
--->

<!---
Andy Jarret had suggested renaming the field to help stop spammers.
I'm making it dynamic in case folks to want to change it quickly on their own blogs.
--->
<cfset formField = "user_register">

<!--- confirmation vars --->
<cfparam name="errorMessage" default="">
<cfparam name="successMessage" default="">

<!--- 
	  I know. The caller. syntax is icky. This should be safe since all pods work in the same context. 
	  I may move the UDFs to the request scope so it's less icky. At the same time, it's not the big huge of
	  a deal. In fact, I bet no one is even going to read this. If you do, hi, how are you. Send me an email
	  and we can talk about how sometimes it is necessary to break the rules a bit. Then maybe we can have a
	  beer and talk about good sci-fi movies.
--->
<cfif structKeyExists(form, formField) and len(trim(form[formField]))>
	<cfif caller.isEmail(trim(form[formField]))>
		
		<cfset token = application.blog.addSubscriber(trim(form[formField]))>
		
		<cfif token is not "">
		
			<!--- Now send confirmation email to subscriber --->
			<cfsavecontent variable="body">
			<cfoutput>
	#application.resourceBundle.getResource("subscribeconfirmation")#
			
	#application.rooturl#/confirmsubscription.cfm?t=#token#
			</cfoutput>
			</cfsavecontent>
	
			<cfset application.utils.mail(
					to=form[formField],
					from=application.blog.getProperty("owneremail"),
					subject="#application.blog.getProperty("blogtitle")# #application.resourceBundle.getResource("subscribeconfirm")#",
					type="text",
					body=body,
					mailserver=application.blog.getProperty("mailserver"),
					mailusername=application.blog.getProperty("mailusername"),
					mailpassword=application.blog.getProperty("mailpassword")
					)>
		<cfset successMessage = "We have received your request.  Please keep an eye on your email; we will send you a link to confirm your subscription.">
		</cfif>								
						
	<cfelse> <!--- bad email syntax --->
		<cfset errorMessage = "Whoops! The email you entered is not valid syntax.">
	</cfif>
	
</cfif>

<cfmodule template="../../tags/podlayout.cfm" title="#application.resourceBundle.getResource("subscribe")#">

	<!--- handle: http://www.coldfusionjedi.com/forums/messages.cfm?threadid=4DF1ED1F-19B9-E658-9D12DBFBCA680CC6 --->
	<cfset qs = reReplace(cgi.query_string, "<.*?>", "", "all")>
	<cfset qs = reReplace(qs, "[\<\>]", "", "all")>

	<cfoutput>
	<div class="center">
	#application.resourceBundle.getResource("subscribeblog")#
	<form action="#application.blog.getProperty("blogurl")#?#qs#" method="post" onsubmit="return(this.#formField#.value.length != 0)">
	<p><input type="text" name="#formField#" size="15"> <input type="submit" value="#application.resourceBundle.getResource("subscribe")#"></p>
	</form>
	<cfif len(successMessage)>
		<span style="color:##00ee00">#successMessage#</span>
	<cfelseif len(errorMessage)>
		<span style="color:##ee0000">#errorMessage#</span>
	</cfif>
	</div>
	</cfoutput>
			
</cfmodule>
	
<cfsetting enablecfoutputonly=false>