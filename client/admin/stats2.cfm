<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Stats
	Author       : Jeffry Houser
	Created      : October 17 2015
	History      : 
	Purpose		 : Graphs about posts and categories 
--->

<cfmodule template="../tags/adminlayout.cfm" title="#request.rb("stats")#">
	
	<cfset dsn = application.blog.getProperty("dsn")>
	<cfset dbtype = application.blog.getProperty("blogdbtype")>
	<cfset blog = application.blog.getProperty("name")>
	<cfset username = application.blog.getProperty("username")>
	<cfset password = application.blog.getProperty("password")>
	
	<!--- get a bunch of crap --->
	<cfquery name="getEntriesByYear" datasource="#dsn#" username="#username#" password="#password#">
		SELECT yearPosted,numberOfEntries
		  FROM NumberOfBlogEntriesByYear
  	</cfquery>


<!--- query for personal vs professional posts --->
	<cfquery name="getPersonalPosts" datasource="#dsn#" username="#username#" password="#password#">
		SELECT yearPosted, categoryname,numberofEntries
		FROM NumberOfBlogEntriesByYearThenCategory
		where categoryname = 'Personal'
  	</cfquery>
	<cfquery name="getProfessionalPosts" datasource="#dsn#" username="#username#" password="#password#">
		SELECT yearPosted, categoryname,numberofEntries
		FROM NumberOfBlogEntriesByYearThenCategory
		where categoryname = 'Professional'
  	</cfquery>



	<!--- query for posts by year by cateegory --->
	<cfquery name="getEntriesByYearByCategory" datasource="#dsn#" username="#username#" password="#password#">
		SELECT yearPosted, categoryname,numberofEntries
		FROM NumberOfBlogEntriesByYearThenCategory
		where categoryName not in ('Personal','Professional')
		order by yearPosted , categoryname
  	</cfquery>



<!--- Flex vs ColdFusion vs AngularJS --->
	<cfquery name="getFlexPosts" datasource="#dsn#" username="#username#" password="#password#">
		SELECT yearPosted, categoryname,numberofEntries
		FROM NumberOfBlogEntriesByYearThenCategory
		where categoryname = 'Flex'
  	</cfquery>
	<cfquery name="getColdFusionPosts" datasource="#dsn#" username="#username#" password="#password#">
		SELECT yearPosted, categoryname,numberofEntries
		FROM NumberOfBlogEntriesByYearThenCategory
		where categoryname = 'ColdFusion'
  	</cfquery>
	<cfquery name="getAngularJSPosts" datasource="#dsn#" username="#username#" password="#password#">
		SELECT yearPosted, categoryname,numberofEntries
		FROM NumberOfBlogEntriesByYearThenCategory
		where categoryname = 'AngularJS'
  	</cfquery>

<cfoutput>
<h2>Number of Entries Per Year</h2>
</cfoutput>
<cfchart > 
    <cfchartseries type="line" query="getEntriesByYear" valueColumn="numberOfEntries" itemColumn="yearPosted">  
    </cfchartseries> 
</cfchart>


<cfoutput>
<h2>Personal vs Professional Posts</h2>

</cfoutput>



<cfchart showlegend="true" >  
	<!---
    <cfchartseries type="line" label="Personal Posts" query="getPersonalPosts" valueColumn="numberOfEntries" itemColumn="yearPosted"> 
	--->
	<cfset variables.previousYear = getPersonalPosts.yearPosted/>
	
	
    <cfchartseries type="line" label="Personal Posts" > 
		<cfloop query="getPersonalPosts">
			<cfif variables.previousYear LT (yearPosted-1)>
				<cfoutput>#variables.previousYear#" <Br/><br/></cfoutput>
				<cfset variables.startIndex = variables.previousYear+1 />
				<cfset variables.endIndex = yearPosted-1 />
				<cfloop index="variables.tempIndex" from="#variables.startIndex#" to="#variables.endIndex#" >
					<cfchartdata item="#variables.tempIndex#" value="0" />
				</cfloop>

			</cfif>
			<cfchartdata item="#yearPosted#" value="#numberOfEntries#" />
			<cfset variables.previousYear = yearPosted/>
		</cfloop>
    </cfchartseries> 
