<cfsetting enablecfoutputonly=true>
<!---
	Name         : datatable.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : January 25, 2007
	History      : JS fix (7/23/04)
				   Minor formatting updates (rkc 8/29/05)
				   finally add sorting (rkc 9/9/05)
				   url format support (rkc 7/7/06)
				   support for static data (rkc 7/13/06)
				   better support for empty data (rkc 11/30/06)
				   removed dupe cfparam (rkc 1/25/07)
	Purpose		 : A VERY app specific datable tag. 
--->

<cfif thisTag.hasEndTag and thisTag.executionMode is "start">
	<cfsetting enablecfoutputonly=false>
	<cfexit method="EXITTEMPLATE">
</cfif>

<cfparam name="attributes.data" type="query">
<cfparam name="attributes.linkcol" default="#listFirst(attributes.data.columnList)#">
<cfparam name="attributes.linkval" default="id">
<cfparam name="attributes.list" default="#attributes.data.columnList#">
<cfparam name="attributes.labellist" default="#attributes.list#">
<cfparam name="attributes.defaultsort" default="">
<cfparam name="attributes.defaultdir" default="asc">
<cfparam name="url.page" default="1">
<cfparam name="url.sort" default="#attributes.defaultsort#">
<cfparam name="url.dir" default="#attributes.defaultdir#">
<cfparam name="attributes.queryString" default="">
<cfparam name="attributes.deleteLink" default="#cgi.script_name#?#attributes.queryString#">

<cfparam name="attributes.deleteMsg" default="Are you sure?">
<cfparam name="attributes.noadd" default="false">

<!--- show add? --->
<cfparam name="attributes.showAdd" default="true">

<cfparam name="attributes.perpage" default="20">
<cfset colWidths = structNew()>
<cfset formatCols = structNew()>
<cfset leftCols = structNew()>
<cfset colData = structNew()>
<cfset dontSortList = "">

<!--- allow for datacol overrides --->
<cfif structKeyExists(thisTag,"assocAttribs")>
	<cfset attributes.list = "">
	<cfset attributes.labellist = "">
  
	<cfloop index="x" from="1" to="#arrayLen(thisTag.assocAttribs)#">
		<cfset attributes.list = listAppend(attributes.list, thisTag.assocAttribs[x].name)>
		<cfif structKeyExists(thisTag.assocAttribs[x], "label")>
			<cfset label = thisTag.assocAttribs[x].label>
		<cfelse>
			<cfset label = thisTag.assocAttribs[x].name>
		</cfif>
		<cfif structKeyExists(thisTag.assocAttribs[x], "format")>
			<cfset formatCols[thisTag.assocAttribs[x].name] = thisTag.assocAttribs[x].format>
		</cfif>		
		<cfset attributes.labellist = listAppend(attributes.labellist, label)>
		<cfif structKeyExists(thisTag.assocAttribs[x], "width")>
			<cfset colWidths[label] = thisTag.assocAttribs[x].width>
		</cfif>
		<cfif structKeyExists(thisTag.assocAttribs[x], "left")>
			<cfset leftCols[label] = thisTag.assocAttribs[x].left>
		</cfif>
		<cfif structKeyExists(thisTag.assocAttribs[x], "data") and len(thisTag.assocAttribs[x].data)>
			<cfset colData[thisTag.assocAttribs[x].name] = thisTag.assocAttribs[x].data>
		</cfif>
		<cfif structKeyExists(thisTag.assocAttribs[x], "sort") and not thisTag.assocAttribs[x].sort>
			<cfset dontSortList = listAppend(dontSortList, thisTag.assocAttribs[x].name)>
		</cfif>

	</cfloop>
</cfif>


<cfif url.dir is not "asc" and url.dir is not "desc">
	<cfset url.dir = "asc">
</cfif>

<cfif len(trim(url.sort)) and len(trim(url.dir))>
	<cfquery name="attributes.data" dbtype="query">
	select 	*
	from	attributes.data
	order by 	#url.sort# #url.dir#
	</cfquery>
</cfif>

<cfif not isNumeric(url.page) or url.page lte 0>
	<cfset url.page = 1>
</cfif>

<cfif isDefined("url.msg")>
	<cfoutput>
	<p>
	<b>#url.msg#</b>
	</p>
	</cfoutput>
</cfif>

<cfoutput>

<script>
function checksubmit() {
	if(document.forms["listing"].mark.length == null) {
		if(document["listing"].mark.checked) {
			document.forms["listing"].submit();
		}
	}
	for(i=0; i < document.forms["listing"].mark.length; i++) {
		if(document.forms["listing"].mark[i].checked) document.forms["listing"].submit();
	}
	
}

$(document).ready(function() {
	$("##checkalllink").click(function(e) {
		$(".itemcheckbox").each(function(item) {
			$(this).attr("checked", "checked");
		});
		e.preventDefault();
	});

	$("##decheckalllink").click(function(e) {
		$(".itemcheckbox").each(function(item) {
			$(this).removeAttr("checked");
		});
		e.preventDefault();
	});

});
</script>

