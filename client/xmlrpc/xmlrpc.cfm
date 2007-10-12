<cfprocessingdirective pageencoding="utf-8">
<cfsetting enablecfoutputonly=true>
<!---
	Name         : C:\projects\blogcfc5\client\xmlrpc\xmlrpc.cfm
	Author       : Raymond Camden 
	Created      : 09/15/06
	Last Updated : 7/20/07
	History      : Scott Pinkstonadded newMediaObject
				 : fix for categories (rkc 10/12/06)
				 : multiple udpates related to Captivate (rkc 10/31/06)
				 : Another fix. Did someone say XML-RPC was a spec? Bull-pucky. (rkc 11/30/06)
				 : Fix so remote clients can see unreleased/future entries
				 : ScottP added metaWeblog.getUB to first cfcase (rkc 7/20/07)
--->

<cffunction name="translateCategory" returnType="uuid">
	<cfargument name="category" type="string" required="true">
	
	<cfreturn application.blog.getCategoryByName(arguments.category)>
</cffunction>

<cfset xmlrpc = createObject("component", "xmlrpc")>

<cfif not len(getHTTPRequestData().content)>
	<!--- no content sent --->
	<cfabort>
</cfif>

<cfset requestData = xmlrpc.xmlrpc2cfml(getHTTPRequestData().content)>

<cfset result = "">
<cfset type = "responsefault">

