<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<!---
	Name         : Application.cfm
	Author       : Raymond Camden
	Created      : Some time ago
	Last Updated : April 13, 2007
	History      : Reset history for version 5.7
				 : Added comments, and Scott P's pod manager cfc (rkc 4/13/07)
	Purpose		 : Blog application page
--->

<cfset setEncoding("form","utf-8")>
<cfset setEncoding("url","utf-8")>

<!--- Edit this line if you are not using a default blog --->
<cfset blogname = "Default">

<!---
The prefix is now dynamic in case 2 people want to run blog.cfc on the same machine. Normally they
	  would run both blogs with the same org, and use different names, but on an ISP that may not be possible.
	  So I base part of the application name on the file path.

	Name can only be 64 max. So we will take right most part.
--->
<cfset prefix = hash(getCurrentTemplatePath())>
<cfset prefix = reReplace(prefix, "[^a-zA-Z]","","all")>
<cfset prefix = right(prefix, 64 - len("_blog_#blogname#"))>
<cfapplication name="#prefix#_blog_#blogname#" sessionManagement="true" loginStorage="session">

<!--- Our exception template. --->
<cferror type="exception" template="error.cfm">

<cfinclude template="includes/udf.cfm">

<!--- By default we cache a lot of information. Allow reinit=1 in the URL to restart cache. --->
<cfif not isDefined("application.init") or isDefined("url.reinit")>

	<!--- load and init blog --->
	<cfset application.blog = createObject("component","org.camden.blog.blog").init(blogname)>

	<!--- Do we need to run the installer? --->
	<cfif application.blog.getProperty("installed") is 0>
		<cflocation url="./installer/index.cfm?blog=#urlEncodedFormat(blogname)#" addToken="false">
	</cfif>

	<!--- Root folder for uploaded images, used under images folder --->
	<cfset application.imageroot = application.blog.getProperty("imageroot")>

	<!--- locale related --->
	<cfset application.resourceBundle = createObject("component","org.hastings.locale.resourcebundle")>

	<!--- Path may be different if admin. --->

	<cfset currentPath = getDirectoryFromPath(getCurrentTemplatePath()) />
	<cfset theFile = currentPath & "includes/main" />
	<cfset lylaFile = getRelativePath(currentPath & "includes/captcha.xml") />
	<cfset slideshowdir = currentPath & "images/slideshows/" & application.imageroot />

	<cfset application.resourceBundle.loadResourceBundle(theFile, application.blog.getProperty("locale"))>
	<cfset application.resourceBundleData = application.resourceBundle.getResourceBundleData()>
	<cfset application.localeutils = createObject("component","org.hastings.locale.utils")>
	<cfset application.localeutils.loadLocale(application.blog.getProperty("locale"))>

	<!--- load slideshow --->
	<cfset application.slideshow = createObject("component", "org.camden.blog.slideshow").init(slideshowdir)>

	<!--- Use Captcha? --->
	<cfset application.usecaptcha = application.blog.getProperty("usecaptcha")>

	<!--- Use CFFORMProtect? --->
	<cfset application.usecfp = application.blog.getProperty("usecfp")>

	<cfif application.usecaptcha>
		<cfset application.captcha = createObject("component","org.captcha.captchaService").init(configFile="#lylaFile#") />
		<cfset application.captcha.setup() />
	</cfif>

	<!--- load coldfish --->
	<cfset coldfish = createObject("component", "org.delmore.coldfish").init()>
	<!--- inject it --->
	<cfset application.blog.setCodeRenderer(coldfish)>

	<!--- use tweetbacks? --->
	<cfset application.usetweetbacks = application.blog.getProperty("usetweetbacks")>
	<cfif not isBoolean(application.usetweetbacks)>
		<cfset application.usetweetbacks = false>
	</cfif>
	<cfif application.usetweetbacks>
		<cfset application.sweetTweets = createObject("component","org.sweettweets.SweetTweets").init()/>
	</cfif>
	
	<!--- clear scopecache --->
	<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">

	<cfset majorVersion = listFirst(server.coldfusion.productversion)>
	<cfset minorVersion = listGetAt(server.coldfusion.productversion,2,",.")>
	<cfset cfversion = majorVersion & "." & minorVersion>

	<cfset application.isColdFusionMX7 = server.coldfusion.productname is "ColdFusion Server" and cfversion gte 7>

	<!--- Used in various places --->
	<cfset application.rootURL = application.blog.getProperty("blogURL")>
	<!--- per documentation - rooturl should be http://www.foo.com/something/something/index.cfm --->
	<cfset application.rootURL = reReplace(application.rootURL, "(.*)/index.cfm", "\1")>

	<!--- used for cache purposes is 60 minutes --->
	<cfset application.timeout = 60*60>

	<!--- how many entries? --->
	<cfset application.maxEntries = application.blog.getProperty("maxentries")>

	<!--- TBs allowed? --->
	<cfset application.trackbacksAllowed = application.blog.getProperty("allowtrackbacks")>

	<!--- Gravatars allowed? --->
	<cfset application.gravatarsAllowed = application.blog.getProperty("allowgravatars")>

	<!--- Load the Utils CFC --->
	<cfset application.utils = createObject("component", "org.camden.blog.utils")>

	<!--- Load the Page CFC --->
	<cfset application.page = createObject("component", "org.camden.blog.page").init(dsn=application.blog.getProperty("dsn"), username=application.blog.getProperty("username"), password=application.blog.getProperty("password"),blog=blogname)>

	<!--- Load the TB CFC --->
	<cfset application.textblock = createObject("component", "org.camden.blog.textblock").init(dsn=application.blog.getProperty("dsn"), username=application.blog.getProperty("username"), password=application.blog.getProperty("password"),blog=blogname)>

	<!--- Do we have comment moderation? --->
	<cfset application.commentmoderation = application.blog.getProperty("moderate")>

	<!--- Do we allow file browsing in the admin? --->
	<cfset application.filebrowse = application.blog.getProperty("filebrowse")>

	<!--- Do we allow settings in the admin? --->
	<cfset application.settings = application.blog.getProperty("settings")>

	<!--- load pod --->
	<cfset application.pod = createObject("component", "org.camden.blog.pods")>

	<!--- We are initialized --->
	<cfset application.init = true>

</cfif>

<!--- Let's make a pointer to our RB --->
<!---
Attention:
Normally, I'd say "rb" as a variable name is sucky. It is too short
and not clear. However, I'm using it as a localization service, and I'm DARN tired
of typing the same crap over and over again.

In case you are curious, the line below makes a pointer to the struct.
Also note I didn't use Variables. Again, I'm tired of the typing.
--->
<cfset rb = application.utils.getResource>

<!--- Used to remember the pages we have viewed. Helps keep view count down. --->
<cfif not structKeyExists(session,"viewedpages")>
	<cfset session.viewedpages = structNew()>
</cfif>

<!--- KillSwitch for comments. We don't authenticate because this kill uuid is something only the admin can get. --->
<cfif structKeyExists(url, "killcomment")>
	<cfset application.blog.killComment(url.killcomment)>
</cfif>
<!--- Quick approval for comments --->
<cfif structKeyExists(url, "approvecomment")>
	<cfset application.blog.approveComment(url.approvecomment)>
</cfif>


<cfsetting enablecfoutputonly="false">

