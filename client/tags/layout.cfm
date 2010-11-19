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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
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
	<meta name="description" content="#application.blog.getProperty("blogDescription")##additionalTitle#" />
	<meta name="keywords" content="#application.blog.getProperty("blogKeywords")#" />
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
 	<link rel="alternate" type="application/rss+xml" title="RSS" href="#application.rooturl#/rss.cfm?mode=full" />
 
	<style type="text/css">
	@import "#application.rooturl#/includes/styles/style.css";
	@import "#application.rooturl#/includes/styles/header-default.css";
	@import "#application.rooturl#/includes/styles/content-default.css";
	@import "#application.rooturl#/includes/styles/side-default.css";
	</style>
	
	<!--[if lte IE 6]>
	<style type="text/css" media="all">@import "#application.rooturl#/includes/stylesie6.css";</style>
	<style type="text/css"> 
	.code{ 
		overflow:visible;
		overflow-x:auto;
		overflow-y:hidden;
		padding-bottom:15px;
	} 
	</style>
	<![endif]-->
	
	<script src="#application.rooturl#/includes/jquery.min.js" type="text/javascript"></script>
	<script src="#application.rooturl#/includes//jquery.arclite.js" type="text/javascript"></script>

	<script type="text/javascript" src="#application.rooturl#/includes/jquery.min.js"></script>
	<script type="text/javascript">
	function launchComment(id) {
		cWin = window.open("#application.rooturl#/addcomment.cfm?id="+id,"cWin","width=550,height=700,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}
	function launchCommentSub(id) {
		cWin = window.open("#application.rooturl#/addsub.cfm?id="+id,"cWin","width=550,height=350,menubar=yes,personalbar=no,dependent=true,directories=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
	}
	<cfif isDefined("url.mode") and url.mode is "entry"	and application.usetweetbacks and structKeyExists(attributes, "entrymode")>
	$(document).ready(function() {
		//set tweetbacks div to loading...
		$("##tbContent").html("<div class='tweetbackBody'><i>Loading Tweetbacks...</i></div>")
		$("##tbContent").load("#application.rooturl#/loadtweetbacks.cfm?id=#attributes.entryid#")
	})
	</cfif>
	</script>	
</head>

<body onload="if(top != self) top.location.replace(self.location.href);">

 <!-- page -->
 <div id="page" class="with-sidebar">
  <div id="header-wrap">
   <div id="header" class="block-content">
     <div id="pagetitle">
      <h1 class="logo"><a href="#application.rootURL#">#htmlEditFormat(application.blog.getProperty("blogTitle"))#</a></h1>
	  <!--- You can include more of a header here...
      <h4>Just another CSS theme :)</h4>
	  --->
      <div class="clear"></div>

      <!-- search form -->
      <div class="search-block">
        <div class="searchform-wrap">
          <form method="get" id="searchform" action="#application.rooturl#/search.cfm">
           <fieldset>
            <input type="text" name="s" id="searchbox" class="searchfield" value="Search" onfocus="if(this.value == 'Search') {this.value = '';}" onblur="if (this.value == '') {this.value = 'Search';}" />
            <input type="submit" value="Go" class="go" />
           </fieldset>
          </form>
        </div>
      </div>
      <!-- /search form -->

     </div>
     <!-- main navigation -->
     <div id="nav-wrap1">
      <div id="nav-wrap2">
        <ul id="nav">
         <li><a href="#application.rooturl#" class="fadeThis"><span>Home</span></a></li>
         <li><a href="#application.rooturl#/contact.cfm" class="fadeThis"><span>Contact</span></a>
         <li><a href="#application.rooturl#/search.cfm" class="fadeThis"><span>Search</span></a>
         <!---<li><a href="##" class="fadeThis"><span>Background variations</span></a>--->
         </li>
		<!---
		An example menu item with a fly out sub menu.
         <li><a href="##" class="fadeThis"><span>More color variations</span></a>
           <ul>
            <li><a href="index-var7.html" class="fadeThis"><span>Green</span></a></li>
            <li><a href="index-var6.html" class="fadeThis"><span>Red</span></a></li>
            <li><a href="index-var5.html" class="fadeThis"><span>Blue</span></a></li>
            <li><a href="index-default.html" class="fadeThis"><span>Brown (Default)</span></a>
              <ul>
               <li><a href="##" class="fadeThis"><span>Just testing subs</span></a></li>
               <li><a href="##" class="fadeThis"><span>Another sub-menu...</span></a></li>
              </ul>
            </li>
           </ul>
         </li>
		 --->
        </ul>
      </div>
     </div>
     <!-- /main navigation -->

   </div>



   <div id="main-wrap1">
    <div id="main-wrap2">
     <div id="main" class="block-content">
      <div class="mask-main rightdiv">
       <div class="mask-left">
        <div class="col1">
          <div id="main-content">
</cfoutput>
<cfelse>
<cfoutput>
			</div>
	        </div>
    	<div class="col2">

          <ul id="sidebar">

           <li class="block">

			<cfinclude template="getpods.cfm">
			
           </li>

          </ul>

        </div>
       </div>
      </div>
      <div class="clear-content"></div>
     </div>


    </div>
   </div>

  </div>

 <!-- footer -->
 <div id="footer">
  <div class="block-content">
     <div class="copyright">
       <a href="http://www.blogcfc.com">BlogCFC #application.blog.getVersion()#</a> by Raymond Camden | <a href="#application.rootURL#/rss.cfm?mode=full" rel="noindex,nofollow">RSS</a> | Arclite theme by <a href="http://digitalnature.ro/projects/arclite">digitalnature</a>
     </div>
  </div>
 </div>
 <!-- /footer -->

 </div>
 <!-- /page -->

 <script type="text/javascript">
  /* <![CDATA[ */
    var isIE6 = false; /* <- do not change! */
    var isIE = false;  /* <- do not change! */
    var lightbox = 1;  /* lightbox on/off ? */
  /* ]]> */
 </script>
 <!--[if lte IE 6]> <script type="text/javascript"> isIE6 = true; isIE = true; </script> <![endif]-->
 <!--[if gte IE 7]> <script type="text/javascript"> isIE = true; </script> <![endif]-->

</body>

</html>
</cfoutput>
</cfif>
<cfsetting enablecfoutputonly=false>