<cfswitch expression="#requestData.method#">

	<cfcase value="blogger.getUsersBlogs,metaWeblog.getUsersBlogs">
		<cfset info = structNew()>
		<cfset info["url"] = application.rooturl>
		<cfset info["blogid"] = "$string" & "1">
		<cfset info["blogName"] = application.blog.getProperty("name")>
		<cfset result = arrayNew(1)>
		<cfset result[1] = info>
		
		<cfset type="response">
	</cfcase>

	<cfcase value="metaWeblog.getCategories,mt.getCategoryList">

		<cfset appkey = requestData.params[1]>
		<cfset username = requestData.params[2]>
		<cfset password = requestData.params[3]>

		<cfif application.blog.authenticate(username,password)>
			<!--- This remote method isn't secured, so no need for 
				  cflogin, but I still do the auth check above to 
				  ensure only proper remote clients call this.
			--->

			<cfset result = arrayNew(1)>
		
			<cfset categories = application.blog.getCategories()>
		
			<cfloop query="categories">	
				<cfset info = structNew()>
				
				<cfif requestData.method is "metaWeblog.getCategories">
					<cfset info["description"] = categoryname>
					<cfset info["htmlUrl"] = "$string" & application.blog.makeCategoryLink(categoryid)>
					<cfset info["rssUrl"] = "$string" & "#application.rootURL#/rss.cfm?mode=full&mode2=cat&catid=#categoryid#">
					
					<cfset info["title"] = categoryname>
					<!--- Added to make it work in Mars Edit --->
					<cfset info["categoryName"] = categoryname>
					<cfset info["categoryid"] = categoryid>
				<cfelse>
					<cfset info["categoryName"] = categoryname>
					<cfset info["categoryId"] = categoryid>				
				</cfif>
				<cfset arrayAppend(result, info)>
			</cfloop>
		
			<cfset type="response">
			
		</cfif>
		
	</cfcase>

	<cfcase value="metaWeblog.getRecentPosts">
	
		<cfset appkey = requestData.params[1]>
		<cfset username = requestData.params[2]>
		<cfset password = requestData.params[3]>

		<cfif application.blog.authenticate(username,password)>
			<!--- This remote method isn't secured, so no need for 
				  cflogin, but I still do the auth check above to 
				  ensure only proper remote clients call this.
				  
				  Actually I lie. Sim noted that you won't get unreleased entries w/o this.
			--->
			<cfloginuser name="#username#" password="#password#" roles="admin">
			
			<cfset params = structNew()>
			<cfset params.maxEntries = requestData.params[4]>
			<cfset entries = application.blog.getEntries(params)>
			<cfset result = arrayNew(1)>
			<cfloop query="entries">
				<cfset item = structNew()>
				<cfset item["title"] = title>
				<cfset item["dateCreated"] = posted>
				<cfset item["userid"] = name>
				<cfset item["postid"] = id>
				<cfset item["description"] = body & morebody>
			
				<cfset item["link"] = application.blog.makeLink(id)>
				<cfset item["permaLink"] = application.blog.makeLink(id)>
				<cfset item["mt_excerpt"] = "">
				<cfset item["mt_text_more"] = "">
				<cfif allowcomments>
					<cfset item["mt_allow_comments"] = "$int1">
				<cfelse>
					<cfset item["mt_allow_comments"] = "$int0">
				</cfif>
				<cfset item["mt_allow_pings"] = "$int1">
				<cfset item["mt_convert_breaks"] = "__default__">
				<cfset item["mt_keywords"] = "">
				
				<cfset item["categories"] = arrayNew(1)>
				<cfloop item="catid" collection="#categories#">
					<cfset arrayAppend(item["categories"], categories[currentRow][catid])>
				</cfloop>
				
				<cfset arrayAppend(result,item)>
			</cfloop>
			
			<cfset type="response">
			
		</cfif>
		
	</cfcase>

	<cfcase value="metaWeblog.getPost">
	
		<cfset id = requestData.params[1]>
		<cfset username = requestData.params[2]>
		<cfset password = requestData.params[3]>

		<cfif application.blog.authenticate(username,password)>
			<!--- This remote method isn't secured, so no need for 
				  cflogin, but I still do the auth check above to 
				  ensure only proper remote clients call this.
			--->
			<cfset entry = application.blog.getEntry(id,true)>
			<cfset item = structNew()>
			<cfset item["title"] = entry.title>
			<cfset item["dateCreated"] = entry.posted>
			<cfset item["userid"] = entry.name>
			<cfset item["postid"] = entry.id>
			<cfset item["description"] = entry.body & entry.morebody>
			
			<cfset item["link"] = application.blog.makeLink(id)>
			<cfset item["permaLink"] = application.blog.makeLink(id)>
			<cfset item["mt_excerpt"] = "">
			<cfset item["mt_text_more"] = "">
			<cfif entry.allowcomments>
				<cfset item["mt_allow_comments"] = "$int1">
			<cfelse>
				<cfset item["mt_allow_comments"] = "$int0">
			</cfif>
			<cfset item["mt_allow_pings"] = "$int1">
			<cfset item["mt_convert_breaks"] = "__default__">
			<cfset item["mt_keywords"] = "">
			<cfset item["categories"] = "">
			
			<cfloop item="c" collection="#entry.categories#">	
				<cfset item["categories"] = listAppend(item["categories"], entry.categories[c])>
			</cfloop>
			
			<cfset result = item>
			<cfset type="response">
			
		</cfif>
		
	</cfcase>

	<cfcase value="blogger.deletePost">
		<cfset appkey = requestData.params[1]>
		<cfset postid = requestData.params[2]>
		<cfset username = requestData.params[3]>
		<cfset password = requestData.params[4]>
		<cfset publish = requestData.params[5]>
		
		<cfif application.blog.authenticate(username,password)>
			<cfloginuser name="#username#" password="#password#" roles="admin">
			<cfset application.blog.deleteEntry(postid)>
			<cfset result = "$boolean1">
		<cfelse>
			<cfset result = "$boolean0">
		</cfif>
		
		<cfset type="response">
		
	</cfcase>
		
	<cfcase value="metaWeblog.newPost,metaWeblog.editPost">

		<cfif requestData.method is "metaWeblog.editPost">
			<cfset currentID = requestData.params[1]>
		<cfelse>
			<cfset appkey = requestData.params[1]>
		</cfif>
		<cfset username = requestData.params[2]>
		<cfset password = requestData.params[3]>
		<cfset bareentry = requestData.params[4]>
		<cfset published = requestData.params[5]>
		
		<!--- 
		Convert the remote keys to keys blog understands.
		--->
		<cfset entry = structNew()>
		<cfset entry.title = bareentry.title>
		<cfset entry.body = bareentry.description>
		<!--- TODO: Handle <more/> --->
		<cfset entry.morebody = "">		
		<cfif structKeyExists(bareentry, "dateCreated")>
			<cfset entry.posted = bareentry.dateCreated>
		<cfelseif structKeyExists(bareentry, "pubDate") and isDate(bareentry.pubDate)>
			<cfset entry.posted = bareentry.pubDate>
		<cfelse>
			<cfset entry.posted = now()>
		</cfif>
		
		<!--- TODO: Fix allowcomments --->
		<cfset entry.allowcomments = true>
		<!--- TODO: Allow enclosures --->
		<cfset entry.enclosure = "">
		<cfset entry.filesize = 0>
		<cfset entry.released = published>
		
		<!---
		Contribute sends a fake post to generate a design template.
		We need to ensure that this fake post doesn't send an email.
		Let's try making it not released and see if that works.
		
		Nope, that didn't work. Ok, adding a new "sendemail" entry.
		--->
		<cfif entry.title is "####TITLE####" and entry.body is "####CONTENT####">
			<cfset entry.sendemail = true>
		</cfif>

		<cfif application.blog.authenticate(username,password)>

			<cfloginuser name="#username#" password="#password#" roles="admin">
	
			<cfif requestData.method is "metaWeblog.editPost">
				<cfinvoke component="#application.blog#" method="saveEntry" returnVariable="newid">
					<cfinvokeargument name="id" value="#currentID#">
					<cfloop item="key" collection="#entry#">
						<cfinvokeargument name="#key#" value="#entry[key]#">
					</cfloop>
				</cfinvoke>
				<cfset entryid = currentID>
				<cfset result = "$boolean1">	
			<cfelse>	
				<cfset entry.alias = application.blog.makeTitle(entry.title)>
	
				<cfinvoke component="#application.blog#" method="addEntry" returnVariable="newid">
					<cfloop item="key" collection="#entry#">
						<cfinvokeargument name="#key#" value="#entry[key]#">
					</cfloop>
				</cfinvoke>
				<cfset entryid = newid>
				<cfset result = newid>
			</cfif>


			<cfset catlist = "">
			<cfif structKeyExists(bareentry, "categories")>
				<cfloop index="x" from="1" to="#arrayLen(bareentry.categories)#">
					<cfset catid = translateCategory(bareentry.categories[x])>
					<cfset catlist = listAppend(catlist, catid)>
				</cfloop>
			<cfelseif structKeyExists(bareentry, "category") and len(bareentry.category)>
				<cfset catid = translateCategory(bareentry.category)>
				<cfset catlist = listAppend(catlist, catid)>		
			</cfif>
						
			<cfif len(catlist)>
				<cfset application.blog.assignCategories(entryid, catlist)>
			</cfif>

			<!--- clear cache --->			
			<cfmodule template="../tags/scopecache.cfm" scope="application" clearall="true">

			<cfset type="response">
			
		<cfelse>
	
		</cfif>
				
	</cfcase>

	<cfcase value="metaWeblog.newMediaObject">
		<cfset username = requestData.params[2]>
		<cfset password = requestData.params[3]>
	
		<cfif application.blog.authenticate(username,password)>
	
			<cfset upFileData = requestData.params[4].bits>
			<cfset upFileName = listlast(requestData.params[4].name, "/")>
			<cfset upFileType = requestData.params[4].type>
			
			<cfset destination = expandPath("../enclosures")>
	
			<cfif not directoryExists(destination)>
				<cfdirectory action="create" directory="#destination#">
			</cfif>
	
			<cffile action="write" output="#upFileData#" file="#destination#/#upFileName#" nameconflict="makeunique">
	
			<cfset result = structNew()>
			<cfset result["url"] = "$string" & "#application.rootURL#/enclosures/#upFileName#">
	
		<cfelse>
		
			<cfset result = "$boolean0">
		
		</cfif>
	
		<cfset type="response">
		
	</cfcase>
		
	<cfcase value="mt.getPostCategories">

		<cfset postid = requestData.params[1]>		
		<cfset username = requestData.params[2]>
		<cfset password = requestData.params[3]>
	
		<cfif application.blog.authenticate(username,password)>
			<cfset entry = application.blog.getEntry(postid,true)>

			<cfset item = structNew()>
			<cfset item["categories"] = "">
			
			<cfloop item="c" collection="#entry.categories#">	
				<cfset item["categories"] = listAppend(item["categories"], entry.categories[c])>
			</cfloop>
			
			<cfset result = item>
			<cfset type="response">

		</cfif>
		
	</cfcase>

	<cfcase value="mt.setPostCategories">

		<cfset postid = requestData.params[1]>		
		<cfset username = requestData.params[2]>
		<cfset password = requestData.params[3]>
	
		<cfif application.blog.authenticate(username,password)>

			<cfloginuser name="#username#" password="#password#" roles="admin">

			<cfif arrayLen(requestData.params) gte 4>
				
				<cfset application.blog.removeCategories(postid)>
				<cfset catlist = "">
				<cfloop index="x" from="1" to="#arrayLen(requestData.params[4])#">
					<cfset catlist = listAppend(catlist, requestData.params[4][x].categoryID)>
				</cfloop>
				<cfset application.blog.assignCategories(postid, catlist)>

				<cfset result = "$boolean1">

				<cfset type="response">

			</cfif>
		</cfif>
		
	</cfcase>
		
</cfswitch>

<cfset pResult = arrayNew(1)>
<cfset pResult[1] = result>
<cfset resultData = xmlrpc.cfml2xmlrpc(data=pResult,type=type)>



<cfcontent type="text/xml; charset=utf-8"><cfoutput><?xml version="1.0" encoding="ISO-8859-1"?>#resultData#</cfoutput>
