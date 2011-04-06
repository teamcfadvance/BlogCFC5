

<cfparam name="attributes.aciveItem" default="">


<cfif thisTag.executionMode is "start">

		<div data-role="footer" data-position="fixed" data-id="blogFooterP"  class="nav-footer-custom-icons"> 

			
			<div data-role="navbar" class="nav-footer-custom-icons"> 
				<ul> 
					<li><a href="search.cfm?" data-icon="custom" id="searchFooterButton" <cfif attributes.aciveItem EQ "search">class="ui-btn-active"</cfif>>Search</a></li>
					<li><a href="categories.cfm?" data-icon="custom" id="categoryFooterButton" <cfif attributes.aciveItem EQ "cat">class="ui-btn-active"</cfif>>Categories</a></li>
					<li><a href="about.cfm?" data-icon="custom"  id="aboutFooterButton" data-rel="dialog" data-transition="slidedown">About</a></li>
					<li><a href="#" data-icon="custom" id="exitFooterButton">Exit Mobile</a></li> 
				</ul> 
			</div>
		</div>

</cfif>



		
		