<!---
    <cfchartseries type="line"  label="Professional Posts"  query="getProfessionalPosts" valueColumn="numberOfEntries" itemColumn="yearPosted"> 
--->
	<cfset variables.previousYear = getProfessionalPosts.yearPosted/>
    <cfchartseries type="line"  label="Professional Posts"  > 
		<cfloop query="getProfessionalPosts">
			<cfif variables.previousYear LT (yearPosted-1)>
				<cfoutput>#variables.previousYear#" <Br/><br/></cfoutput>
				<cfset variables.startIndex = variables.previousYear+1 />
				<cfset variables.endIndex = yearPosted-1 />
				<cfloop index="variables.tempIndex" from="#variables.startIndex#" to="#variables.endIndex#" >
					<cfchartdata item="#variables.tempIndex#" value="0" />
				</cfloop>

			</cfif>
			<cfchartdata item="#yearPosted#" value="#numberOfEntries#" />
			<cfset variables.previousYear = yearPosted/>
		</cfloop>
    </cfchartseries> 
</cfchart>


<cfoutput>
<h2>Number of Posts by Year by Category</h2>
</cfoutput>


<!---
 This one works best if query is sorted by categoryname, yearposted
<cfchart showlegend="true" chartHeight ="600" chartWidth="800">  
	<cfoutput query="getEntriesByYearByCategory" group="categoryName">
	    <cfchartseries type="bar" label="#getEntriesByYearByCategory.categoryName#" >
			<cfoutput>
				<cfchartdata item="#getEntriesByYearByCategory.yearPosted#" value="#getEntriesByYearByCategory.numberofEntries#" >				
			</cfoutput> 
	    </cfchartseries> 
	</cfoutput>
</cfchart>
--->

<!---
This query works best if query is sorted by yearposted, categoryname 
--->
<cfoutput query="getEntriesByYearByCategory" group="yearPosted">
	<cfchart showlegend="true" chartHeight ="500" chartWidth="500">  
			<cfoutput>
		    <cfchartseries type="bar" label="#getEntriesByYearByCategory.categoryName#" >
					<cfchartdata item="#getEntriesByYearByCategory.yearPosted#" value="#getEntriesByYearByCategory.numberofEntries#" >				
		    </cfchartseries> 
			</cfoutput> 
	</cfchart>
<Br/><br/>
</cfoutput>


