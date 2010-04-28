<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
   Name : 			tags.cfm
   Author : 		Steven Erat
   Created : 		November 15, 2005
   Last Updated : 	August 29, 2006
   History : 		Based on blog entries by Pete Freitag and Joe Rinehart
					Use SES cat urls (rkc 8/29/06)
   Purpose : 		Display archives as sized tags
--->

<cfmodule template="../../tags/scopecache.cfm" cachename="#application.applicationname#_tc" scope="application" timeout="#application.timeout#">

<cfmodule template="../../tags/podlayout.cfm" title="Tags">

   <cfset cats = application.blog.getCategories()>
   
   <cfquery dbtype="query" name="tags">
      SELECT entrycount AS tagCount,categoryname as tag, categoryid
      FROM
         cats
      WHERE entrycount >= 10
   </cfquery>
   
   <cfset tagValueArray = ListToArray(ValueList(tags.tagCount))>
   <cfset max = ArrayMax(tagValueArray)>
   <cfset min = ArrayMin(tagValueArray)>
   
   <cfset diff = max - min>
   <!---
      scaleFactor will affect the degree of difference between the different font sizes.
      if you have one really large category and many smaller categories, then set higher.
      if your category count does not vary too much try a lower number.      
   --->
   <cfset scaleFactor = 25>
   <cfset distribution = diff / scaleFactor>
   
   <!--- optionally add a range of colors in the CSS color property for each class --->
   <cfoutput>
      <cfloop query="tags">
         <cfsilent>
            <cfif tags.tagCount EQ min>
               <cfset class="smallestTag">
            <cfelseif tags.tagCount EQ max>
               <cfset class="largestTag">
            <cfelseif tags.tagCount GT (min + (distribution*2))>
               <cfset class="largeTag">
            <cfelseif tags.tagCount GT (min + distribution)>
               <cfset class="mediumTag">
            <cfelse>
               <cfset class="smallTag">
            </cfif>
         </cfsilent>
         <a href="#application.blog.makeCategoryLink(tags.categoryid)#"><span class="#class#">#lcase(tags.tag)#</span></a>
      </cfloop>
   </cfoutput>
   
   
</cfmodule>

</cfmodule>
   
<cfsetting enablecfoutputonly=false>