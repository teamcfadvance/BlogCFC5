<cfcomponent>

	<cffunction name="init" access="public" returnType="downloadtracker" output="false">
		<cfreturn this>
	</cffunction>

<!---
	<cffunction name="generateRSS" access="remote" returnType="string" output="false"
				hint="Attempts to generate RSS 1.0">
		<cfargument name="mode" type="string" required="false" default="short" hint="If mode=short, show EXCERPT chars of entries. Otherwise, show all.">
		<cfargument name="excerpt" type="numeric" required="false" default="250" hint="If mode=short, this how many chars to show.">
		<cfargument name="params" type="struct" required="false" default="#structNew()#" hint="Passed to getEntries. Note, maxEntries can't be bigger than 15.">
		<cfargument name="version" type="numeric" required="false" default="2" hint="RSS verison, Options are 1 or 2">		
		<cfargument name="additionalTitle" type="string" required="false" default="" hint="Adds a title to the end of your blog title. Used mainly by the cat view.">
		
		<cfset var articles = "">
		<cfset var z = getTimeZoneInfo()>
		<cfset var header = "">
		<cfset var channel = "">
		<cfset var items = "">
		<cfset var dateStr = "">
		<cfset var rssStr = "">
		<cfset var utcPrefix = "">
		<cfset var rootURL = "">
		<cfset var cat = "">
		<cfset var lastid = "">
		<cfset var catid = "">
		<cfset var catlist = "">
		
		<!--- Right now, we force this in. Useful to limit throughput of RSS feed. I may remove this later. --->
		<cfif (structKeyExists(arguments.params,"maxEntries") and arguments.params.maxEntries gt 15) or not structKeyExists(arguments.params,"maxEntries")>
			<cfset arguments.params.maxEntries = 15>
		</cfif>
		
		<cfset articleData = getEntries(params)>
	    <cfset articles = articleData.entries>

		<cfif not find("-", z.utcHourOffset)>
			<cfset utcPrefix = " -">
		<cfelse>
			<cfset z.utcHourOffset = right(z.utcHourOffset, len(z.utcHourOffset) -1 )>
			<cfset utcPrefix = " +">
		</cfif>
		
		
		<cfif arguments.version is 1>
	
			<cfsavecontent variable="header">
			<cfoutput>
			<?xml version="1.0" encoding="utf-8"?>
			
			<rdf:RDF 
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
				xmlns:dc="http://purl.org/dc/elements/1.1/"
				xmlns="http://purl.org/rss/1.0/"
			>
			</cfoutput>
			</cfsavecontent>
	
			<cfsavecontent variable="channel">
			<cfoutput>
			<channel rdf:about="#xmlFormat(instance.blogURL)#">
			<title>#xmlFormat(instance.blogTitle)##xmlFormat(arguments.additionalTitle)#</title>
			<description>#xmlFormat(instance.blogDescription)#</description>
			<link>#xmlFormat(instance.blogURL)#</link>
		
			<items>
				<rdf:Seq>
					<cfloop query="articles">
					<rdf:li rdf:resource="#xmlFormat(makeLink(id))#" />
					</cfloop>
				</rdf:Seq>
			</items>
			
			</channel>
			</cfoutput>
			</cfsavecontent>
	
			<cfsavecontent variable="items">
			<cfloop query="articles">
			<cfset dateStr = dateFormat(posted,"yyyy-mm-dd")>
			<cfset dateStr = dateStr & "T" & timeFormat(posted,"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & ":00">
			<cfoutput>
		  	<item rdf:about="#xmlFormat(makeLink(id))#">
			<title>#xmlFormat(title)#</title>
			<description><cfif arguments.mode is "short" and len(REReplaceNoCase(body,"<[^>]*>","","ALL")) gte arguments.excerpt>#xmlFormat(left(REReplaceNoCase(body,"<[^>]*>","","ALL"),arguments.excerpt))#...<cfelse>#xmlFormat(body)#</cfif><cfif len(morebody)> [More]</cfif></description>
			<link>#xmlFormat(makeLink(id))#</link>
			<dc:date>#dateStr#</dc:date>
			<cfloop item="catid" collection="#categories#">
				<cfset catlist = listAppend(catlist, xmlFormat(categories[currentRow][catid]))>
			</cfloop>
			<dc:subject>#xmlFormat(catlist)#</dc:subject>

			</item>
			</cfoutput>
		 	</cfloop>
			</cfsavecontent>
	
			<cfset rssStr = trim(header & channel & items & "</rdf:RDF>")>
	
		<cfelseif arguments.version eq "2">
		
			<cfset rootURL = reReplace(instance.blogURL, "(.*)/index.cfm", "\1")>

			<cfsavecontent variable="header">
			<cfoutput>
			<?xml version="1.0" encoding="utf-8"?>
			
			<rss version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##" xmlns:cc="http://web.resource.org/cc/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:media="http://search.yahoo.com/mrss/">

			<channel>
			<title>#xmlFormat(instance.blogTitle)##xmlFormat(arguments.additionalTitle)#</title>
			<link>#xmlFormat(instance.blogURL)#</link>
			<description>#xmlFormat(instance.blogDescription)#</description>
			<language>#replace(lcase(instance.locale),'_','-','one')#</language>
			<pubDate>#dateFormat(blogNow(),"ddd, dd mmm yyyy") & " " & timeFormat(blogNow(),"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00"#</pubDate>
			<lastBuildDate>{LAST_BUILD_DATE}</lastBuildDate>
			<generator>BlogCFC</generator>
			<docs>http://blogs.law.harvard.edu/tech/rss</docs>
			<!---- JH DotComIt added code to turn e-mails into unitext, removed xmlformat ---->
			<managingEditor>#(variables.utils.EmailAntiSpam(instance.owneremail))#</managingEditor>
			<webMaster>#(variables.utils.EmailAntiSpam(instance.owneremail))#</webMaster>
			<media:copyright>Copyright 2008, DotComIt LLC</media:copyright>
			<media:thumbnail url="#xmlFormat(instance.itunesImage)#" />
			<media:keywords>#xmlFormat(instance.itunesKeywords)#</media:keywords>
			<media:category scheme="http://www.itunes.com/dtds/podcast-1.0.dtd">Technology/Software How-To</media:category>
			<media:category scheme="http://www.itunes.com/dtds/podcast-1.0.dtd">Technology/Tech News</media:category>

			<itunes:subtitle>#xmlFormat(instance.itunesSubtitle)#</itunes:subtitle>
			<itunes:summary>#xmlFormat(instance.itunesSummary)#</itunes:summary>
			<itunes:category text="Technology">
				<itunes:category text="Software How-To" />
			</itunes:category>
			<itunes:category text="Technology">
				<itunes:category text="Podcasting" />
			</itunes:category>
			<itunes:category text="Technology">
				<itunes:category text="Tech News" />
			</itunes:category>
			<itunes:keywords>#xmlFormat(instance.itunesKeywords)#</itunes:keywords>
			<itunes:author>#xmlFormat(instance.itunesAuthor)#</itunes:author>
			<itunes:owner>
				<itunes:email>#xmlFormat(instance.owneremail)#</itunes:email>
				<itunes:name>#xmlFormat(instance.itunesAuthor)#</itunes:name>
			</itunes:owner>
			<itunes:image href="#xmlFormat(instance.itunesImage)#" />
			<image>
				<url>#xmlFormat(instance.itunesImage)#</url>
				<title>#xmlFormat(instance.blogTitle)#</title>
				<link>#xmlFormat(instance.blogURL)#</link>
			</image>
			<itunes:explicit>#xmlFormat(instance.itunesExplicit)#</itunes:explicit>
			</cfoutput>
			</cfsavecontent>
		
			<cfsavecontent variable="items">
			<cfloop query="articles">
			<cfset dateStr = dateFormat(posted,"ddd, dd mmm yyyy") & " " & timeFormat(posted,"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00">
			<cfoutput>
			<item>
				<title>#xmlFormat(title)#</title>
				<link>#xmlFormat(makeLink(id))#</link>
				<description>
				<!--- Regex operation removes HTML code from blog body output --->
				<cfif arguments.mode is "short" and len(REReplaceNoCase(body,"<[^>]*>","","ALL")) gte arguments.excerpt>
				#xmlFormat(left(REReplace(body,"<[^>]*>","","All"),arguments.excerpt))#...
				<cfelse>#xmlFormat(body)#</cfif>
				<cfif len(morebody)> [More]</cfif>
				</description>
				<cfset lastid = listLast(structKeyList(categories))>		
				<cfloop item="catid" collection="#categories#">
				<category>#xmlFormat(categories[currentRow][catid])#</category>				
				</cfloop>
				<pubDate>#dateStr#</pubDate>
				<guid>#xmlFormat(makeLink(id))#</guid>
				<author>#xmlFormat(instance.owneremail)# (#xmlFormat(instance.itunesAuthor)#)</author>
				
				<cfif len(enclosure)>
				<enclosure url="#xmlFormat("#rooturl#/download.cfm/id/#id#/#getFileFromPath(enclosure)#")#" length="#filesize#" type="#mimetype#"/>
				<cfif mimetype IS "audio/mpeg">
				<itunes:author>#xmlFormat(instance.itunesAuthor)#</itunes:author>
				<itunes:explicit>#xmlFormat(instance.itunesExplicit)#</itunes:explicit>
				<itunes:duration>#xmlFormat(duration)#</itunes:duration>
				<itunes:keywords>#xmlFormat(keywords)#</itunes:keywords>
				<itunes:subtitle>#xmlFormat(subtitle)#</itunes:subtitle>
				<itunes:summary>#xmlFormat(summary)#</itunes:summary>
				<itunes:image href="#xmlFormat(instance.itunesImage)#" />
				</cfif>
				</cfif>
			</item>
			</cfoutput>
		 	</cfloop>
			</cfsavecontent>
		
			<cfset header = replace(header,'{LAST_BUILD_DATE}','#dateFormat(articles.posted[1],"ddd, dd mmm yyyy") & " " & timeFormat(articles.posted[1],"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00"#','one')>
			<cfset rssStr = trim(header & items & "</channel></rss>")>
		
		</cfif>
							
		<cfreturn rssStr>
		
	</cffunction>
--->

<!---

	<cffunction name="getEntry" access="remote" returnType="struct" output="false"
				hint="Returns one particular entry.">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="dontlog" type="boolean" required="false" default="false">
		<cfargument name="IsAvailable" type="boolean" required="false" default="true">
		<cfset var getIt = "">
		<cfset var s = structNew()>
		<cfset var col = "">
		<cfset var getCategories = "">
		
		<cfif not entryExists(arguments.id,arguments.IsAvailable)>
			<cfset variables.utils.throw("#arguments.id# does not exist.")>
		</cfif>
	
		<cfquery name="getIt" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			select		#application.tableprefix#tblBlogEntries.id, #application.tableprefix#tblBlogEntries.title, 
						<!--- Handle offset --->
						<cfif instance.blogDBType is "MSACCESS">
						dateAdd('h', #instance.offset#, #application.tableprefix#tblBlogEntries.posted) as posted, 
						<cfelseif instance.blogDBType is "MSSQL">
						dateAdd(hh, #instance.offset#, #application.tableprefix#tblBlogEntries.posted) as posted, 
						<cfelseif instance.blogDBType is "ORACLE">
						#application.tableprefix#tblBlogEntries.posted + (#instance.offset#/24) as posted,
						<cfelse>
						date_add(posted, interval #instance.offset# hour) as posted, 
						</cfif>
						#application.tableprefix#tblBlogEntries.body, 
						#application.tableprefix#tblBlogEntries.morebody, #application.tableprefix#tblBlogEntries.alias, #application.tableprefix#tblUsers.name, #application.tableprefix#tblBlogEntries.allowcomments,
						#application.tableprefix#tblBlogEntries.enclosure, #application.tableprefix#tblBlogEntries.filesize, #application.tableprefix#tblBlogEntries.mimetype, #application.tableprefix#tblBlogEntries.released, #application.tableprefix#tblBlogEntries.mailed,
						#application.tableprefix#tblBlogEntries.summary, #application.tableprefix#tblBlogEntries.keywords, #application.tableprefix#tblBlogEntries.subtitle, #application.tableprefix#tblBlogEntries.duration
			from		#application.tableprefix#tblBlogEntries, #application.tableprefix#tblUsers
			where		#application.tableprefix#tblBlogEntries.id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			and			#application.tableprefix#tblBlogEntries.blog = <cfqueryparam value="#instance.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
			and			#application.tableprefix#tblBlogEntries.username = #application.tableprefix#tblUsers.username
		</cfquery>

		<cfquery name="getCategories" datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			select	categoryid,categoryname
			from	#application.tableprefix#tblBlogCategories, #application.tableprefix#tblblogentriescategories
			where	#application.tableprefix#tblblogentriescategories.entryidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			and		#application.tableprefix#tblblogentriescategories.categoryidfk = #application.tableprefix#tblBlogCategories.categoryid
		</cfquery>
				
		<cfloop index="col" list="#getIt.columnList#">
			<cfset s[col] = getIt[col][1]>
		</cfloop>

		<cfset s.categories = structNew()>
		<cfloop query="getCategories">
			<cfset s.categories[categoryid] = categoryname>
		</cfloop>
		
		<!--- Handle view --->
		<cfif not arguments.dontlog>
			<cfquery datasource="#instance.dsn#" username="#instance.username#" password="#instance.password#">
			update	#application.tableprefix#tblBlogEntries
			set		views = views + 1
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfquery>
		</cfif>
				
		<cfreturn s>
		
	</cffunction>--->



	<!--- added by Jeffry Houser --->
	<cffunction name="logEnclosureDownload" access="public" returnType="void" output="false"
				hint="I save download, or view, data based on an enclosure">
		<cfargument name="id" type="string" required="true" hint="entry.id">
		<cfargument name="enclosure" type="string" required="true" hint="entry.enclosure">
		<cfargument name="dir" type="string" required="true" hint="url.dir">
		<cfargument name="online" type="Boolean" required="false" default="0" hint="url.online">

		
		<cfquery datasource="#application.blog.getProperty("dsn")#" username="#application.blog.getProperty("username")#" password="#application.blog.getProperty("password")#">
			insert into #application.tableprefix#tblblogenclosuredownloads(id,entryid,ipaddress,http_referrer, HTTP_USER_AGENT, downloaddate, downloadtime, enclosure,Path, online )
			values(
				<cfqueryparam value="#createuuid()#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfif arguments.id is 0>
					null,
				<cfelse>
					<cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35" >,
				</cfif> <!--- null="#not(YesNoFormat(entry.id))#" --->
				<cfqueryparam value="#cgi.REMOTE_ADDR#" cfsqltype="CF_SQL_VARCHAR" maxlength="15">,
				<cfqueryparam value="#cgi.HTTP_REFERER#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				<cfqueryparam value="#cgi.HTTP_USER_AGENT#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				#createodbcdate(now())#, #createodbctime(now())#, 
				<cfqueryparam value="#getFileFromPath(arguments.enclosure)#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				<cfqueryparam value="#arguments.dir#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				<cfqueryparam value="#arguments.online#" cfsqltype="cf_sql_bit">		
				 )
		</cfquery>
			

	</cffunction>

	<!--- added by Jeffry Houser --->
	<cffunction name="generateDownloadReport" access="public" returnType="query" output="false"
				hint="I figure out how many episode downloads have happened in the given time frame">
		<cfargument name="StartDate" type="date" required="false" default="#now()#">
		<cfargument name="EndDate" type="date" required="false" default="#now()#">
		
		<cfset var generateReport = "">
		
		<!--- Query to differentiate between on-line and not online stats 
SELECT     TOP 100 PERCENT dbo.#application.tableprefix#tblBlogEntries.id, dbo.#application.tableprefix#tblBlogEntries.title, COUNT(dbo.#application.tableprefix#tblblogenclosuredownloads.entryid) AS TotalDownloads
FROM         dbo.#application.tableprefix#tblBlogEntries INNER JOIN
                      dbo.#application.tableprefix#tblblogenclosuredownloads ON dbo.#application.tableprefix#tblBlogEntries.id = dbo.#application.tableprefix#tblblogenclosuredownloads.entryid
WHERE     (dbo.#application.tableprefix#tblblogenclosuredownloads.Online = 0) AND (dbo.#application.tableprefix#tblblogenclosuredownloads.downloaddate BETWEEN CONVERT(DATETIME, '2008-09-01', 102) 
                      AND CONVERT(DATETIME, '2008-11-30', 102))
GROUP BY dbo.#application.tableprefix#tblBlogEntries.id, dbo.#application.tableprefix#tblBlogEntries.title
ORDER BY dbo.#application.tableprefix#tblBlogEntries.title		
		
		---->
		
		<cfquery name="generateReport" datasource="#application.blog.getProperty("dsn")#" username="#application.blog.getProperty("username")#" password="#application.blog.getProperty("password")#">
			SELECT     TOP 100 PERCENT dbo.#application.tableprefix#tblBlogEntries.id, dbo.#application.tableprefix#tblBlogEntries.posted, dbo.#application.tableprefix#tblBlogEntries.title, COUNT(dbo.#application.tableprefix#tblblogenclosuredownloads.entryid) AS TotalDownloads
			FROM         dbo.#application.tableprefix#tblBlogEntries INNER JOIN
			                      dbo.#application.tableprefix#tblblogenclosuredownloads ON dbo.#application.tableprefix#tblBlogEntries.id = dbo.#application.tableprefix#tblblogenclosuredownloads.entryid
			where dbo.#application.tableprefix#tblblogenclosuredownloads.downloaddate between #createodbcdate(startdate)#  and #createodbcdate(enddate)# 
			GROUP BY dbo.#application.tableprefix#tblBlogEntries.id, dbo.#application.tableprefix#tblBlogEntries.posted, dbo.#application.tableprefix#tblBlogEntries.title
			ORDER BY dbo.#application.tableprefix#tblBlogEntries.posted, dbo.#application.tableprefix#tblBlogEntries.title
		</cfquery>
		
		<Cfreturn generateReport>

	</cffunction>

	<cffunction name="generateImpressionReport" access="public" returnType="query" output="false"
				hint="I figure out how many impressions different media has had">
		<cfargument name="StartDate" type="date" required="false" default="#now()#">
		<cfargument name="EndDate" type="date" required="false" default="#now()#">

		<cfset var generateReport = "">
		
		<cfquery name="generateReport" datasource="#application.blog.getProperty("dsn")#" username="#application.blog.getProperty("username")#" password="#application.blog.getProperty("password")#">
<!--- 
	This is causing problems; not properly filtering out date data

			select distinct ad_MediaViews.MediaText, ad_MediaViews.totalViews, ad_MediaViews.Description
			from ad_MediaViews  
				join ad_MediaLog on (Ad_MediaViews.MediaID = ad_MediaLog.mediaID and 
										ad_MediaLog.DateDisplayed between #createodbcdate(startdate)#  and #createodbcdate(enddate)#)
 --->
			select count(ad_MediaLog.MediaLogID) as totalviews, ad_Media.MediaText, ad_Media.Description
			from ad_MediaLog, ad_Media
			where ( ad_MediaLog.DateDisplayed between #createodbcdate(startdate)#  and #createodbcdate(enddate)# ) and 
					ad_media.mediaID = ad_MediaLog.MediaID
			group by ad_Media.MediaText, ad_Media.Description

		</cfquery>

		
		
		<Cfreturn generateReport>

	</cffunction>

</cfcomponent>