<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : slideshow.cfm
	Author       : Raymond Camden 
	Created      : August 18, 2006
	Last Updated : December 14, 2006
	History      : Added metadata support (rkc 9/5/06)
				 : Support for getting slide show dir from CFC (rkc 12/14/06)
	Purpose		 : Slide Show
--->

<cfset slideshowdir = listLast(cgi.path_info, "/")>

<cfif not len(slideshowdir)>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfset directory = application.slideshow.getSlideShowDir() & "/" & slideshowDir>

<cfif not directoryExists(directory)>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfset metadata = application.slideshow.getInfo(directory)>
<cfset images = application.slideshow.getImages(directory)>

<cfif not images.recordCount>
	<cflocation url="#application.rooturl#/index.cfm" addToken="false">
</cfif>

<cfparam name="url.slide" default="1">

<cfif not isNumeric(url.slide) or url.slide lte 0 or url.slide gt images.recordCount or round(url.slide) neq url.slide>
	<cfset url.slide = 1>
</cfif>

<cfif len(metadata.formalname)>
	<cfset title = "Slideshow - #metadata.formalname#">
<cfelse>
	<cfset title = "Slideshow">
</cfif>

<cfmodule template="tags/layout.cfm" title="#title#">

	<cfoutput>
	<div class="date"><b>#title# - Picture #url.slide# of #images.recordCount#</b></div>
	<div class="body">
	<p align="center">
	<img src="#application.rooturl#/images/slideshows/#application.imageroot#/#slideshowdir#/#images.name[url.slide]#" /><br />
	<cfif structKeyExists(metadata.images, images.name[url.slide])>
	<b>#metadata.images[images.name[url.slide]]#</b><br />
	</cfif>
	<cfif url.slide gt 1>
	<a href="#application.rooturl#/slideshow.cfm/#slideshowdir#?slide=#decrementValue(url.slide)#">Previous</a>
	<cfelse>
	Previous
	</cfif> 
	~ 
	<cfif url.slide lt images.recordCount>
	<a href="#application.rooturl#/slideshow.cfm/#slideshowdir#?slide=#incrementValue(url.slide)#">Next</a>
	<cfelse>
	Next
	</cfif> 
	
	</p>
	</div>
	</cfoutput>

</cfmodule>