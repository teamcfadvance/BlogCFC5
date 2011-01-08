<cfset urlVars=reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '')>
<cfif listlen(urlVars, '/') GT 1>
	<!---attempt to load directly into a post--->
	<cfmodule template="../tags/getmode.cfm" r_params="chkparams"/>
	<cfset thePostID = application.blog.getEntries(chkparams)>
	
	<!---we got a query back.. SES url contained a post--->
	<cfif isQuery(thePostID.entries)> 
		<!---have to do this because jqtouch breaks on ses urls--->
		<cfset session.loadPost = thePostID.entries.id>
		<cflocation url="http://#cgi.SERVER_NAME##cgi.SCRIPT_NAME#" addToken="false">
	</cfif>
<cfelseif isDefined('session.loadPost')>
	<cfset loadpost = session.loadPost>
	<cfset session.hideContainer = true>
	<cfset void = structDelete(session, "loadpost")>
</cfif>


<!---this is here for initial load --->
<cfset params.startrow = 1>
<cfset params.maxEntries = application.mobilePageMax>
<cfset articleData = application.blog.getEntries(params)>
<cfset articles = articleData.entries>

<!---determin max numer of pages--->
<cfset pages = ceiling(articleData.totalEntries/params.maxEntries)>


<cfset isGAEnabled = len(application.blogMobile.getProperty("gaAccount"))>