<cfif attributes.data.recordCount gt attributes.perpage>
	<p align="right">
	[[
	<cfif url.page gt 1>
		<a href="#cgi.script_name#?page=#url.page-1#&amp;sort=#urlEncodedFormat(url.sort)#&amp;dir=#url.dir#&amp;#attributes.querystring#">Previous</a>
	<cfelse>
		Previous
	</cfif>
	--
	<cfif url.page * attributes.perpage lt attributes.data.recordCount>
		<a href="#cgi.script_name#?page=#url.page+1#&amp;sort=#urlEncodedFormat(url.sort)#&amp;dir=#url.dir#&amp;#attributes.querystring#">Next</a>
	<cfelse>
		Next
	</cfif>
	]]
	</p>
</cfif>

<p>
<form name="listing" action="#attributes.deletelink#" method="post">
<table cellspacing="0" cellpadding="5" class="adminListTable" border="0">
	<tr class="adminListHeader">
		<td width="30">&nbsp;</td>
		<cfset counter = 0>
		<cfloop index="c" list="#attributes.labellist#">
			<cfset counter = counter + 1>
			<cfset col = listGetAt(attributes.list, counter)>
			<cfif url.sort is col and url.dir is "asc">
				<cfset dir = "desc">
			<cfelse>
				<cfset dir = "asc">
			</cfif>
			<td <cfif structKeyExists(colWidths, c)>width="#colWidths[c]#"</cfif>>
			<cfif not listFind(dontSortList, col)>
			<a href="#cgi.script_name#?page=#url.page#&amp;sort=#urlEncodedFormat(col)#&amp;dir=#dir#&amp;#attributes.querystring#">#c#</a>
			<cfelse>
				#c#
			</cfif>
			</td>
		</cfloop>
	</tr>
</cfoutput>

<cfif attributes.data.recordCount>
	<cfset columnlist = attributes.data.columnlist>
	<cfoutput query="attributes.data" startrow="#(url.page-1)*attributes.perpage + 1#" maxrows="#attributes.perpage#">
		<cfset theVal = attributes.data[attributes.linkval][currentRow]>
		<cfset theLink = attributes.editlink & "?id=#theVal#">
		<tr class="adminList#currentRow mod 2#">
			<td width="20"><input type="checkbox" name="mark" value="#attributes.data[attributes.linkval][currentRow]#" class="itemcheckbox" /></td>
			<cfloop index="c" list="#attributes.list#">
				<cfif not structKeyExists(colData, c)>
					<cfset value = attributes.data[c][currentRow]>
					<cfset value = htmlEditFormat(value)>
				<cfelse>
					<cfset value = colData[c]>
					<!--- This should be changed to check columns and by dynamic --->
					<!--- It would be a trivial change actually, but I'm lazy. --->
					<!--- As it stands,this file needs cleanup --->
					<cfif findNoCase("$id$", value)>
						<cfset value = replace(value, "$id$", id, "all")>
					</cfif>
					<cfif findNoCase("$viewurl$", value)>
						<cfset value = replace(value, "$viewurl$", viewurl, "all")>
					</cfif>
					<cfif findNoCase("$email$", value)>
						<cfset value = replace(value, "$email$", urlEncodedFormat(email), "all")>
					</cfif>
					<cfif findNoCase("$name$", value)>
						<cfset value = replace(value, "$name$", name, "all")>
					</cfif>

					<cfif listFindNoCase(columnlist, "entryidfk")><cfset value = replace(value, "$entryidfk$", entryidfk, "all")></cfif>
				</cfif>

				<cfif structKeyExists(formatCols, c) and value neq "">
					<cfswitch expression="#formatCols[c]#">

						<cfcase value="yesno">
							<cfset value = yesNoFormat(value)>
						</cfcase>
						
						<cfcase value="datetime">
							<cfset value = dateFormat(value,"mm/dd/yy") & " " & timeFormat(value,"h:mm tt")>
						</cfcase>

						<cfcase value="date">
							<cfset value = dateFormat(value,"mm/dd/yy")>
						</cfcase>

						<cfcase value="currency">
							<cfset value = dollarFormat(value)>
						</cfcase>

						<cfcase value="number">
							<cfset value = numberFormat(value)>
						</cfcase>
						
						<cfcase value="url">
							<cfset value = "<a href=""#value#"">#value#</a>">
						</cfcase>
						s
					</cfswitch>
				</cfif>
				
				<cfif value is "">
					<cfset value = "&nbsp;">
				</cfif>
				<cfif structKeyExists(leftCols, c) and len(value) gt leftCols[c]>
					<cfset value = left(value, leftCols[c]) & "...">
				</cfif>
				
				<td>
				<cfif c is attributes.linkcol>
				<a href="#attributes.editlink#?id=#attributes.data[attributes.linkval][currentRow]#&amp;#attributes.queryString#">#value#</a>
				<cfelse>
				#value#
				</cfif>
				</td>
			</cfloop>
		</tr>
	</cfoutput>
<cfelse>

</cfif>

<cfoutput>
</table>
</form>
</p>

<div class="buttonbar">
<a href="" id="checkalllink" class="button">Check All</a> 
<a href="" id="decheckalllink" class="button">Uncheck All</a> 
<cfif attributes.showAdd><a href="#attributes.editlink#?id=0&amp;#attributes.querystring#" class="button">Add #attributes.label#</a></cfif>
<a href="javascript:checksubmit()" class="button">Delete Selected</a>
</div>
</cfoutput>

<cfsetting enablecfoutputonly=false>

<cfexit method="EXITTAG">