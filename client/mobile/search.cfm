

<cfparam name="form.searchTxt" default="">

<cfoutput>

<div data-role="page" data-theme="#application.primaryTheme#">

	<cf_header title="Search" showHome="2" id="blogHeader">
	
	<div data-role="content command-no-cache" data-theme="b" >	
		<form action="search.cfm?" method="post">
		<div data-role="fieldcontain">
		    <label for="search"></label>
		    <input type="search" name="searchTxt" id="search" value="<cfoutput>#form.searchTxt#</cfoutput>" />
			<input type="submit" value="Search" data-theme="b"/>
		</div>
		 
		
		</form>
		
		
		<cfif len(trim(form.searchTxt)) gte 3>
		
		
			<cfset form.searchTxt = left(htmlEditFormat(trim(form.searchTxt)),255)>
			
			
			<cfset params = structNew()>
			<cfset params.searchTerms = form.searchTxt>
			<cfset params.startrow = 1>
			<cfset params.maxEntries = 9999>
			<cfset params.releasedonly = true />
			
			<cfset articleData = application.blog.getEntries(params)>
			<cfset articles = articleData.entries>
			
			<ul data-role="listview">
				<cfinclude template="posts.cfm">
			</ul>		
			
			
		</cfif>
		
		
		
	</div><!-- /content -->	
	
	
	<cf_footer />
	<!-- /footer --> 
	
	
</div><!-- /page -->
</cfoutput>