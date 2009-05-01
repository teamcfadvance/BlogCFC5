<!---
LICENSE INFORMATION:

Copyright 2008, Adam Tuttle
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of SweetTweetsCFC (1.4).
http://sweettweetscfc.riaforge.org/
--->
<!---
	Author: Adam Tuttle
	Website: http://fusiongrokker.com
	Instructions: See example.cfm (and other examples) for usage
--->
<cfcomponent output="false">
	
	<cfset variables.urlService = ""/>
	<cfset variables.jsonService = ""/>
	<cfset variables.cacheLocation = "application"/>
	
	<cffunction name="init" output="false">
		<cfargument name="useLocalCache" type="boolean" default="true"/>
		<!--- save cache location --->
		<cfif arguments.useLocalCache>
			<cfset variables.cacheLocation = "variables"/>
		<cfelse>
			<cfset variables.cacheLocation = "application" />
		</cfif>
		<!--- Using shrinkURL from Andy Matthews: http://shrinkurl.riaforge.org/ --->
		<cfset variables.urlService = createObject("component","shrinkURL").init()/>
		<!--- Using JSONUtil from Nathan Mische: http://jsonutil.riaforge.org/ --->
		<cfset variables.jsonService = createObject("component","JSONUtil").init()/>
		<cfreturn this/>
	</cffunction>
	
	<!--- public functions --->
	<cffunction name="getTweetbacks" access="public" output="false" returntype="array">
		<cfargument name="uri" type="string" required="true"/>
		<cfscript>
			var local = structNew();
			var cacheKey = '';
			
			//first some business -- if being called remotely (ajax), jsonService and urlService will be blank! :(
			if (isSimpleValue(variables.urlService)){variables.urlService = createObject("component", "shrinkURL").init();}
			if (isSimpleValue(variables.jsonService)){variables.jsonService = createObject("component", "JSONUtil").init();}

			//strip any bookmarks from the url
			arguments.uri = listFirst(arguments.uri,'##');
			
			//setup cache
			cacheKey = hash(arguments.uri);
			setupCache(cacheKey);
			
			//check tweetback cache, updates every 5 minutes at most
			if (not tweetCacheExpired(cacheKey)){
				local.tweets = getTweetCache(cacheKey);
			}else{
				local.thisSearch = getTweetSearchUrl(arguments.uri);
				local.shortened = getShortUrls(arguments.uri);

				local.tweets = makeTwitterSearchRequest(local.thisSearch).results;
				local.tweets = killImpostors(local.tweets,local.shortened);
				local.tweets = cleanup(local.tweets);

				//cache tweets for 5 minutes
				setTweetCache(cacheKey, local.tweets, 5);
			}

			return local.tweets;
		</cfscript>
	</cffunction>
	<cffunction name="debug" access="public" output="true" returntype="any">
		<cfargument name="uri" type="string" required="true"/>
		<cfscript>
			var local = structNew();
			var cacheKey = '';

			//strip any bookmarks from the url
			arguments.uri = listFirst(arguments.uri,'##');
			
			//setup cache
			cacheKey = hash(arguments.uri);
			setupCache(cacheKey);

			//use services
			local.thisSearch = getTweetSearchUrl(arguments.uri);
			local.shortened = getShortUrls(arguments.uri);
			local.tweets = makeTwitterSearchRequest(local.thisSearch).results;
			local.tweets = killImpostors(local.tweets,local.shortened);
			local.tweets = cleanup(local.tweets);

			dump(local,true);
		</cfscript>
	</cffunction>
	<cffunction name="getTweetbacksHTML" access="remote" output="false" returntype="string">
		<cfargument name="uri" type="string" required="true"/>
		<cfargument name="limit" type="numeric" required="false" default="100" hint="Number of tweets to display, recent gets priority. 0 = unlimited"/>
		<cfscript>
			var local = structNew();
			local.dsp = structNew();

			local.tweets = getTweetbacks(arguments.uri);
			local.searchUrl = replace(getTweetSearchUrl(arguments.uri), ".json", "");//instead of linking to json, link to search results page
			local.tweetCount = arrayLen(local.tweets);
			local.limit = min(arguments.limit, local.tweetcount);
			if (local.limit eq 0){local.limit=local.tweetcount;}
			
			//define header
			if (local.tweetcount eq 0){
				local.dsp.header = "<h3>No Tweetbacks</h3>";
			}else{
				local.dsp.header = "<h3>#arrayLen(local.tweets)# Tweetbacks</h3>";
				if (local.tweetcount eq 1){local.dsp.header=replace(local.dsp.header,"Tweetbacks","Tweetback");}
			}
			//define view-all link
			if (local.tweetcount lte local.limit or local.limit eq 0){
				local.dsp.allLink = "";
			}else{
				local.dsp.allLink = "Showing #local.limit# most recent - <a id='viewAllTweetbacks' href='#local.searchUrl#'>View All Tweetbacks</a>";
			}
		</cfscript>
		<!---streamlined html to be as small as possible since it very well might be returned via ajax--->
		<cfsavecontent variable="local.tweetbackHTML"><cfoutput><div id="tweetbacks">#local.dsp.header##local.dsp.allLink#<ul><cfloop from="1" to="#local.limit#" index="local.t"><li style="clear:left;"><img src="#local.tweets[local.t].profile_image_url#" align="left" vspace="2" hspace="4"/> <a href="http://twitter.com/#local.tweets[local.t].from_user#" style="background:none;"><strong>#local.tweets[local.t].from_user#</strong></a> <span class="tweetback_tweet">#local.tweets[local.t].text#</span> <span class="tweetback_timestamp"><a href="http://twitter.com/#local.tweets[local.t].from_user#/statuses/#local.tweets[local.t].id#">#local.tweets[local.t].created_at#</a></span></li></cfloop></ul></div></cfoutput></cfsavecontent>
		<cfreturn local.tweetbackHTML/>
	</cffunction>
	
	<!--- data functions --->
	<cffunction name="getShortUrls" access="private" output="false" returnType="struct">
		<cfargument name="uri" type="string" required="true"/>
		<cfscript>
			var local = StructNew();
			local.shortened = structNew();
			//cligs
			local.cligsParams = StructNew();
			local.cligsParams['appid'] = urlEncodedFormat('http://sweettweetscfc.riaforge.org'); 
			local.shortened.cligs = urlService.shrink('cligs',arguments.uri,local.cligsParams);
			if (len(trim(local.shortened.cligs)) eq 0){
				structDelete(local.shortened, "cligs");
			}
			//simple services
			local.shortened.isgd = urlService.shrink('isgd',arguments.uri);
			local.shortened.tinyurl = urlService.shrink('tinyurl', arguments.uri);
			local.shortened.hexio = urlService.shrink('hexio', arguments.uri);
			return local.shortened;
		</cfscript>
	</cffunction>
	<cffunction name="getTweetSearchUrl" access="private" output="false" returnType="string">
		<cfargument name="uri" type="string" required="true"/>
		<cfscript>
			var local = structNew();
			var cacheKey = hash(arguments.uri);
			//shortened url cache never expires
			if (urlCacheExists(cacheKey)){
				local.shortened = getUrlCache(cacheKey);
			}else{
				//get shortened versions of the url
				local.shortened = getShortUrls(arguments.uri);
				//and cache the result
				setUrlCache(cacheKey, local.shortened);
			}

			//compile twitter search url
			local.api = 'http://search.twitter.com/search.json?rpp=100&q=&ors=';
			local.thisSearch = local.api
				& urlEncodedFormat(local.shortened.isgd) & '+' 
				& urlEncodedFormat(local.shortened.cligs) & '+' 
				& urlEncodedFormat(local.shortened.tinyurl) & '+' 
				& urlEncodedFormat(local.shortened.hexio);
			
			return local.thisSearch;
		</cfscript>
	</cffunction>
	<cffunction name="makeTwitterSearchRequest" access="private" output="false" returnType="any">
		<cfargument name="req" type="String" required="true"/>
		<cfset var result = ""/>
		<cfhttp url="#arguments.req#" method="get" result="result" useragent="SweetTweets plugin v0.0 for Mango Blog|http://fusiongrokker.com"></cfhttp>
		<cftry>
			<cfset result = jsonService.deserialize(result.fileContent.toString())/>
			<cfcatch type="any"><!--- catch errors thrown by jsonService (likely problem w/twitter search - down,etc), return empty set --->
				<cfset result = StructNew()/>
				<cfset result.results = arrayNew(1)/> 
			</cfcatch>
		</cftry>
		<cfreturn result />
	</cffunction>
	<cffunction name="cleanup" access="private" output="false" returnType="array">
		<cfargument name="tweets" type="array" required="true"/>
		<cfscript>
			var local = structNew();
			var i = 0;
			local.linkRegex = "((https?|s?ftp|ssh)\:\/\/[^""\s\<\>]*[^.,;'"">\:\s\<\>\)\]\!])";
			local.atRegex = "@([_a-z0-9]+)";
			local.hashRegex = "##([_a-z0-9]+)";
			for (i=1;i lte arrayLen(arguments.tweets);i=i+1){
				//fix links
				arguments.tweets[i].text = REReplaceNoCase(arguments.tweets[i].text,local.linkRegex,"<a href='\1'>\1</a>","all");
				arguments.tweets[i].text = REReplaceNoCase(arguments.tweets[i].text,local.atRegex,"<a href='http://twitter.com/\1'>@\1</a>","all");
				arguments.tweets[i].text = REReplaceNoCase(arguments.tweets[i].text,local.hashRegex,"<a href='http://www.hashtags.org/tag/\1'>##\1</a>");
				//remove ugly stuff from timestamp
				arguments.tweets[i].created_at = Replace(arguments.tweets[i].created_at, "+0000", "");
			}
			return arguments.tweets; 
		</cfscript>
	</cffunction>
	<cffunction name="killImpostors" access="private" output="false" returnType="array">
		<cfargument name="data" required="true" type="array"/>
		<cfargument name="shorties" required="true" type="struct"/>
		<cfscript>
			//this function removes false positives returned because search is case-INsensitive, but shortened url's are case-sensitive
			var i = 0;
			var j = 0;
			var keyNames = structKeyList(shorties);
			var impostor = true;
			for (i=1;i lte arrayLen(data);i=i+1){
				impostor = true;
				for (j=1;j lte listLen(keyNames);j=j+1){
					if (find(shorties[listGetAt(keyNames,j)],data[i].text)){
						impostor = false;
						break;
					}
				}
				if (impostor){
					arrayDeleteAt(data,i);
					i=i-1;
				}
			}
			return data;
		</cfscript>
	</cffunction>

	<!--- caching functions --->
	<cffunction name="setupCache" access="private" output="false" returnType="void">
		<cfargument name="cacheKey" type="string" required="true" />
		<cfscript>
			if (variables.cacheLocation eq "application"){
				if (not structKeyExists(application, "SweetTweetCache")){application.SweetTweetCache=StructNew();}
				if (not structKeyExists(application.sweetTweetCache, "urls")){application.sweetTweetCache.urls=StructNew();}
				if (not structKeyExists(application.sweetTweetCache, "tweetbacks")){application.sweetTweetCache.tweetbacks=StructNew();}
				if (not structKeyExists(application.sweetTweetCache.tweetbacks, arguments.cacheKey)){application.sweetTweetCache.tweetbacks[arguments.cacheKey]=StructNew();}
			}else{
				if (not structKeyExists(variables, "SweetTweetCache")){variables.SweetTweetCache=StructNew();}
				if (not structKeyExists(variables.sweetTweetCache, "urls")){variables.sweetTweetCache.urls=StructNew();}
				if (not structKeyExists(variables.sweetTweetCache, "tweetbacks")){variables.sweetTweetCache.tweetbacks=StructNew();}
				if (not structKeyExists(variables.sweetTweetCache.tweetbacks, arguments.cacheKey)){variables.sweetTweetCache.tweetbacks[arguments.cacheKey]=StructNew();}
			}
		</cfscript>
	</cffunction>
	<cffunction name="tweetCacheExpired" access="private" output="false" returnType="boolean">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				return (not structKeyExists(application.sweetTweetCache.tweetbacks[arguments.cacheKey], "timeout") or
						dateCompare(now(), application.sweetTweetCache.tweetbacks[arguments.cacheKey].timeout) eq 1);
			}else{
				return (not structKeyExists(variables.sweetTweetCache.tweetbacks[arguments.cacheKey], "timeout") or
						dateCompare(now(), variables.sweetTweetCache.tweetbacks[arguments.cacheKey].timeout) eq 1);
			}
		</cfscript>
	</cffunction>
	<cffunction name="getTweetCache" access="private" output="false" returnType="array">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				return application.sweetTweetCache.tweetbacks[arguments.cacheKey].tweets;
			}else{
//dump(variables.sweetTweetCache,true);
				return variables.sweetTweetCache.tweetbacks[arguments.cacheKey].tweets;
			}
		</cfscript>
	</cffunction>
	<cffunction name="setTweetCache" access="private" output="false" returnType="void">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfargument name="data" type="array" required="true"/>
		<cfargument name="timeout" type="any" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				application.sweetTweetCache.tweetbacks[arguments.cacheKey].tweets = arguments.data;
				application.sweetTweetCache.tweetbacks[arguments.cacheKey].timeout = dateAdd("n",arguments.timeout,now());
			}else{
				variables.sweetTweetCache.tweetbacks[arguments.cacheKey].tweets = arguments.data;
				variables.sweetTweetCache.tweetbacks[arguments.cacheKey].timeout = dateAdd("n",arguments.timeout,now());
			}
		</cfscript>
	</cffunction>
	<cffunction name="urlCacheExists" access="private" output="false" returnType="boolean">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				return (structKeyExists(application.SweetTweetCache.urls, arguments.cacheKey));
			}else{
				return (structKeyExists(variables.SweetTweetCache.urls, arguments.cacheKey));
			}
		</cfscript>
	</cffunction>
	<cffunction name="getUrlCache" access="private" output="false" returnType="struct">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				return application.sweetTweetCache.urls[arguments.cacheKey];
			}else{
				return variables.sweetTweetCache.urls[arguments.cacheKey];
			}
		</cfscript>
	</cffunction>
	<cffunction name="setUrlCache" access="private" output="false" returnType="void">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfargument name="data" type="struct" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				application.sweetTweetCache.urls[arguments.cacheKey] = arguments.data;
			}else{
				variables.sweetTweetCache.urls[arguments.cacheKey] = arguments.data;
			}
		</cfscript>
	</cffunction>

	<cffunction name="dump" access="private" output="false">
		<cfargument name="var" required="true"/>
		<cfargument name="abort" default="false"/>
		<cfdump var="#arguments.var#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
	</cffunction>
	
</cfcomponent>