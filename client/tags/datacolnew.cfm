<cfsetting enablecfoutputonly=true>
<!---
	Name         : datacol.cfm
	Author       : Raymond Camden 
	Created      : September 7, 2004
	Last Updated : September 7, 2004
	History      : 
	Purpose		 : Allows you to specify settings for datatable 
--->

<cfassociate baseTag="cf_datatablenew">

<cfparam name="attributes.colname" type="string" default="">
<cfparam name="attributes.name" type="string" default="#attributes.colname#">
<cfparam name="attributes.label" type="string" default="#attributes.name#">
<cfparam name="attributes.data" type="string" default="">
<cfparam name="attributes.sort" type="string" default="true">

<cfif attributes.name is "" and attributes.data is "">
	<cfthrow message="dataCol: Both name and data cannot be empty.">
</cfif>

<cfif len(attributes.data)>
	<cfset attributes.name = attributes.data>
</cfif>

<cfsetting enablecfoutputonly=false>

<cfexit method="EXITTAG">