<html>
    <head>
        <meta charset="UTF-8" />
		
        <title><cfoutput>#application.blogMobile.getProperty("iconLabel")#</cfoutput></title>
        
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js" type="text/javascript" ></script>
		<script src="./jqtouch/jqtouch.min.js" type="application/x-javascript" charset="utf-8"></script>
		
		<style type="text/css" media="screen">@import "./jqtouch/jqtouch.min.css";</style>
        <style type="text/css" media="screen">@import "./themes/<cfoutput>#application.blogMobile.getProperty("theme")#</cfoutput>/theme.min.css";</style>
		<style type="text/css" media="screen">@import "./themes/main.css";</style>
		
		<script type="text/javascript" charset="utf-8">
		
			// Google Analytics tracker for this page view
			<cfif isGAEnabled>
			var _gaq = _gaq || [];
			_gaq.push(['_setAccount', '<cfoutput>#application.blogMobile.getProperty("gaAccount")#</cfoutput>']);
			_gaq.push(['_trackPageview']);			
			</cfif>
			
            var jQT = new $.jQTouch({
                icon: './assets/icon.png',
                addGlossToIcon: false,
                startupScreen: './assets/startup.png',
                statusBar: 'black',
                preloadImages: [
                    './themes/<cfoutput>#application.blogMobile.getProperty("theme")#</cfoutput>/img/back_button.png',
                    './themes/<cfoutput>#application.blogMobile.getProperty("theme")#</cfoutput>/img/back_button_clicked.png',
                    './themes/<cfoutput>#application.blogMobile.getProperty("theme")#</cfoutput>/img/button_clicked.png',
                    './themes/<cfoutput>#application.blogMobile.getProperty("theme")#</cfoutput>/img/grayButton.png',
                    './themes/<cfoutput>#application.blogMobile.getProperty("theme")#</cfoutput>/img/whiteButton.png',
                    './themes/<cfoutput>#application.blogMobile.getProperty("theme")#</cfoutput>/img/loading.gif'
                    ]
            });
          	var curPage = 1;
	        var maxPage = <cfoutput>#pages#</cfoutput>;		
			  $(function(){
	          
			  	          
				// warn on links that will take user to new window.
				$('a[target="_blank"]').click(function() {
	                if (confirm('This link opens in a new window.')) {
	                    return true;
	                } else {
	                    $(this).removeClass('active');
	                    return false;
	                }
	            });
				
				
				$('#homeBtn').click(function(){
					curPage = 1;
					$('#blogList').load('./posts.cfm?page=1', function(){										
						btnShow(1);
					});
					return false;	
				});				 
				             
			   	$('#moreBtn').click(function(){
					curPage = curPage+1;
					
					
					$('#blogList').load('./posts.cfm?page=' + curPage, function(){						
						if (curPage == maxPage){											
							btnShow(3);
						} else {																
							btnShow(2);						
						}
					});
					return false;		
				});
				
			   	$('#prevBtn').click(function(){
					curPage = curPage-1;					
					$('#blogList').load('./posts.cfm?page=' + curPage, function(){						
						if (curPage == 1){						
							btnShow(1);						
						} else if (curPage != maxPage){										
							btnShow(2);
						}						
					});
					return false;		
				});
				
				// Google Analytics click trackers
				<cfif isGAEnabled>
				$('a[href]').click(function(){
					var linksto = this.href;
					var fullhref = $(this).attr('fullhref');
					if (linksto.match(/\.(cfm)/)) _gaq.push(['_trackPageview',fullhref]);
				});
				</cfif>
				
				// hide prev on load					
				btnShow(1);		
				
			
            });
			
			btnShow = function(view){				
				if (view == 1) { // more only
					$('#moreBtn').show();
					$('#prevBtn').hide();
				} else if (view == 2){ // more & prev
					$('#moreBtn').show();
					$('#prevBtn').show();
				} else if (view == 3){ // prev only
					$('#moreBtn').hide();
					$('#prevBtn').show();					
				} else { // unknown.. hide all
					$('#moreBtn').hide();
					$('#prevBtn').hide();
				}
				
			}
			
			$(document).ready(function() {
				
				
				// load directly into post.
				// done this way to overcome navigational bugs in jQTouch
				<cfif isDefined('loadPost')>
								
					$("#<cfoutput>#hash(loadPost)#</cfoutput>").load('./postDetail.cfm/<cfoutput>#loadpost#</cfoutput>');   
					jQT.goTo('#<cfoutput>#hash(loadpost)#</cfoutput>');
				
				</cfif>
				
				$("#leaveMobileLink").click(function(e) {
					<cfoutput>
					document.location.href = '#application.rooturl#?nomobile=1';
					</cfoutput>
					e.preventDefault();
				});
			});
        </script>
		<!---
		This section is here to layout screen correctly. 
		If this was in css file the interface could load wrong due to css load delay
		--->
        <style type="text/css" media="screen">
	       	.body {
				-webkit-border-radius: 8px;
				-webkit-box-shadow: rgba(0,0,0,.3) 1px 1px 3px;
				padding: 10px 10px 10px 10px;
				margin:10px;
			    background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#4c4d4e), to(#404142));
				word-wrap:break-word;
			}
            body.fullscreen #home .info {
                display: none;
            }
            #about {
                padding: 25px 10px 40px;
                text-shadow: rgba(255, 255, 255, 0.3) 0px -1px 0;
                font-size: 13px;
                text-align: center;
                background: #161618;
            }
            #about p {
                margin-bottom: 8px;
            }
            #about a {
                color: #fff;
                font-weight: bold;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div id="about" class="selectable">
                <p><img src="./assets/about.png" /></p>
                <p><strong><cfoutput>#application.blogMobile.getProperty("title")#</cfoutput></strong><br />Version <cfoutput>#application.blogMobile.getProperty("appVersion")#</cfoutput><br />
                <p>
              	  <cfoutput>#application.blog.getProperty("blogDescription")#</cfoutput>
                </p>
                <p>
                	<BR>
				    <a href="http://www.jqtouch.com/" target="_blank">Built with jQtouch</a>
                	<BR>
                </p>
                	<BR>
				<p><a href="mailto: <cfoutput>#application.blog.getProperty("owneremail")#</cfoutput>?subject=Mobile app" rel="external" class="grayButton goback">Contact Us</a></p>
                <p><a href="#" class="grayButton goback">Close</a></p>
        </div>
       
        <div id="home" class="current">
            <div class="toolbar">
				<h1><cfoutput>#application.blogMobile.getProperty("shortTitle")#</cfoutput></h1>  
				<a href="#" class="button leftButton" id="homeBtn">Home</a>
                <a class="button swap" href="#about" id="infoButton">About</a>
            </div>
			
			<ul class="plastic" style="height: 5px;">	
				<li></li>
			</ul>
			
			 <ul class="plastic" id="blogList">		
			 		<cfinclude template="posts.cfm">
			 </ul>
			 
			 
			 <ul class="individual">
                <li class="grayButton" id="prevBtn">&#60;&#60; Previous</li>
                <li class="grayButton" id="moreBtn">More &#62;&#62;</li>
            </ul>
		
			
			
			
            <div class="info">
                <p>Add this page to your home screen to view the custom icon, startup screen, and full screen mode.</p>
				<BR>
				<p><a href="#" id="leaveMobileLink">Click Here</a> to exit mobile version.</p>
            </div>
        </div> 
		
		<cfif isDefined('loadPost')>
			<div id="<cfoutput>#hash(loadPost)#</cfoutput>"></div>
		</cfif>
		
	
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