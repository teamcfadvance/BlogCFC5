<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\mailsubscribers.cfm
	Author       : Raymond Camden 
	Created      : 07/07/06
	Last Updated : 
	History      : 
--->



<cfset vSubscribers = application.blog.getSubscribers(true)>

<cfparam name="form.subject" default="">
<cfparam name="form.body" default="">

<cfif structKeyExists(form, "send")>

	<cfset errors = arrayNew(1)>
	
	<cfif not len(trim(form.subject))>
		<cfset arrayAppend(errors, "The subject cannot be blank.")>
	</cfif>
	<cfif not len(trim(form.body))>
		<cfset arrayAppend(errors, "The body cannot be blank.")>
	</cfif>

	<cfif not arrayLen(errors)>
	
		<cfloop query="vSubscribers">
		
			<!--- This should maybe be abstracted. It's copied from blog.cfc --->
			<cfsavecontent variable="link">
			<cfoutput>
<p>
You are receiving this email because you have subscribed to this blog.<br />
To unsubscribe, please go to this URL:
<a href="#application.rooturl#/unsubscribe.cfm?email=#email#&token=#token#">#application.rooturl#/unsubscribe.cfm?email=#email#&token=#token#</a>
</p>	
			</cfoutput>
			</cfsavecontent>
			
			<cfset body = form.body & "<br />" & link>
			
			<cfset application.utils.mail(
				to=email,
				from=application.blog.getProperty("owneremail"),
				subject=form.subject,
				type="html",
				body=body,
				mailserver=application.blog.getProperty("mailserver"),
				mailusername=application.blog.getProperty("mailusername"),
				mailpassword=application.blog.getProperty("mailpassword")
					)>
		
		</cfloop>
		
		<cfset success = true>
	</cfif>
	
</cfif>

<cfmodule template="../tags/adminlayout.cfm" title="Subscribers">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif vSubscribers.recordCount gt 1>
		#vSubscribers.recordcount# verified subscribers
		<cfelseif vSubscribers.recordCount is 1>
		1 subscriber
		<cfelse>
		0 subscribers
		</cfif>. The form below will let you email your subscribers. It will automatically
		add an unsubscribe link to the bottom of the email. HTML is allowed.
	</p>
	</cfoutput>
		
	<cfif vSubscribers.recordCount is 0>
	
		<cfoutput>
		<p>
		Since you do not have any verified subscribers, you will not be able to send a message.
		</p>
		</cfoutput>
		
	<cfelse>
	
		<cfif not structKeyExists(variables, "success")>
		
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
			<form action="mailsubscribers.cfm" method="post">
			<table>
				<tr>
					<td align="right">subject:</td>
					<td><input type="text" name="subject" value="#form.subject#" class="txtField" maxlength="255"></td>
				</tr>
				<tr valign="top">
					<td align="right">body:</td>
					<td><textarea name="body" class="txtArea">#form.body#</textarea></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><input type="submit" name="cancel" value="Cancel"> <input type="submit" name="send" value="Send"></td>
				</tr>
			</table>
			</form>
			</cfoutput>

		<cfelse>
		
			<cfoutput>
			<p>
			Your message has been sent.
			</p>
			</cfoutput>
			
		</cfif>
			
	</cfif>
		
</cfmodule>


<cfsetting enablecfoutputonly=false>