<cfoutput>
<h2>ColdFusion vs Flex vs AngularJS c</h2>
</cfoutput>
<cfchart showlegend="true">  
	<cfset variables.previousYear = getProfessionalPosts.yearPosted/>
    <cfchartseries type="bar"  label="ColdFusion Posts"  > 
		<cfloop query="getColdFusionPosts">
			<cfif variables.previousYear LT (yearPosted-1)>
				<cfoutput>#variables.previousYear#" <Br/><br/></cfoutput>
				<cfset variables.startIndex = variables.previousYear+1 />
				<cfset variables.endIndex = yearPosted-1 />
				<cfloop index="variables.tempIndex" from="#variables.startIndex#" to="#variables.endIndex#" >
					<cfchartdata item="#variables.tempIndex#" value="0" />
				</cfloop>
			</cfif>
			<cfchartdata item="#yearPosted#" value="#numberOfEntries#" />
			<cfset variables.previousYear = yearPosted/>
		</cfloop>
    </cfchartseries> 


    <cfchartseries type="bar"  label="Flex Posts"  > 
		<cfloop query="getFlexPosts">
			<cfif variables.previousYear LT (yearPosted-1)>
				<cfoutput>#variables.previousYear#" <Br/><br/></cfoutput>
				<cfset variables.startIndex = variables.previousYear+1 />
				<cfset variables.endIndex = yearPosted-1 />
				<cfloop index="variables.tempIndex" from="#variables.startIndex#" to="#variables.endIndex#" >
					<cfchartdata item="#variables.tempIndex#" value="0" />
				</cfloop>
			</cfif>
			<cfchartdata item="#yearPosted#" value="#numberOfEntries#" />
			<cfset variables.previousYear = yearPosted/>
		</cfloop>
    </cfchartseries> 


    <cfchartseries type="bar"  label="AngularJS Posts"  > 
		<cfloop query="getAngularJSPosts">
			<cfif variables.previousYear LT (yearPosted-1)>
				<cfoutput>#variables.previousYear#" <Br/><br/></cfoutput>
				<cfset variables.startIndex = variables.previousYear+1 />
				<cfset variables.endIndex = yearPosted-1 />
				<cfloop index="variables.tempIndex" from="#variables.startIndex#" to="#variables.endIndex#" >
					<cfchartdata item="#variables.tempIndex#" value="0" />
				</cfloop>
			</cfif>
			<cfchartdata item="#yearPosted#" value="#numberOfEntries#" />
			<cfset variables.previousYear = yearPosted/>
		</cfloop>
    </cfchartseries> 
</cfchart>


<cfchart showlegend="true">  
	<cfset variables.previousYear = getProfessionalPosts.yearPosted/>
    <cfchartseries type="line"  label="ColdFusion Posts"  > 
		<cfloop query="getColdFusionPosts">
			<cfif variables.previousYear LT (yearPosted-1)>
				<cfoutput>#variables.previousYear#" <Br/><br/></cfoutput>
				<cfset variables.startIndex = variables.previousYear+1 />
				<cfset variables.endIndex = yearPosted-1 />
				<cfloop index="variables.tempIndex" from="#variables.startIndex#" to="#variables.endIndex#" >
					<cfchartdata item="#variables.tempIndex#" value="0" />
				</cfloop>
			</cfif>
			<cfchartdata item="#yearPosted#" value="#numberOfEntries#" />
			<cfset variables.previousYear = yearPosted/>
		</cfloop>
    </cfchartseries> 


    <cfchartseries type="line"  label="Flex Posts"  > 
		<cfloop query="getFlexPosts">
			<cfif variables.previousYear LT (yearPosted-1)>
				<cfoutput>#variables.previousYear#" <Br/><br/></cfoutput>
				<cfset variables.startIndex = variables.previousYear+1 />
				<cfset variables.endIndex = yearPosted-1 />
				<cfloop index="variables.tempIndex" from="#variables.startIndex#" to="#variables.endIndex#" >
					<cfchartdata item="#variables.tempIndex#" value="0" />
				</cfloop>
			</cfif>
			<cfchartdata item="#yearPosted#" value="#numberOfEntries#" />
			<cfset variables.previousYear = yearPosted/>
		</cfloop>
    </cfchartseries> 


    <cfchartseries type="line"  label="AngularJS Posts"  > 
		<cfloop query="getAngularJSPosts">
			<cfif variables.previousYear LT (yearPosted-1)>
				<cfoutput>#variables.previousYear#" <Br/><br/></cfoutput>
				<cfset variables.startIndex = variables.previousYear+1 />
				<cfset variables.endIndex = yearPosted-1 />
				<cfloop index="variables.tempIndex" from="#variables.startIndex#" to="#variables.endIndex#" >
					<cfchartdata item="#variables.tempIndex#" value="0" />
				</cfloop>
			</cfif>
			<cfchartdata item="#yearPosted#" value="#numberOfEntries#" />
			<cfset variables.previousYear = yearPosted/>
		</cfloop>
    </cfchartseries> 
</cfchart>

	
</cfmodule>

<cfsetting enablecfoutputonly=false>