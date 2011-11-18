<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : parseses.cfm
	Author       : Raymond Camden 
	Created      : June 23, 2005
	Last Updated : August 31, 2006
	History      : Reset for 5.0 (5/1/06)
				 : catch long cats (8/31/06)
	Purpose		 : Attempts to find SES info in URL and set URL vars
--->

<cfscript>
/**
 * Parses my SES format. Demands /YYYY/MMMM/TITLE or /YYYY/MMMM/DDDD/TITLE
 * One line from MikeD
 *
 * @author Raymond Camden (ray@camdenfamily.com)
 * @version 1, June 23, 2005
 */ 
function parseMySES() {
	//line below from Mike D.
	var urlVars=reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '');
	var r = structNew();
	var theLen = listLen(urlVars,"/");

	if(len(urlVars) is 0 or urlvars is "/" or len(urlVars) GT 4) return r;
	
	//handles categories
	if(theLen is 1) {
			urlVars = replace(urlVars, "/","");
			r.categoryName = urlVars;	
			return r;
	}
	
	//BEGIN BRAUNSTEIN MOD 2/5/2010
	//handles users (aka posters, authors)
	if(theLen is 2 and urlVars contains "postedby") {
			urlVars = replace(urlVars, "/postedby/","");
			r.postedby = urlVars;	
			return r;
	}
	//END BRAUNSTEIN MOD 2/5/2010

	r.year = listFirst(urlVars,"/");
	if(theLen gte 2) r.month = listGetAt(urlVars,2,"/");
	if(theLen gte 3) r.day = listGetAt(urlVars,3,"/");
	if(theLen gte 4) r.title = listLast(urlVars, "/");
	return r;
}
</cfscript>

<!--- Try to load my info from the URL ... --->
<cfset sesInfo = parseMySES()>

<!--- I don't have the right info, so we are outa here! --->
<cfif structIsEmpty(sesInfo)>
	<cfsetting enablecfoutputonly=false>
	<cfexit method="exitTag">
</cfif>

<cfset params = structNew()>

<!--- First see if we have a category --->
<cfif structKeyExists(sesInfo, "categoryName")>

	<cfif len(trim(sesInfo.categoryName)) and len(trim(sesInfo.categoryName)) lte 50>
		<!--- translate back --->
		<cfset categoryID = application.blog.getCategoryByAlias(sesInfo.categoryName)>
		<cfif len(categoryID)>
			<cfset url.mode = "cat">
			<cfset url.catid = categoryID>
		</cfif>
	</cfif>
	
<!--- BEGIN BRAUNSTEIN MOD 2/5/2010 --->
<!--- else if we have a blog poster/user/author --->
<cfelseif structKeyExists(sesInfo, "postedby")>

	<cfif len(trim(sesInfo.postedby)) and len(trim(sesInfo.postedby)) lte 50>
		<!--- translate back - get username based on name --->
		<cfset username = application.blog.getUserByName(sesInfo.postedby)>
		<cfif len(username)>
			<cfset url.mode = "postedby">
			<cfset url.postedby = username>
		</cfif>
	</cfif>

<!--- END BRAUNSTEIN MOD 2/5/2010 --->

<!--- By month --->
<cfelseif not structKeyExists(sesInfo, "title")>

	<cfset url.month = sesInfo.month>
	<cfset url.year = sesInfo.year>
	
	<cfif structKeyExists(sesInfo, "day")>
		<cfset url.day = sesInfo.day>
		<cfset url.mode = "day">
	<cfelse>
		<cfset url.mode = "month">
	</cfif>
	
<!--- This is a full entry --->
<cfelse>

	<!--- The blog checks, but lets be extra careful --->
	<cfif not isNumeric(sesInfo.year) or not isNumeric(sesInfo.month) or not (sesInfo.month gte 1 and sesInfo.month lte 12) or not len(trim(sesInfo.title))>
		<cfsetting enablecfoutputonly=false>
		<cfexit method="exitTag">
	</cfif>
	
	<cfset params.byMonth = sesInfo.month>
	<cfset params.byYear = sesInfo.year>
	<cfif structKeyExists(sesInfo,"day")>
		<cfset params.byDay = sesInfo.day>
	</cfif>
	
	<cfset params.byAlias = sesInfo.title>
	<cfset url.mode = "alias">
	<cfset url.alias = params.byAlias>

</cfif>

<!--- Copy to caller --->
<cfset caller.params = params>

<cfsetting enablecfoutputonly=false>
<cfexit method="exitTag">
