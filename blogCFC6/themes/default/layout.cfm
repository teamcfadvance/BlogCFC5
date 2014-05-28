<!---
Docs: This file has access to:

themeurl - rooturl to theme
settings - struct of all blog settings
rssurl - to be done
mode - to be done, tells us if we are entries, entry, search, page, etc
--->

<!---
<div id="container">
<cfoutput>#content#</cfoutput>
</div>
--->

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>#arguments.title#</title>
	<meta name="title" content="#arguments.title#" />
	<meta content="text/html; charset=UTF-8" http-equiv="content-type" />
	<meta name="description" content="#settings.blogDescription# #title#" />
	<meta name="keywords" content="#settings.blogKeywords#" />
	<link rel="stylesheet" href="#themeurl#/css/layout.css" type="text/css" />
	<link rel="stylesheet" href="#themeurl#/css/style.css" type="text/css" />
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
	<link rel="alternate" type="application/rss+xml" title="RSS" href="#rssurl#" />
	</script>
</head>

<body onload="if(top != self) top.location.replace(self.location.href);">

<div id="page">
  <div id="banner"><a href="#settings.rootURL#">#settings.blogTitle#</a></div>
	<div id="content">
	
		<div id="blogText">
#content#
		</div>
	</div>
	<div id="menu">
		#renderPod("archives","Archives by Subject",true,30)#
		#renderPod("calendar","Calendar")#
		#renderPod("subscribe","Subscribe")#
	</div>		

<div class="footerHeader"> <a href="http://blogcfc.riaforge.org">BlogCFC</a> was created by <a href="http://www.coldfusionjedi.com">Raymond Camden</a>. This blog is running version #settings.version#. <a href="#settings.rooturl#/page.cfm/contact">Contact Blog Owner</a></div>
	</div>
</body>
</html>
</cfoutput>
