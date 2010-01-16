<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : layout.cfm
	Author       : Raymond Camden 
	Created      : July 4, 2003
	Last Updated : May 18, 2007
	History      : Reset history for version 4.0
				   Added trackback js code, switch to request.rooturl (rkc 9/22/05)
				   Switched to app.rooturl (rkc 10/3/05)
				   frame buster code, use tag cloud (rkc 8/22/06)
				   small white space change (rkc 9/5/06)
				   don't log when doing the getEntry (rkc 2/28/07)
				   use podmanager, by Scott P (rkc 4/13/07)
				   support category as list (rkc 5/18/07)
	Purpose		 : Layout
--->

<cfif thisTag.executionMode is "start">

<cfif isDefined("attributes.title")>
	<cfset additionalTitle = ": " & attributes.title>
<cfelse>	
	<cfset additionalTitle = "">
	<cfif isDefined("url.mode") and url.mode is "cat">
		<!--- can be a list --->
		<cfset additionalTitle = "">
		<cfloop index="cat" list="#url.catid#">
		<cftry>
			<cfset additionalTitle = additionalTitle & " : " & application.blog.getCategory(cat).categoryname>
			<cfcatch></cfcatch>
		</cftry>
		</cfloop>
	
	<cfelseif isDefined("url.mode") and url.mode is "entry">
		<cftry>
			<!---
			Should I add one to views? Only if the user hasn't seen it.
			--->
			<cfset dontLog = false>
			<cfif structKeyExists(session.viewedpages, url.entry)>
				<cfset dontLog = true>
			<cfelse>
				<cfset session.viewedpages[url.entry] = 1>
			</cfif>
			<cfset entry = application.blog.getEntry(url.entry,dontLog)>
			<cfset additionalTitle = ": #entry.title#">
			<cfcatch></cfcatch>
		</cftry>
	</cfif>
</cfif>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>#htmlEditFormat(application.blog.getProperty("blogTitle"))##additionalTitle#</title>
	<!--- RBB 6/23/05: Push crawlers to follow links, but only index content on individual entry pages --->
	<cfif isDefined("url.mode") and url.mode is "entry">
	<!--- index entry page --->
	<meta name="robots" content="index,follow" />
	<cfelse>
	<!--- don't index other pages --->
	<meta name="robots" content="noindex,follow" />	  
	</cfif>
	<meta name="title" content="#application.blog.getProperty("blogTitle")##additionalTitle#" />
	<meta content="text/html; charset=UTF-8" http-equiv="content-type" />
	<meta name="description" content="#application.blog.getProperty("blogDescription")##additionalTitle#" />
	<meta name="keywords" content="#application.blog.getProperty("blogKeywords")#" />
	<link rel="stylesheet" href="#application.rooturl#/includes/layout.css" type="text/css" />
	<link rel="stylesheet" href="#application.rooturl#/includes/style.css" type="text/css" />
	<!--[if IE]>
	<style type="text/css"> 
	.code{ 
		overflow:visible;
		overflow-x:auto;
		overflow-y:hidden;
		padding-bottom:15px;
	} 
	</style>
	<![endif]-->
	<!--- For Firefox --->
	<link rel="alternate" type="application/rss+xml" title="RSS" href="#application.rooturl#/rss.cfm?mode=full" />
	<script type="text/javascript" src="#application.rooturl#/includes/jquery.min.js"></script>
	<script type="text/javascript">
	function launchComment(id) {
		cWin = window.open("#application.rooturl#/addcomment.cfm?id="+id,"cWin","width=550,height=700,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}
	function launchCommentSub(id) {
		cWin = window.open("#application.rooturl#/addsub.cfm?id="+id,"cWin","width=550,height=350,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}
	function launchTrackback(id) {
		cWin = window.open("#application.rooturl#/trackbacks.cfm?id="+id,"cWin","width=550,height=500,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}
	<cfif isDefined("url.mode") and url.mode is "entry"	and application.usetweetbacks and structKeyExists(variables, "entry")>
	$(document).ready(function() {
		//set tweetbacks div to loading...
		$("##tbContent").html("<div class='tweetbackBody'><i>Loading Tweetbacks...</i></div>")
		$("##tbContent").load("#application.rooturl#/loadtweetbacks.cfm?id=#entry.id#")
	})
	</cfif>
	</script>
</head>

<body onload="if(top != self) top.location.replace(self.location.href);">

<div id="page">
  <div id="banner"><a href="#application.rootURL#">#htmlEditFormat(application.blog.getProperty("blogTitle"))#</a></div>
	<div id="content">
	
		<div id="blogText">
</cfoutput>		
<cfelse>
<cfoutput>
		</div>
	</div>
	<div id="menu">
		</cfoutput>
		
		<cfinclude template="getpods.cfm">
		
		<cfoutput>
		</div>		
<div class="footerHeader"> <a href="http://blogcfc.riaforge.org">BlogCFC</a> was created by <a href="http://www.coldfusionjedi.com">Raymond Camden</a>. This blog is running version #application.blog.getVersion()#. <a href="#application.rooturl#/contact.cfm">Contact Blog Owner</a></div>
	</div>
</body>
</html>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly=false>