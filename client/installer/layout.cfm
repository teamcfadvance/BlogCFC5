<cfparam name="attributes.title" default="">

<cfif thisTag.executionMode is "start">

	<html>

	<head>
	<cfoutput>
	<title>#attributes.title#</title>
	</cfoutput>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
	<script type="text/javascript" src="jquery.corner.js"></script>
	<script type="text/javascript" src="jquery.validate.min.js"></script>
	<script>
    $(document).ready(function() {
    	$("h1,#content").corner()
    })
    </script>
	</head>
	<body>

	<cfoutput>
	<h1>#attributes.title#</h1>
	</cfoutput>

	<div id="content">

<cfelse>

	</div>
	</body>
	</html>

</cfif>