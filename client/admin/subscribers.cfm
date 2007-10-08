<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : C:\projects\blogcfc5\client\admin\subscribers.cfm
	Author       : Raymond Camden 
	Created      : 04/07/06
	Last Updated : 7/21/06
	History      : Show how many people are verified (rkc 7/7/06)
				 : Button to let you nuke all the unverified people at once. (rkc 7/21/06)
--->

<!--- handle deletes --->
<cfif structKeyExists(form, "mark")>
	<cfloop index="u" list="#form.mark#">
		<cfset application.blog.removeSubscriber(u)>
	</cfloop>
</cfif>

<!--- handle mass delete --->
<cfif structKeyExists(form, "nukeunverified")>
		<cfset application.blog.removeUnverifiedSubscribers()>
</cfif>

<cfif structKeyExists(url, "verify")>
	<cfset application.blog.confirmSubscription(email=url.verify)>
</cfif>

<cfset subscribers = application.blog.getSubscribers()>

<cfquery name="verifiedSubscriber" dbtype="query">
select	count(email) as total
from	subscribers
where	verified = 1
</cfquery>

<cfmodule template="../tags/adminlayout.cfm" title="Subscribers">

	<cfoutput>
	<p>
	Your blog currently has 
		<cfif subscribers.recordCount gt 1>
		#subscribers.recordcount# subscribers
		<cfelseif subscribers.recordCount is 1>
		1 subscriber
		<cfelse>
		0 subscribers
		</cfif>. There <cfif verifiedSubscriber.total is 1>is<cfelse>are</cfif> <cfif verifiedSubscriber.total neq "">#verifiedSubscriber.total#<cfelse>no</cfif> <b>verified</b> subscriber<cfif verifiedSubscriber.total is not 1>s</cfif>.
	</p>
	
	<p>
	You may use the button below to delete all non-verified subscribers. You should note that this will delete ALL of them, 
	even people who just subscribed a minute ago. This should be used rarely!
	</p>
	
	<form action="subscribers.cfm" method="post">
	<input type="submit" name="nukeunverified" value="Remove Unverified">
	</form>
	</cfoutput>
	
	<cfmodule template="../tags/datatable.cfm" data="#subscribers#" editlink="" label="Subscribers"
			  linkcol="" linkval="email" showAdd="false" defaultsort="email">
		<cfmodule template="../tags/datacol.cfm" colname="email" label="Email" />
		<cfmodule template="../tags/datacol.cfm" colname="verified" label="Verified" format="yesno"/>
		<cfmodule template="../tags/datacol.cfm" label="Verify" data="<a href=""subscribers.cfm?verify=$email$"">Verify</a>" sort="false"/>
		
	</cfmodule>
	
</cfmodule>


<cfsetting enablecfoutputonly=false>