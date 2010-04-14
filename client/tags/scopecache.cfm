<!---
	Name         : scopeCache
	Author       : Raymond Camden (jedimaster@mindseye.com)
	Created      : December 12, 2002
	Last Updated : August 21, 2008
	History      : Allow for clearAll (rkc 11/6/03)
				 : Added dependancies, timeout, other misc changes (rkc 1/8/04)
				 : Found bug where if you called it with clear and used />, the cache was screwed up (rkc 2/15/05)
				 : Typos in msg for bad timeout (rkc 2/15/05)
				 : Added locking to scopeCache subkey creation (rkc 2/15/05)
				 : Added r_cacheItems (rkc 2/15/05)
				 : Moved logic around to make it simpler (rkc 2/15/05)
				 : Dependencies fix, and support Request scope (rkc 2/27/08)
				 : Support for file based caching (rkc 8/21/08)
	Purpose		 : Allows you to cache content in various scopes.
	Documentation:
	
	This tag allows you to cache content and data in various RAM based scopes. 
	The tag takes the following attributes:

	name/cachename:	The name of the data. (required)
	scope: 			The scope where cached data will reside. Must be either session, 
					application, server, request, or file. (required)
	timeout: 		When the cache will timeout. By default, the year 3999 (i.e., never). 
					Value must be either a date/time stamp or a number representing the
					number of seconds until the timeout is reached. (optional)
	dependancies:	This allows you to mark other cache items as dependant on this item. 
					When this item is cleared or timesout, any child will also be cleared.
					Also, any children of those children will also be cleared. (optional)
	clear:			If passed and if true, will clear out the cached item. Note that
					this option will NOT recreate the cache. In other words, the rest of
					the tag isn't run (well, mostly, but don't worry).
	clearAll:		Removes all data from this scope. Exits the tag immidiately.
	disabled:		Allows for a quick exit out of the tag. How would this be used? You can 
					imagine using disabled="#request.disabled#" to allow for a quick way to
					turn on/off caching for the entire site. Of course, all calls to the tag
					would have to use the same value.
	r_cacheItems:	Returns a list of keys in the cache. Exists the tag when called. NOTICE! Some items
					may be expired. Items only get removed if you are fetching them or calling CLEAR on them.
	r_data:			Returns the value directly.
	data:			Sets the value directly.
	file:			Fully qualified file name for file based caching.
	suppressHitCount: Only used for file operations - if passed, we don't bother updating the file based cache with the hit count. Makes the file IO a bit less.

	License		 : Use this as you will. If you enjoy it and it helps your application, 
				   consider sending me something from my Amazon wish list:
				   http://www.amazon.com/o/registry/2TCL1D08EZEYE
--->

<!--- allow for quick exit --->
<cfif isDefined("attributes.disabled") and attributes.disabled>
	<cfexit method="exitTemplate">
</cfif>

<!--- Allow for cachename in case we use cfmodule --->
<cfif isDefined("attributes.cachename")>
	<cfset attributes.name = attributes.cachename>
</cfif>

<!--- Must pass scope, and must be a valid value. --->
<cfif not isDefined("attributes.scope") or not isSimpleValue(attributes.scope) or not listFindNoCase("application,session,server,request,file",attributes.scope)>
	<cfthrow message="scopeCache: The scope attribute must be passed as one of: application, session, server, request, or file.">
</cfif>

<cfparam name="attributes.file" default="">

<!--- create pointer to scope --->
<cfif attributes.scope is not "file">
	<cfset ptr = structGet(attributes.scope)>
	
	<!--- init cache root --->
	<cflock scope="#attributes.scope#" type="readOnly" timeout="30">
		<cfif not structKeyExists(ptr,"scopeCache")>
			<cfset needInit = true>
		<cfelse>
			<cfset needInit = false>
		</cfif>
	</cflock>
	
	<cfif needInit>
		<cflock scope="#attributes.scope#" type="exclusive" timeout="30">
			<!--- check twice in cace another thread finished --->
			<cfif not structKeyExists(ptr,"scopeCache")>
				<cfset ptr["scopeCache"] = structNew()>
			</cfif>
		</cflock>
	</cfif>
	
</cfif>

<!--- Do they simply want the keys? --->
<cfif isDefined("attributes.r_cacheItems") and attributes.scope neq "file">
	<cfset caller[attributes.r_cacheItems] = structKeyList(ptr.scopeCache)>
	<cfexit method="exitTag">
</cfif>

<!--- Do they want to nuke it all? --->
<cfif isDefined("attributes.clearAll") and attributes.scope neq "file">
	<cfset structClear(ptr["scopeCache"])>
	<cfexit method="exitTag">
</cfif>

<!--- Require name if we get this far. --->
<cfif not isDefined("attributes.name") or not isSimpleValue(attributes.name)>
	<cfthrow message="scopeCache: The name attribute must be passed as a string.">
</cfif>

<!--- The default timeout is no timeout, so we use the year 3999. We will have flying cars then. --->
<cfparam name="attributes.timeout" default="#createDate(3999,1,1)#">
<!--- Default dependancy list --->
<cfparam name="attributes.dependancies" default="" type="string">

<cfif not isDate(attributes.timeout) and (not isNumeric(attributes.timeout) or attributes.timeout lte 0)>
	<cfthrow message="scopeCache: The timeout attribute must be either a date/time or a number greater than zero.">
<cfelseif isNumeric(attributes.timeout)>
	<!--- convert seconds to a time --->
	<cfset attributes.timeout = dateAdd("s",attributes.timeout,now())>
