<cfparam name="url.id" default="">
<cfif not len(url.id)>
	<cfabort>
</cfif>

<cfset tweetbacks = application.sweetTweets.getTweetbacks(application.blog.makeLink(id), 10)/>

<cfif arrayLen(tweetbacks)>
	<cfloop index="x" from="1" to="#arrayLen(tweetbacks)#">
		<cfset tb = tweetbacks[x]>
		<cfoutput>
		<div class="tweetback">
		<div class="tweetbackBody">
		<img src="#tb.profile_image_url#" title="#tb.from_user#'s Profile" border="0" align="left" />
		#application.utils.ParagraphFormat2(tb.text)#
		</div>
		<div class="tweetbackByLine">
		#request.rb("postedby")# <a href="http://www.twitter.com/#tb.from_user#">#tb.from_user#</a>
		| #application.localeUtils.dateLocaleFormat(tb.created_at,"short")# #application.localeUtils.timeLocaleFormat(tb.created_at)#
		</div>
		<br clear="left">
		</div>
		</cfoutput>
	</cfloop>	

<cfelse>
	<cfoutput><div class="tweetbackBody">#application.resourceBundle.getResource("notweetbacks")#</div></cfoutput>
</cfif>
