<cfset offset = application.settings.offset>
<cfset blogurl = application.settings.blogurl>

<cfset now = dateAdd("h", offset, now())>
<cfif structKeyExists(url, "month")>
	<cfset month = url.month>
<cfelse>
	<cfset month = month(now)>
</cfif>
<cfif structKeyExists(url, "year")>
	<cfset year = url.year>
<cfelse>
	<cfset year = year(now)>
</cfif>

<cfscript>						
	firstDay=createDate(year,month,1);
	firstDOW=dayOfWeek(firstDay);
	firstWeekPad = 7-firstDOW;
	dim=daysInMonth(firstDay);
	lastMonth=dateAdd("m",-1,firstDay);
	nextMonth=dateAdd("m",1,firstDay);	
	dayList=application.entryService.getActiveDays(year,month);
	dayCounter=1;
	rowCounter=1;
</cfscript>

<cfoutput>
<table border="0" id="calendar">
<thead>
<tr>
	<td colspan="7" align="center">
	<a href="#blogurl#/#year(lastmonth)#/#month(lastmonth)#" rel="nofollow">&lt;&lt;</a>
	<a href="#blogurl#/#year#/#month#" rel="nofollow">#monthAsString(month)# #year#</a>
	<a href="#blogurl#/#year(nextmonth)#/#month(nextmonth)#" rel="nofollow">&gt;&gt;</a>
	</td>
</tr>
<tr>
	<!--- emit localized days in proper week start order --->
	<cfloop index="i" from="1" to="7">
	<th>#left(dayOfWeekAsString(i),3)#</th>
	</cfloop>
</tr>
</thead>
<tbody>
</cfoutput>
<!--- loop until 1st --->
<cfoutput><tr></cfoutput>
<cfloop index="x" from=1 to="#firstWeekPAD#">
	<cfoutput><td>&nbsp;</td></cfoutput>
</cfloop>

<!--- note changed loop to start w/firstWeekPAD+1 and evaluated vs dayCounter instead of X --->
<cfloop index="x" from="#firstWeekPAD+1#" to="7">
	<cfoutput><td <cfif month(now) eq month and dayCounter eq day(now) and year(now) eq year> class="calendarToday"</cfif>><cfif listFind(dayList,dayCounter)><a href="#application.blog.getProperty("blogurl")#/#year#/#month#/#dayCounter#" rel="nofollow">#dayCounter#</a><cfelse>#dayCounter#</cfif></td></cfoutput>
	<cfset dayCounter = dayCounter + 1>
</cfloop>
<cfoutput></tr></cfoutput>
<!--- now loop until month days --->
<cfloop index="x" from="#dayCounter#" to="#dim#">
	<cfif rowCounter is 1>
		<cfoutput><tr></cfoutput>
	</cfif>
	<cfoutput>
		<td <cfif month(now) eq month and x eq day(now) and year(now) eq year> class="calendarToday"</cfif>>
		<!--- the second clause here fixes an Oracle glitch where 9 comes back as 09. Should be harmless for other DBs that aren't as 'enterprise-y' as Oracle --->
		<cfif listFind(dayList,x) or listFind(dayList, "0" & x)><a href="#blogurl#/#year#/#month#/#x#" rel="nofollow">#x#</a><cfelse>#x#</cfif>
		</td>
	</cfoutput>
	<cfset rowCounter = rowCounter + 1>
	<cfif rowCounter is 8>
		<cfoutput></tr></cfoutput>
		<cfset rowCounter = 1>
	</cfif>
</cfloop>
<!--- now finish up last row --->
<cfif rowCounter GT 1> <!--- test if ran out of days --->
	<cfloop index="x" from="#rowCounter#" to=7>
		<cfoutput><td>&nbsp;</td></cfoutput>
	</cfloop>
	<cfoutput></tr></cfoutput>
</cfif>
<cfoutput>
</tbody>
</table>
</cfoutput>