</cfif>


<!--- This variable will store all the guys we need to update --->
<cfset cleanup = "">
<!--- This variable determines if we run the caching. This is used when we clear a cache --->
<cfset dontRun = false>

<cfif isDefined("attributes.clear") and attributes.clear and thisTag.executionMode is "start">
	<cfif attributes.scope neq "file" and structKeyExists(ptr.scopeCache,attributes.name)>
		<cfset cleanup = ptr.scopeCache[attributes.name].dependancies>
		<cfset structDelete(ptr.scopeCache,attributes.name)>
	<cfelseif fileExists(attributes.file)>
		<cffile action="delete" file="#attributes.file#">
	</cfif>
	<cfset dontRun = true>
</cfif>

<cfif not dontRun>
	<cfif thisTag.executionMode is "start">
		<!--- determine if we have the info in cache already --->
		<cfif attributes.scope neq "file" and structKeyExists(ptr.scopeCache,attributes.name)>
			<cfif dateCompare(now(),ptr.scopeCache[attributes.name].timeout) is -1>
				<cflock scope="#attributes.scope#" type="exclusive" timeout="30">
					<cfset ptr.scopeCache[attributes.name].hitCount = ptr.scopeCache[attributes.name].hitCount + 1>
				</cflock>			
				<cfif not isDefined("attributes.r_Data")>
					<cfoutput>#ptr.scopeCache[attributes.name].value#</cfoutput>
				<cfelse>
					<cfset caller[attributes.r_Data] = ptr.scopeCache[attributes.name].value>
				</cfif>
				<cfexit method="exitTag">
			</cfif>
		<!--- Fix by Ken Gladden --->	
		<cfelseif (attributes.file is not "") and fileExists(attributes.file)>
			<!--- read the file in to check metadata --->
			<cflock name="#attributes.file#" type="readonly" timeout="30">			
				<cffile action="read" file="#attributes.file#" variable="contents" charset="UTF-8">
				<cfwddx action="wddx2cfml" input="#contents#" output="data">
			</cflock>
			<cfif dateCompare(now(),data.timeout) is -1>
				<cfif not isDefined("attributes.r_Data")>
					<cfoutput>#data.value#</cfoutput>
				<cfelse>
					<cfset caller[attributes.r_Data] = data.value>
				</cfif>
				<cfif not structKeyExists(attributes, "suppressHitCount")>
					<cflock name="#attributes.file#" type="exclusive" timeout="30">
						<cfset data.hitCount = data.hitCount + 1>
						<cfwddx action="cfml2wddx" input="#data#" output="packet">
						<cffile action="write" file="#attributes.file#" output="#packet#" charset="UTF-8">		
					</cflock>
				</cfif>
				<cfexit method="exitTag">						
			</cfif>
		</cfif>
	<cfelse>
		<!--- It is possible I'm here because I'm refreshing. If so, check my dependancies --->
		<cfif attributes.scope neq "file" and structKeyExists(ptr.scopeCache,attributes.name)>
			<cfif structKeyExists(ptr.scopeCache[attributes.name],"dependancies")>
				<cfset cleanup = listAppend(cleanup, ptr.scopeCache[attributes.name].dependancies)>
			</cfif>
		</cfif>
		<cfif attributes.scope neq "file">
			<cfset ptr.scopeCache[attributes.name] = structNew()>
			<cfif not isDefined("attributes.data")>
				<cfset ptr.scopeCache[attributes.name].value = thistag.generatedcontent>
			<cfelse>
				<cfset ptr.scopeCache[attributes.name].value = attributes.data>
			</cfif>
			<cfset ptr.scopeCache[attributes.name].timeout = attributes.timeout>
			<cfset ptr.scopeCache[attributes.name].dependancies = attributes.dependancies>
			<cfset ptr.scopeCache[attributes.name].hitCount = 0>
			<cfset ptr.scopeCache[attributes.name].created = now()>
			<cfif isDefined("attributes.r_Data")>
				<cfset caller[attributes.r_Data] = ptr.scopeCache[attributes.name].value>
			</cfif>
		<cfelse>
			<cfset data = structNew()>
			<cfif not isDefined("attributes.data")>
				<cfset data.value = thistag.generatedcontent>
			<cfelse>
				<cfset data.value = attributes.data>
			</cfif>
			<cfset data.timeout = attributes.timeout>
			<cfset data.dependancies = attributes.dependancies>
			<cfset data.hitCount = 0>
			<cfset data.created = now()>
			<cflock name="#attributes.file#" type="exclusive" timeout="30">
				<cfwddx action="cfml2wddx" input="#data#" output="packet">
				<cffile action="write" file="#attributes.file#" output="#packet#" charset="UTF-8">
			</cflock>
			<cfif isDefined("attributes.r_Data")>
				<cfset caller[attributes.r_Data] = data.value>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<!--- Do I need to clean up? --->
<cfloop condition="listLen(cleanup)">
	<cfset toKill = listFirst(cleanup)>
	<cfset cleanUp = listRest(cleanup)>
	<cfif structKeyExists(ptr.scopeCache, toKill)>
		<cfloop index="item" list="#ptr.scopeCache[toKill].dependancies#">
			<cfif not listFindNoCase(cleanup, item)>
				<cfset cleanup = listAppend(cleanup, item)>
			</cfif>
		</cfloop>
		<cfset structDelete(ptr.scopeCache,toKill)>
	</cfif>
</cfloop>

<cfif dontRun>
	<cfexit method="exitTag">
</cfif>
