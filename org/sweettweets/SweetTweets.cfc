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

This file is part of SweetTweets.
http://sweettweets.riaforge.org/
--->
<cfcomponent output="false">

	<cfproperty name="cacheLocation" type="string"
	hint="Defines whether the cache should be kept in the application scope, or internally to this component. Default is internal. If using internal, you should persist this object in the application or server scopes." />

	<cfset variables.jsonService = ""/>
	<cfset variables.cacheLocation = "application"/>
	<cfset variables.config.header.empty = "<h3>No Tweetbacks</h3" />
	<cfset variables.config.header.notEmpty = "<h3>{count} Tweetbacks</h3" />

	<cffunction name="init" output="false"
	hint="Constructor - specify whether the cache should be stored locally inside this component, or in the application scope.">
		<cfargument name="useLocalCache" type="boolean" default="true" hint="true: cache is stored inside this component, you must persist the cfc instance in application/etc scope. false: cache stored in application scope."/>
		<cfargument name="headerEmpty" type="string" default="<h3>No Tweetbacks</h3>" />
		<cfargument name="headerNonEmpty" type="string" default="<h3>{count} Tweetbacks</h3>" />
		<!--- save cache location --->
		<cfif arguments.useLocalCache>
			<cfset variables.cacheLocation = "variables"/>
		<cfelse>
			<cfset variables.cacheLocation = "application" />
		</cfif>
		<!--- Using JSONUtil from Nathan Mische: http://jsonutil.riaforge.org/ --->
		<cfset variables.jsonService = createObject("component","JSONUtil").init()/>

		<!--- set header templates --->
		<cfset variables.config.header.empty = "#arguments.headerEmpty#" />
		<cfset variables.config.header.notEmpty = "#arguments.headerNonEmpty#" />

		<cfreturn this/>
	</cffunction>

	<!--- main functions --->
	<cffunction name="getTweetbacks" access="public" output="false" returntype="array"
	hint="Returns high-fidelity data for the requested tweetbacks. You will receive an array of structures, each structure representing 1 tweet that contains a shortened version of the supplied URI. If there are no matches, the array will be empty. Structure keys are: <ul><li><strong>created_at</strong> - timestamp of tweet</li><li><strong>from_user</strong> - twitter username that posted the tweet</li><li><strong>from_user_id</strong> - twitter unique userId of tweet poster</li><li><strong>id</strong> - tweet unique id</li><li><strong>iso_language_code</strong> - language indicator</li><li><strong>profile_image_url</strong> - url to avatar of tweet poster</li><li><strong>source</strong> - twitter client or other source of tweet</li><li><strong>text</strong> - raw text of tweet</li><li><strong>to_user_id</strong> - userId of person being replied to, 'null' (string) if not applicable</ul>">
		<cfargument name="uri" type="string" required="true"/>
		<cfscript>
			var local = structNew();
			var cacheKey = '';

			//first some business -- if being called remotely (ajax), jsonService will be blank! :(
			if (isSimpleValue(variables.jsonService)){variables.jsonService = createObject("component", "JSONUtil").init();}

			//setup cache
			cacheKey = getCacheKey(arguments.uri);
			setupCache(cacheKey);

			//check tweetback cache, updates every 5 minutes at most
			if (not tweetCacheExpired(cacheKey)){
				local.tweets = getTweetCache(cacheKey);
			}else{
				local.thisSearch = getTweetSearchUrl(arguments.uri);

				try{
					local.searchResult = makeTwitterSearchRequest(local.thisSearch);
					local.tweets = local.searchResult.results;
				} catch(any e) {
					local.tweets = arrayNew(1);
				}
				local.tweets = markup(local.tweets);

				//cache tweets for 5 minutes
				setTweetCache(cacheKey, local.tweets, 5);
			}
			return local.tweets;
		</cfscript>
	</cffunction>
	<cffunction name="getTweetbacksHTML" access="remote" output="false" returntype="string"
	hint="Returns the same data as getTweetbacks, only pre-formatted as HTML. See examples for what the HTML will look like, and you can apply your own CSS.">
		<cfargument name="uri" type="string" required="true"/>
		<cfargument name="limit" type="numeric" required="false" default="50" hint="Number of tweets to display, recent gets priority. Max 50."/>
		<cfargument name="headerEmpty" type="string" default="<h3>No Tweetbacks</h3>" />
		<cfargument name="headerNonEmpty" type="string" default="<h3>{count} Tweetbacks</h3>" />
		<cfscript>
			var local = structNew();
			local.dsp = structNew();

			local.tweets = getTweetbacks(arguments.uri);
			local.tweetCount = arrayLen(local.tweets);
			local.limit = min(arguments.limit, local.tweetcount);
			if (local.limit eq 0){local.limit=local.tweetcount;}

			//set header templates
			variables.config.header.empty = "#arguments.headerEmpty#";
			variables.config.header.notEmpty = "#arguments.headerNonEmpty#";

			//define header
			if (local.tweetcount eq 0){
				local.dsp.header = "#variables.config.header.empty#";
			}else{
				local.dsp.header = "#replaceNoCase(variables.config.header.notEmpty, "{count}", local.tweetCount, "all")#";
				if (local.tweetcount eq 1){local.dsp.header=replace(local.dsp.header,"Tweetbacks","Tweetback");}
			}
		</cfscript>
		<!---streamlined html to be as small as possible since it very well might be returned via ajax--->
		<cfsavecontent variable="local.tweetbackHTML"><cfoutput><div id="tweetbacks">#local.dsp.header#<ul><cfloop from="1" to="#local.limit#" index="local.t"><li style="clear:left;"><img src="#local.tweets[local.t].author.photo_url#" align="left" vspace="2" hspace="4"/> <a href="#local.tweets[local.t].author.url#" style="background:none;"><strong>#local.tweets[local.t].author.name#</strong></a> <span class="tweetback_tweet">#local.tweets[local.t].content#</span> <span class="tweetback_timestamp"><a href="#local.tweets[local.t].permalink_url#">#local.tweets[local.t].date_alpha#</a></span></li></cfloop></ul></div></cfoutput></cfsavecontent>
		<cfreturn local.tweetbackHTML/>
	</cffunction>

	<!--- data/lookup functions --->
	<cffunction name="getTweetSearchUrl" access="private" output="false" returnType="string">
		<cfargument name="uri" type="string" required="true"/>
		<cfreturn 'http://otter.topsy.com/trackbacks.json?perpage=50&url=#arguments.uri#' />
	</cffunction>
	<cffunction name="makeTwitterSearchRequest" access="private" output="false" returnType="any">
		<cfargument name="req" type="String" required="true"/>
		<cfset var result = StructNew() />
		<cfset var apiResult = '' />
		<cftry>
			<cfhttp url="#arguments.req#" timeout="10" method="get" result="apiResult" useragent="SweetTweetsCFC | http://SweetTweetsCFC.riaforge.org"></cfhttp>
			<cfif apiResult.statuscode contains "408">
				<cfthrow message="request timed out" detail="acting as if results were empty" errorcode="408" />
			<cfelse>
				<cfset result.results = jsonService.deserializeCustom(apiResult.fileContent.toString())/>
				<cfset result.totalCount = result.results.response.total />
				<cfset result.results = result.results.response.list />
			</cfif>
			<cfcatch type="any"><!--- catch errors thrown by jsonService (likely problem w/twitter search - down,etc), return empty set --->
				<cfset result.results = arrayNew(1)/>
			</cfcatch>
		</cftry>
		<cfreturn result />
	</cffunction>
	<cffunction name="markup" access="private" output="false" returnType="array">
		<cfargument name="tweets" type="array" required="true"/>
		<cfscript>
			var local = structNew();
			var i = 0;
			local.linkRegex = "((https?|s?ftp|ssh)\:\/\/[^""\s\<\>]*[^.,;'"">\:\s\<\>\)\]\!])";
			local.atRegex = "@([_a-zA-Z0-9]+)";
			local.hashRegex = "##([_a-zA-Z0-9]+)";
			for (i=1;i lte arrayLen(arguments.tweets);i=i+1){
				//fix links
				arguments.tweets[i].content = REReplaceNoCase(arguments.tweets[i].content,local.linkRegex,"<a href='\1'>\1</a>","all");
				arguments.tweets[i].content = REReplaceNoCase(arguments.tweets[i].content,local.atRegex,"<a href='http://twitter.com/\1'>@\1</a>","all");
				arguments.tweets[i].content = REReplaceNoCase(arguments.tweets[i].content,local.hashRegex,"<a href='http://search.twitter.com/search?q=\1'>##\1</a>","all");
			}
			return arguments.tweets;
		</cfscript>
	</cffunction>

	<!--- caching functions --->
	<cffunction name="cacheKablooey" access="public" output="false" returntype="void"
	hint="Blows away the entire cache. Kablooey!">
		<cfscript>
			if (variables.cacheLocation eq "application"){
				structDelete(application, "sweetTweetCache");
			}else{
				structDelete(variables, "sweetTweetCache");
			}
		</cfscript>
	</cffunction>
	<cffunction name="setupCache" access="private" output="false" returnType="void">
		<cfargument name="cacheKey" type="string" required="true" />
		<cfscript>
			if (variables.cacheLocation eq "application"){
				if (not structKeyExists(application, "SweetTweetCache")){application.SweetTweetCache=StructNew();}
				if (not structKeyExists(application.sweetTweetCache, arguments.cacheKey)){application.sweetTweetCache[arguments.cacheKey]=StructNew();}
			}else{
				if (not structKeyExists(variables, "SweetTweetCache")){variables.SweetTweetCache=StructNew();}
				if (not structKeyExists(variables.sweetTweetCache, arguments.cacheKey)){variables.sweetTweetCache[arguments.cacheKey]=StructNew();}
			}
		</cfscript>
	</cffunction>
	<cffunction name="tweetCacheExpired" access="private" output="false" returnType="boolean">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				return (not structKeyExists(application.sweetTweetCache[arguments.cacheKey], "timeout") or
						dateCompare(now(), application.sweetTweetCache[arguments.cacheKey].timeout) eq 1);
			}else{
				return (not structKeyExists(variables.sweetTweetCache[arguments.cacheKey], "timeout") or
						dateCompare(now(), variables.sweetTweetCache[arguments.cacheKey].timeout) eq 1);
			}
		</cfscript>
	</cffunction>
	<cffunction name="clearTweetCacheByURI" access="public" output="false" returntype="void"
	hint="Clears the tweetback cache for the supplied URI">
		<cfargument name="uri" type="string" required="true" />
		<cfscript>
			var cacheKey = getCacheKey(arguments.uri);
			if (variables.cacheLocation eq "application"){
				structDelete(application.sweetTweetCache.tweetbacks, cacheKey);
			}else{
				structDelete(variables.sweetTweetCache.tweetbacks, cacheKey);
			}
		</cfscript>
	</cffunction>
	<cffunction name="getCacheKey" access="public" output="false" returntype="String"
	hint="Converts a URL into a <strong>cacheKey</strong> (string) - a safe string representation (hash) of the uri, used by some caching functions.">
		<cfargument name="uri" type="string" required="true" />
		<cfscript>
			//strip any bookmarks from the url before hashing
			arguments.uri = listFirst(arguments.uri,'##');
			return hash(arguments.uri);
		</cfscript>
	</cffunction>
	<cffunction name="getTweetCache" access="private" output="false" returnType="array">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				return application.sweetTweetCache[arguments.cacheKey].tweets;
			}else{
				return variables.sweetTweetCache[arguments.cacheKey].tweets;
			}
		</cfscript>
	</cffunction>
	<cffunction name="setTweetCache" access="private" output="false" returnType="void">
		<cfargument name="cacheKey" type="string" required="true"/>
		<cfargument name="data" type="array" required="true"/>
		<cfargument name="timeout" type="any" required="true"/>
		<cfscript>
			if (variables.cacheLocation eq "application"){
				application.sweetTweetCache[arguments.cacheKey].tweets = arguments.data;
				application.sweetTweetCache[arguments.cacheKey].timeout = dateAdd("n",arguments.timeout,now());
			}else{
				variables.sweetTweetCache[arguments.cacheKey].tweets = arguments.data;
				variables.sweetTweetCache[arguments.cacheKey].timeout = dateAdd("n",arguments.timeout,now());
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