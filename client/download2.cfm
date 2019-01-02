<!---
Description: streams arbitrary files to the browser.

JH DotCOmIt 1/13/07 
Copied from this thread: http://www.granularity.net/mailman/private/cfguru/2006-August/011610.html
http://www.funkymojo.com/blog/index.cfm/2006/8/6/Binary-Output-in-ColdFusion
Code to get the mime-type from the file:
response.setContentType(getPageContext().getServletContext().getMimeType(s_file));

Credits:

fs_stream.cfm by Robert Munn

    http://www.funkymojo.com

v 1.1 - release that modifies Steve Savage's solution to allow arbitrary
file types to be streamed to the user.


Based on streaming FLV solution by Steve Savage:
  Streaming FLV data via ColdFusion MX 7 (perhaps 6.1, but untested):
    http://www.realitystorm.com/experiments/flash/streamingFLV/index.cfm
    http://www.realitystorm.com/contact/index.cfm

Based on work by:

Stefan Richter
    Streaming FLV data via PHP:
http://www.flashcomguru.com/index.cfm/2005/11/2/Streaming-flv-video-via-PHP-take-two

Christian Cantrell
    Byte Arrays:
http://weblogs.macromedia.com/cantrell/archives/2004/01/byte_arrays_and_1.cfm
    Write Out Binary Data to Browser:
http://weblogs.macromedia.com/cantrell/archives/2003/06/using_coldfusio.cfm

Buraks:
    Frameposition metadata encoder: http://www.buraks.com/flvmdi/

Modifications:
1.0 - initial release code place on realitystorm.com and given to the
http://www.rich-media-project.com/


--->

<cfscript>
	url = application.utils.parseSES();
</cfscript>

<!---- added a default directory to give the option to change it
	This won't work using SES URLs and multiple directory levels deep
--->
<cfparam name="url.dir" default="enclosures">
<!---- added to track downloads downloads vs on-line views --->
<cfparam name="url.online" default="0">


<!--- code copied from print.cfm ---->
<cfif not isDefined("url.id")>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<Cfdump var="#url.id#" />

<cftry>
	<cfset entry = application.blog.getEntry(url.id)>
	<cfdump var="#entry#" />
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<!--- End code copied from print.cfm ---->

<!--- <cfdump var="#application.blog#">
<cfabort> --->
<!---- Log the download ---->


<!---- Log the download ---->
<cfset application.downloadtracker.logEnclosureDownload(entry.id,entry.enclosure,url.dir,url.online)>

<!--- the function that sends the feed --->
<cfscript>
	function f_Stream(s_file,i_seek,MIME_TYPE,fileName) {
		var i_position = i_seek;
		var i_buffer = 10000;
		var byteClass = createObject("java", "java.lang.Byte"); //
		var byteArray = createObject("java","java.lang.reflect.Array").newInstance(byteClass.TYPE, i_buffer);
		var context = getPageContext();
		var response = context.getResponse().getResponse(); 
		
		var instream = createObject("java", "java.io.FileInputStream"); 
		var outstream = response.getOutputStream(); // take over control of the feed to the browser
		
		if(structKeyexists(arguments,"MIME_TYPE"))
			response.setContentType(MIME_TYPE);
		if(structKeyExists(arguments,"fileName"))
			response.setHeader("content-disposition","inline; filename=#fileName#");
		byteClass.Init(1);
		instream.init(s_file);
		context.setFlushOutput(false);
		try {
			if(i_seek GT 0) {
				//instream.skip(i_seek);
				//outstream.write(toBinary('RkxWAQEAAAAJAAAACQ==')); // output the header bytes
			}
			do {
				i_length = instream.read(byteArray,0,i_buffer);
				if (i_length neq -1) {
					outstream.write(byteArray);
					outstream.flush();
				}
			} while (i_length neq -1); // keep going until there's nothing left to read.
		}
		catch(any excpt) {}
		outstream.flush(); // send any remaining bytes
		response.reset(); // reset the feed to the browser
		outstream.close(); // close the stream to flash
		instream.close(); // close the file stream
	}
</cfscript>

<!--- just specify the file to serve, offset (Flash only), MIME type (optional), and download filename (optional) --->
<cfset f_Stream(entry.enclosure,0,entry.mimetype,getFileFromPath(entry.enclosure))>

<cfsetting enablecfoutputonly="YES">

