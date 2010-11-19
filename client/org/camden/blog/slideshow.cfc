<cfcomponent output="false" displayName="Slideshow">

<cfset variables.slideshowdir = "">

<cffunction name="init" access="public" returnType="slideshow" output="false">
	<cfargument name="dir" type="string" required="true">
	
	<cfset variables.slideshowdir = arguments.dir>
	<cfreturn this>
</cffunction>

<cffunction name="getImages" access="public" returnType="query" output="false" hint="Gets gifs/jpgs">
	<cfargument name="directory" type="string" required="true">
	<cfset var images = "">
	
	<cfdirectory directory="#arguments.directory#" name="images">
	
	<cfquery name="images" dbtype="query">
	select	name
	from	images
	where	lower(name) like '%.jpg'
	or		lower(name) like '%.gif'
	</cfquery>

	<cfreturn images>
</cffunction>

<cffunction name="getInfo" access="public" returnType="struct" output="false" hint="Try to find an xml file and parse it.">
	<cfargument name="directory" type="string" required="true">
	<cfset var result = structNew()>
	<cfset var xmlFile = arguments.directory & "/metadata.xml">
	<cfset var xmlPacket = "">
	<cfset var x = "">
	<cfset var image = structNew()>
	<cfset var imageNode = "">
	
	<cfset result.name = "">
	<cfset result.formalname = "">
	<cfset result.images = structNew()>
	
	<cfif not directoryExists(arguments.directory) or not fileExists(xmlFile)>
		<cfreturn result>
	</cfif>
	
	<cfset result.name = listLast(arguments.directory, "/\")>
	
	<cffile action="read" file="#xmlFile#" variable="xmlPacket">
	<cfset xmlPacket = xmlParse(xmlPacket)>
	
	<cfif not structKeyExists(xmlPacket, "slideshow")>
		<cfreturn result>
	</cfif>
	
	<cfif structKeyExists(xmlPacket.slideshow, "formalname")>
		<cfset result.formalname = xmlPacket.slideshow.formalname.xmlText>
	</cfif>

	<cfif structKeyExists(xmlPacket.slideshow, "captions") and arrayLen(xmlPacket.slideshow.captions.xmlChildren)>
		<cfloop index="x" from="1" to="#arrayLen(xmlPacket.slideshow.captions.xmlChildren)#">
			<cfset imageNode = xmlPacket.slideshow.captions.xmlChildren[x]>
			<cfif structKeyExists(imageNode.xmlAttributes, "name") and structKeyExists(imageNode.xmlAttributes, "caption")>
				<cfset image.filename = imageNode.xmlAttributes.name>
				<cfset image.caption = imageNode.xmlAttributes.caption>
				<cfset result.images[image.filename] = image.caption>
			</cfif>				
		</cfloop>
	</cfif>

	<cfreturn result>	
</cffunction>

<cffunction name="getSlideShowDir" access="public" returnType="string" output="false" hint="Returns the slideshow directory.">
	<cfreturn variables.slideshowdir>
</cffunction>

<cffunction name="updateInfo" access="public" returnType="void" output="false" hint="Updates the XML packet.">
	<cfargument name="directory" type="string" required="true">
	<cfargument name="md" type="struct" required="true">
	<cfset var xmlFile = arguments.directory & "/metadata.xml">
	<cfset var packet = "">
	<cfset var image = "">
	
	<cfxml variable="packet">
	<cfoutput>
<slideshow>
	<formalname>#md.formalname#</formalname>
	<captions>
	<cfloop item="image" collection="#arguments.md.images#">
	<image name="#image#" caption="#arguments.md.images[image]#" />
	</cfloop>
	</captions>
</slideshow>
	</cfoutput>	
	</cfxml>
	
	<cffile action="write" file="#xmlFile#" output="#toString(packet)#">
</cffunction>

</cfcomponent>