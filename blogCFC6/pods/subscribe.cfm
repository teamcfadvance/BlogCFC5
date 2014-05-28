<cfset rooturl = application.settings.rooturl>

<!---
Andy Jarret had suggested renaming the field to help stop spammers.
I'm making it dynamic in case folks to want to change it quickly on their own blogs.
--->
<cfset formField = "user_register">

<!--- confirmation vars --->
<cfparam name="variables.errorMessage" default="">
<cfparam name="variables.successMessage" default="">


<cfif structKeyExists(form, formField) and len(trim(form[formField]))>
	<cfif isValid("email", trim(form[formField]))>
		
		<cfset token = application.blog.addSubscriber(trim(form[formField]))>
		
		<cfif token is not "">
		
			<!--- Now send confirmation email to subscriber --->
			<cfsavecontent variable="body">
			<cfoutput>
Please confirm your subscription to the blog by clicking the link below.			

#rooturl#/confirmsubscription.cfm?t=#token#
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
		<cfset variables.successMessage = "We have received your request.  Please keep an eye on your email; we will send you a link to confirm your subscription.">
		</cfif>								
						
	<cfelse> <!--- bad email syntax --->
		<cfset variables.errorMessage = "Whoops! The email you entered is not valid syntax.">
	</cfif>
	
</cfif>

<cfset qs = reReplace(cgi.query_string, "<.*?>", "", "all")>
<cfset qs = reReplace(qs, "[\<\>]", "", "all")>
<cfset qs = reReplace(qs, "&", "&amp;", "all")>

<cfoutput>
Enter your email address to subscribe to this blog.
<form action="#rooturl#?#qs#" method="post" onsubmit="return(this.#formField#.value.length != 0)">
<p><input type="text" name="#formField#" size="15" /> <input type="submit" value="Subscribe" /></p>
</form>
<cfif len(variables.successMessage)>
	<span style="color:##00ee00">#variables.successMessage#</span>
<cfelseif len(variables.errorMessage)>
	<span style="color:##ee0000">#variables.errorMessage#</span>
</cfif>
</cfoutput>
			
	
