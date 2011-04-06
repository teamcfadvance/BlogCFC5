

<cfset params.startrow = 1>
<cfset params.maxEntries = 999>
<cfset params.byCat = application.blog.getCategoryByAlias(url.catid)>
<cfset articleData = application.blog.getEntries(params)>
<cfset articles = articleData.entries>

<cfset catInfo = application.blog.getCategory(params.byCat)>

<cfoutput>

<div data-role="page"  data-theme="#application.primaryTheme#">

	
	<cf_header title="#catInfo.CATEGORYNAME#" showHome="2" id="blogHeader">

	<div data-role="content" >
		<ul data-role="listview">
			<cfinclude template="posts.cfm">
		</ul>			
	</div><!-- /content -->	
	
	
	<cf_footer />
	<!-- /footer --> 
	
	
</div><!-- /page -->
</cfoutput>