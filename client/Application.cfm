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

	<!--- Finally, do a DSN check --->
	<!--- We end up throwing away this call, but it should be lightweight --->
	<cfset foo = application.blog.getNameForUser(createUUID())>
		
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

<cfif structKeyExists(url, "nomobile")>
	<cfset session.nomobile = true>
</cfif>

<cfif not structKeyExists(session, "nomobile") and not findNoCase("blackberry",cgi.http_user_agent) 
and 
(reFindNoCase("android|avantgo|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0)>
	<cfset urlVars=reReplaceNoCase(trim(cgi.path_info), '.+\.cfm/? *', '')>
	<cfif listlen(urlVars, '/') LTE 1> <!---NOT AN SES URL--->
		<cfset urlVars = ''>
	</cfif>	
	<cfset path = cgi.http_host & ListDeleteAt(cgi.script_name, listLen(cgi.script_name, "/"), "/")>
	<cfif NOT right(path, 6) EQ "mobile">
		<cflocation url="http://#path#/mobile/index.cfm#urlVars#" addToken="false">
	</cfif>
</cfif>

<cfsetting enablecfoutputonly="false">

