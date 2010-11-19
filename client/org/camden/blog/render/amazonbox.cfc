<cfcomponent extends="render" instructions="To place an left-aligned Amazon 'box' for a product, use: <amazonbox asin=""x"" affiliate=""y"">">

<cffunction name="display">
	<cfargument name="asin" type="string" required="false" default="">
	<cfargument name="affiliate" type="string" required="false" default="raymondcamden-20">
	
	<cfset var result = "">

	<cfif len(arguments.asin) and len(arguments.affiliate)>
		<cfsavecontent variable="result">
		<cfoutput>
<iframe src="http://rcm.amazon.com/e/cm?t=#arguments.affiliate#&o=1&p=8&l=as1&asins=#arguments.asin#&fc1=000000&IS2=1&lt1=_top&lc1=0000ff&bc1=000000&bg1=ffffff&npa=1&f=ifr" style="width:120px;height:240px;margin-right: 10px" scrolling="no" marginwidth="0" marginheight="0" frameborder="0" align="left"></iframe>
		</cfoutput>
		</cfsavecontent>
	</cfif>
		
	<cfreturn result>
</cffunction>

</cfcomponent>