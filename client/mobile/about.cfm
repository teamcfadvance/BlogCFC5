

<div data-role="page" >

	<div data-role="header" data-position="inline" data-theme="<cfoutput>#application.primaryTheme#</cfoutput>">	
		<h1><cfoutput>#application.blog.getProperty("blogTitle")#</cfoutput></h1>
	</div>

	<div style="text-align: center;" data-role="content" data-theme="<cfoutput>#application.primaryTheme#</cfoutput>" >
         <p><img src="./assets/about.png" /></p>
        <p><strong><cfoutput>#application.blogMobile.getProperty("title")#</cfoutput></strong><br />Version <cfoutput>#application.blogMobile.getProperty("appVersion")#</cfoutput><br />
        <p>
      	  <cfoutput>#application.blog.getProperty("blogDescription")#</cfoutput>
        </p>
        <p>
        	<BR>
		    <a href="http://www.jquerymobile.com/" target="_blank">Built with jQuery Mobile</a>
        	<BR>
        </p>
        	<BR>
		<p><a href="mailto:<cfoutput>#application.blog.getProperty("owneremail")#</cfoutput>?subject=Mobile app" rel="external" class="grayButton goback">Contact Us</a></p>

	</div><!-- /content -->	
	
	
	
	
	
</div><!-- /page -->


