<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : /client/tags/adminlayout.cfm
	Author       : Raymond Camden 
	Created      : 04/06/06
	Last Updated : 4/13/07
	History      : link to stats (rkc 5/17/06)
				 : new links in left menu (rkc 7/7/06 and 7/13/06)
				 : Scott P suggested adding blogname (rkc 8/2/06)
				 : Re-organized the menu a bit (rkc 9/5/06)
				 : htmlEditFormat the blog title (rkc 10/12/06)
				 : comment mod link (tr 12/7/06)
				 : check filebrowse prop, settings prop (rkc 12/14/06)
				 : podmanager add by Scott P (rkc 4/13/07)
--->				 
 
<cfparam name="attributes.title" default="">

<!---- added JH DotComIt to allow for admin w/ multiple directory levels --->
<cfparam name="attributes.dirlevel" default="">

<cfif thisTag.executionMode is "start">

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="#application.rooturl#/includes/admin.css" media="screen" />
<script type="text/javascript" src="#application.rooturl#/includes/jquery.min.js"></script>
<script type="text/javascript" src="#application.rooturl#/includes/jquery.selectboxes.js"></script>
<script type="text/javascript" src="#application.rooturl#/includes/jquery.autogrow.js"></script>
<link type="text/css" href="#application.rooturl#/includes/jqueryui/css/custom-theme/jquery-ui-1.7.2.custom.css" rel="stylesheet" />

<style type="text/css" media="screen">
  @import "#application.rooturl#/includes/uni-form/css/uni-form.css";
</style>
<script type="text/javascript" src="#application.rooturl#/includes/uni-form/js/uni-form.jquery.js"></script>

<script type="text/javascript" src="#application.rooturl#/includes/jqueryui/jqueryui.js"></script>
<cfif NOT application.utils.isLoggedIn()>
  <style type="text/css">
    body{background:none;}
  </style>
</cfif>
<title>BlogCFC Administrator #htmlEditFormat(application.blog.getProperty("blogTitle"))#: #attributes.title#</title>
</head>

<body>

<!--- TODO: Switch to request scope --->
<cfif application.utils.isLoggedIn()>
<div id="menu">
<ul>
<li><a href="#attributes.dirlevel#index.cfm">Home</a></li>
<li><a href="#attributes.dirlevel#entry.cfm?id=0">Add Entry</a></li>
<li><a href="#attributes.dirlevel#entries.cfm">Entries</a></li>
<cfif application.blog.isBlogAuthorized('ManageCategories')>
<li><a href="#attributes.dirlevel#categories.cfm">Categories</a></li>
</cfif>
<li><a href="#attributes.dirlevel#comments.cfm">Comments</a></li>
<cfif application.commentmoderation>
<li><a href="#attributes.dirlevel#moderate.cfm">Moderate Comments (<cfoutput>#application.blog.getNumberUnmoderated()#</cfoutput>)</a></li>
</cfif>
<li><a href="#attributes.dirlevel#index.cfm?reinit=1">Refresh Blog Cache</a></li>
<cfif application.settings>
<li><a href="#attributes.dirlevel#settings.cfm">Settings</a></li>
</cfif>
<li><a href="#attributes.dirlevel#subscribers.cfm">Subscribers</a></li>
<li><a href="#attributes.dirlevel#mailsubscribers.cfm">Mail Subscribers</a></li>
<cfif application.blog.isBlogAuthorized('ManageUsers')>
<li><a href="#attributes.dirlevel#users.cfm">Users</a></li>
</cfif>
</ul>
<ul>
<cfif application.blog.isBlogAuthorized('PageAdmin')>
<li><a href="#attributes.dirlevel#pods.cfm">Pod Manager</a></li>
<cfif application.filebrowse>
<li><a href="#attributes.dirlevel#filemanager.cfm">File Manager</a></li>
</cfif>
<li><a href="#attributes.dirlevel#pages.cfm">Pages</a></li>
<li><a href="#attributes.dirlevel#slideshows.cfm">Slideshows</a></li>
<li><a href="#attributes.dirlevel#textblocks.cfm">Textblocks</a></li>
</ul>
</cfif>
<ul>
<!---<li><a href="../">Your Blog</a></li>--->
<li><a href="../" target="_new">Your Blog (New Window)</a></li>
</ul>
<ul>
<li><a href="#attributes.dirlevel#stats.cfm">Your Blog Stats</a></li>
<li><a href="#attributes.dirlevel#stats2.cfm">Your Blog Stats 2</a></li>
<li><a href="#attributes.dirlevel#statsbyyear.cfm">Your Blog Stats By Year</a></li>
<li><a href="#attributes.dirlevel#downloads.cfm">Download Reports</a></li>
</ul>
<ul style="border-bottom: none;">
<li><a href="#attributes.dirlevel#updatepassword.cfm">Update Password</a><li>
<li><a href="#attributes.dirlevel#index.cfm?logout=youbetterbelieveit">Logout</a></li>
</ul>
</div>
<div id="content">
<div id="blogTitle">#htmlEditFormat(application.blog.getProperty("blogTitle"))#</div>
<div id="header">#attributes.title#</div>
<cfelse>
<div id="content">
</cfif>


</cfoutput>

<cfelse>

<cfoutput>
</div>
</body>
</html>
</cfoutput>

</cfif>

<cfsetting enablecfoutputonly=false>