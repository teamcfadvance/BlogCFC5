

<cfif structKeyExists(url, "nomobile")>
	<cfset redirLink = application.rooturl>
	<cftry>
		<cfif structKeyExists(url, "postID")>
			<cfset redirLink = application.blog.makeLink(url.postID)>
			<cfset session.nomobile = true>
		</cfif>
		<cfcatch type="any"></cfcatch>
	</cftry>
	<cflocation url="#redirLink#" addtoken="true">
</cfif>


<cfset urlVars=reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '')>
<cfif listlen(urlVars, '/') GT 1>
	<!---attempt to load directly into a post--->
	<cfmodule template="../tags/getmode.cfm" r_params="chkparams"/>
	<cfset thePostID = application.blog.getEntries(chkparams)>
	
	<!---we got a query back.. SES url contained a post--->
	<cfif isQuery(thePostID.entries)> 
		<!---have to do this because mobile breaks on ses urls--->
		<cfset session.loadPost = thePostID.entries.id>
		<cflocation url="http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#" addToken="false">
	</cfif>
<cfelseif isDefined('session.loadPost')>
	<cfset loadpost = session.loadPost>
	<cfset void = structDelete(session, "loadpost")>
</cfif>


<cfset isGAEnabled = len(application.blogMobile.getProperty("gaAccount"))>


<!DOCTYPE html> 
<html> 
	<head> 
	<title><cfoutput>#application.blog.getProperty("blogTitle")#</cfoutput></title> 
	
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0a4/jquery.mobile-1.0a4.min.css" />
	<script src="http://code.jquery.com/jquery-1.5.2.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.0a4/jquery.mobile-1.0a4.min.js"></script>
	
	<script src="./js/jquery.cookie.js"></script>
	<script src="./js/jquery-textfill-0.1.js"></script>
    	<script>
		// Google Analytics tracker for this page view
		<cfif isGAEnabled>
		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', '<cfoutput>#application.blogMobile.getProperty("gaAccount")#</cfoutput>']);
		_gaq.push(['_trackPageview']);			
		</cfif>
			
        $(function(){
						
			// Google Analytics click trackers
			<cfif isGAEnabled>
			$('a[href]').click(function(){
				var linksto = this.href;
				var fullhref = $(this).attr('fullhref');
				if (linksto.match(/\.(cfm)/)) _gaq.push(['_trackPageview',fullhref]);
			});
			</cfif>
			
			// add shrink text to display so blog post title will fit into designated area
            $('div').live('pageshow', function(){				
                $('.jtextfill').textfill({ maxFontPixels: 24 });
            });
			
			// leave mobile version
			$("#exitFooterButton").live('click tap', function(e) {
				var postID = '';
				var theURL = '';
				var theUrlArray = '';
				
				// viewing a post... lets exit to it
				if ($.mobile.activePage.attr('data-url').indexOf("postDetail" != -1)){
					theURL = $.mobile.activePage.attr('data-url');
					theUrlArray = theURL.split('=');				
					postID = '&postID=' + theUrlArray[1] 					
				}
				document.location.href = './index.cfm?nomobile=1' + postID;
				e.preventDefault();
			});
			<cfif isDefined('loadPost')>
				$.mobile.changePage({<cfoutput>url: './postDetail.cfm', data: 'post=#loadpost#', type: 'get'</cfoutput>})
			</cfif>		
			
        });
    	</script>
		
		<!---custom css to handle footer icons--->
		<style type="text/css">			
			.nav-footer-custom-icons .ui-btn .ui-btn-inner { padding-top: 35px !important; }
			.nav-footer-custom-icons .ui-btn .ui-icon { width: 30px!important; height: 30px!important; margin-left: -15px !important; box-shadow: none!important; -moz-box-shadow: none!important; -webkit-box-shadow: none!important; -webkit-border-radius: none !important; border-radius: none !important; }
			#aboutFooterButton .ui-icon { background:  url(./assets/icons/84-lightbulb.png) 50% 50% no-repeat;  background-size: 14px 21px; }
			#categoryFooterButton .ui-icon { background:  url(./assets/icons/104-index-cards.png) 50% 50% no-repeat;  background-size: 26px 17px; }
			#exitFooterButton .ui-icon { background:  url(./assets/icons/113-navigation.png) 50% 50% no-repeat;  background-size: 23px 23px; }
			#searchFooterButton .ui-icon { background:  url(./assets/icons/06-magnify.png) 50% 50% no-repeat;  background-size: 24px 24px; }
			
		</style>
    </head>
</head> 
<body class="ui-body-b"> 

<cfparam name="url.page" default="1" >

<cfif url.page EQ 1>
	<!---this is here for initial load --->
	<cfset params.startrow = 1>
	<cfset params.maxEntries = application.mobilePageMax>
	<cfset articleData = application.blog.getEntries(params)>
	<cfset articles = articleData.entries>
	
	<!---determin max numer of pages--->
	<cfset pages = ceiling(articleData.totalEntries/params.maxEntries)>
</cfif>

<cfset curPage = url.page>




<div data-role="page" data-theme="<cfoutput>#application.primaryTheme#</cfoutput>">


	<cf_header title="#application.blog.getProperty("blogTitle")#" showHome="#curPage#" id="blogHeader">
	
	<div data-role="content" data-theme="a">		
		<ul data-role="listview">
			<cfinclude template="posts.cfm">
		</ul>			
	</div><!-- /content -->	
	<!---paging nav--->
	<fieldset class="ui-grid-a">
		<div class="ui-block-a"> 
			<cfif curPage NEQ 1>
				<a href="index.cfm?page=<cfoutput>#curPage-1#</cfoutput>" data-role="button"  data-direction="reverse" data-icon="arrow-l">Previous</a>	
			<cfelse>
				&nbsp;
			</cfif>		
		</div>
		<div class="ui-block-b">
			<cfif curPage NEQ pages>
				<a href="index.cfm?page=<cfoutput>#curPage+1#</cfoutput>" data-role="button" data-icon="arrow-r" data-iconpos="right">More</a></div>
			<cfelse>
				&nbsp;
			</cfif>	   
	</fieldset>
	
	<cf_footer />
	<!-- /footer --> 
	
	
</div><!-- /page -->


<!--- Standard Google Analytics include --->
<cfif isGAEnabled>
  <script type="text/javascript">  (function() {
    var ga = document.createElement('script');     ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:'   == document.location.protocol ? 'https://ssl'   : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
   </script>	
</cfif>
</body>
</html>


