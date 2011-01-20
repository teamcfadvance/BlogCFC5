LICENSE 
Copyright 2008-2010 Raymond Camden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
   
If you find this blog worthy, I have a Amazon wish list set up (www.amazon.com/o/registry/2TCL1D08EZEYE ). Gifts are always welcome. ;)
Install directions may be found in BlogCFC.doc/pdf.

UPGRADE NOTES:
Find your current version in the notes below, and read 'upwards' to determine what files you have to copy. 
Note - if your blog is running RIGHT now, you will want to ensure your first hit on your blog (after you copied files and made any other changes) refreshes the blog cache.
This is done by adding ?reinit=1 to the URL.


=======================================================================================================================================================================================
Last Updated: January 20, 2011 (BlogCFC 5.9.8)

5.9.8 is a rather drastic update to BlogCFC. First, a new theme is being used. This theme is a radical departure from the previous skin. 
Next - trackbacks as a feature has been removed. For years now TBs were nothing but spam bait and used by only a very few of our users
so it was decided to simply remove them. 

You will also notice that the org folder now resides within the main client folder. Since most users had a simple setup like that it was decided
to simply put the folder where most folks would end up using it. 

The mobile folder has a few updates as well. You can simply copy that entire folder over.

Existing users will - most likely - want to set up a test server with the new code base pointing to their database and see how the new skin works with their data.

=======================================================================================================================================================================================
Last Updated: October 6, 2010 (BlogCFC 5.9.7.001)

/client/xmlrpc/xmlrpc.cfm - fix for Windows Live Writer by Dan Switzer: http://blog.pengoworks.com/index.cfm/2010/10/12/Problems-with-BlogCFC-and-new-Live-Writer-2011
/includes - locale RB files updated by Knut Bewersdorff
/mobile/Application.cfm - fix by Andy Jarett - http://www.andyjarrett.co.uk/blog/index.cfm/2010/10/27/Making-BlogCFC-mobile-a-bit-more-flexible

Last Updated: October 6, 2010 (BlogCFC 5.9.7)

Note - this is a big update. Therefore, not all files modified are listed. I recommend updating all files to be safe.

The following changes are credit Rob Brooks-Bilson
/org/camden/blog/blog.cfc
various methods have hints now
getArchives - new function to get archived entries - this can be used in a new pod
getCommentCount - new func to - you can guess
Ok, so lots of other improvements as well. Not things that you as an end user need to worry about, but basically he cleaned up a lot of my crap. ;)
/org/delmore/formatter.cfc - a IE fix - thanks to Rob

/client/includes/pods/monthlyarchives.cfm - new pod by RBB, also updated the main.properties and main_en_US.properties files for it

Dave Ferguson added mobile support. This is done via auto detection but clients can temporarily disable the mobile version.
Jason Delmore updated the UI of the Admin as well as comment emails.

Last Updated: August 26, 2010 (BlogCFC 5.9.6.005)

/client/admin/pods.cfm - Added text to make it more clear how it works.
/client/admin/pod.cfm - if you cleared the checkboxes, we weren't storing that.
/org/camden/blog/blog.cfc - version #

Last Updated: August 3, 2010 (BlogCFC 5.9.6.004)

/install/oracle.sql - updated by Chad Armond
/client/cfformrotect/cfftpVerify.cfc - minor bug fix
/client/addcomment.cfm - If logged in, no need for captcha (thanks to Ryan V for idea)
/org/camden/blog/blog.cfc - Support for above, + version #

Last Updated: June 2, 2010 (BlogCFC 5.9.6.003)
/client/admin/categories.cfm - small layout fix
/client/admin/entries.cfm - sorting works right now
/client/includes/pods/subscribe.cfm - I think I forgot to check in the XSS fix.
/client/tags/datatablenew.cfm - support sorting fix
/org/camden/blog/blog.cfc - support sorting fix, and version #


Last Updated: May 18, 2010 (BlogCFC 5.9.6.002)
Security updates. The following fixes were done after a review of BlogCFC by ProCheckup. (www.procheckup.com) This was done by 
them free of charge and I want to send them a huge thank you for sharing these vulnerbilities with me and helping me test the fixes.

/client/includes/Application.cfm - new file, blocks access
/client/tags/Application.cfm - ditto
/client/includes/pods/subscribe.cfm - prevent XSS
/client/stats.cfm - ditto

/org/camden/blog/blog.cfc - Just the version #.

Last Updated: April 29, 2010 (BlogCFC 5.9.6.001)
/client/index.cfm and /client/tags/layout.cfm - slight fix for TweetBacks
/org/sweettweets/sweettweets.cfc, shrinkURL.cfc - new files

Last Updated: April 28, 2010 (BlogCFC 5.9.6)

Jeff Braunstein added the "Browse by Author" feature, along with the new Add It bar.

Lots of database optimizations (mostly caches)

Modified files:
M	/client/tags/getmode.cfm
M	/client/tags/parseses.cfm
M	/client/admin/page.cfm
M	/client/includes/pods/calendar.cfm
M	/client/index.cfm
M	/client/admin/entry.cfm
M	/client/includes/pods/pages.cfm
M	/client/includes/pods/recent.cfm
M	/org/camden/blog/blog.cfc
M	/client/includes/pods/tagcloud.cfm

Last Updated: April 14, 2010 (BlogCFC 5.9.5.008)
/client/admin/entry.cfm - I had the wrong label in the related entries tab.
/client/installer/Application.cfm - I accidentally checked it in blocked.
/client/tags/datatablenew.cfm - edge case fix
/client/tags/scopecache.cfm - fix for cases when CF may not have file access
/client/install/accessblog.mdb - missing col
/org/camden/blog/blog.cfc - version
/org/camden/blog/render/render.cfc - perf fix


Last Updated: April 8, 2010 (BlogCFC 5.9.5.007)
Fixes by Ken Gladden

Note - looks like I screwed the pooch on readme.old2.txt. If folks really need something from the old history, I can grab it
from SVN, but for now, I assume it isn't critical.

/org/camden/blog/blog.cfc - just the version #
/client/installer/Application.cfm - bug fix
/client/Application.cfm - another bug fix

Last Updated: April 3, 2010 (BlogCFC 5.9.5.006)
/client/search.cfm - I now allow the search field to be blank. This was a recommendation by someone who
was trying to use search.cfm as a way to browse content. I thought it was a good change.

/client/loadtweetbacks.cfm - fix for change to results - thanks to Shaun Mccran.

/org/camden/blog/blog.cfc - Just the version #.

I trimmed this file quite a bit and put older comments in readme.old2.txt.

Last Updated: March 3, 2010 (BlogCFC 5.9.5.005) | Brian Kotek, Raymond Camden
/client/tags/scopecache.cfm - Update scope cache to latest version
/client/index.cfm - removed use of {} which broke cf6 compat
/client/admin/comments.cfm - Support for Approving comments - I forget who wrote this. Sorry!
/org/camden/blog/blog.cfc -> From mailEntry, tell RenderEntry not to add Ps. Also, we won't run coldfish on code blocks for mail entries. 
/org/sweetweets/* -> Updated to 2.0
/client/admin/latestversioncheck.cfm - try/catch the http hit

/client/Application.cfm - support for Installer

NOTES TO EXISTING USERS:
This version includes Installer support. Since your blog is already running, you don't need this folder. You can skip copying it. However, you MUST set up this property in your blog.ini.cfm:
installed=yes
That flags BlogCFC to say you already have run the installer.


Last Updated: January 18, 2010 (BlogCFC 5.9.5.004) | Raymond Camden 
/org/sweettweets/SweetTweets.cfc - two small fixes. Note - this feature will most likely be going away in a future update.
/org/camden/blog/blog.cfc - fixes an issue where users w/ the same name in 2-N blogs would create multiple entries, also version update
/install/mysql.sql - fixes multiple typos
/client/includes/pod.cfm - XHTML fix (Gary)
/client/stats.cfm - XHTML fix (Gary)
/org/delmore/formatter.cfc, /org/delmore/coldfishconfig.xml - (Gary)
/client/tags/layout.cfm - Gary

Last Updated: December 20, 2009 (BlogCFC 5.9.5.003) | Raymond Camden 
At a high level, the changes in this version are for XHTML tuning (see below), and to support pages that don't use layout. That change requires a database change for existing users. Modify your tblBlogPages
table to add a "showlayout" column. This is a boolean type (used tinyint for mysql). For existing pages, don't worry. If the value for them is null, it is assumed to be a true value.

Note - this version includes many XHTML tuning fixes. Thanks for these go to Andreas Schuldhaus.

/client/addsub.cfm - XHTML
/client/admin/pages.cfm - Typo
/client/admin/page.cfm - Support layout-less pages.
/client/contact.cfm - XHTML
/client/loadtweetbacks.cfm - ditto
/client/admin/page.cfm - Support layout-less pages.
/client/tags/datatablenew.cfm - XHTML
/client/trackbacks.cfm - ditto
/org/camden/blog/page.cfc - Support layout-less pages.
/client/addcomment.cfm - XHTML, typo
/client/error.cfm - XHTML
/client/tags/simplecontenteditor.cfm - REMOVED!
/client/includes/pods/archive.cfm - XHTML
/client/includes/pods/calendar.cfm - XHTML
/client/includes/pods/feed.cfm - XHTML
/client/includes/pods/recent.cfm - XHTML
/client/includes/pods/recentcomments.cfm - XHTML, we now cache the recent comments
/client/includes/pods/rss.cfm - XHTML (and removed empty alt)
/client/includes/pods/search.cfm - XHTML
/client/includes/pods/subscribe.cfm - XHTML
/client/includes/pods/tagcloud.cfm - XHTML, notice- CSS for tag clouds moved to style.css
/client/includes/styles.css - tag cloud styles
/client/statsbyyear.cfm - XHTML
/client/stats.cfm - XHTML
/client/slideshow.cfm - XHTML
/client/send.cfm - XHTML
/client/search.cfm - XHTML, style moved to styles.css
/client/rss.cfm - XHTML
/client/index.cfm - XHTML
/client/tags/datatable.cfm - XHTML
/client/tags/layout.cfm - XHTML

Install scripts for all but MS Access updated to include showlayout for pages table.

Notice - Gary Funk did some big optimization to the MySQL install script. Folks may want to look it over and compare. This was in direct result to performance issues I had with my own blog.
Notice - Gary Funk did the same for mysql.sql.

/org/delmore/* - Updated ColdFish library.
/org/camden/blog/blog.cfc - Performance fix on mailEntry - will be significant for folks with large subscriber lists. Version #

Last Updated: November 18, 2009 (BlogCFC 5.9.5.002) | Raymond Camden 
/client/admin/entry.cfm: Removed auto-grow textarea. Slightly increased max height. Fixed broken link.
/client/index.cfm - Fixes a bug that can occur with some wonky urls.
/org/camden/blog/blog.cfc - limits the size of the alias when searching + version

Last Updated: November 3, 2009 (BlogCFC 5.9.5.001) | Raymond Camden 
/org/camden/delmore/coldfish.cfc - fix for cf7 compate
/org/camden/blog/blog.cfc - just the version #
/client/tags/datatable.cfm - helps support the comment viewer in the admin
/client/tags/adminlayout.cfm - remove a CSS I wasn't using
/client/admin/entry_comments.cfm - minor bug fix

Last Updated: November 3, 2009 (BlogCFC 5.9.5) | Raymond Camden 
/client/admin/comments.cfm - Just a simple typo fix to make the period line up next to the sentence.
/client/admin/entry.cfm - 
BIG changes. Removed Tabber/Spry. jQuery and jQuery UI used instead. The forms make use of uni-form to make it pretty. The textareas make use of a auto-grow plugin.
Related entries changed to allow you to filter by search, and to only return, at most, 200 records. Will help on blogs w/ lots of entries.
/client/admin/entry_comments.cfm - a typo fix like for comments.cfm.
/client/admin/index.cfm - Support remote version check.
/client/admin/latestversioncheck.cfm - Support for the above.
/client/admin/proxy.cfm - New support for updated related entry support.
/client/admin/spryproxy.cfm - Deleted!
/client/includes/admin.css - minor update to Admin css.
/client/includes/jquery.autogrow.js - New file
/client/includes/jquery.selectboxes.js - New file
/client/includes/jqueryui - New folder
/client/includes/main_en_US.properties - SUpport for previous entries string.
/client/includes/relatedposts.js, relatedpostsjs.cfm, relatedpostsjs_error.cfm - Deleted!
/client/includes/spry - Deleted!
/client/includes/tab.css + tabber.js - Deleted!
/client/includes/uni-form - New folder
/client/index.cfm - Support going backwards in pagination.
/org/camden/blog/blog.cfc - Version update.
/client/tags/adminlayout.cfm - support for loading new jquery libraries
/client/tags/layout.cfm - jquery always loaded
/client/tags/textarea.cfm - support for passing in style attribute
/org/sweettweets/* - Updated to latest SweetTweets library.
/org/delmore/coldfish.cfc - Updated to latest ColdFish.
/client/admin/login.cfm - small design tweak

Last Updated: September 1, 2009 (BlogCFC 5.9.4.001) | Raymond Camden 
/org/camden/blog/blog.cfc - Fix to rss code to not output image stuff if the itunesimage value not specified
/org/camden/blog/blog.cfc - case sensitivity issue for mysql fixed
/client/stats.cfm - Added numerFormat around most stats. Makes the #s a bit nicer.
/client/admin/settings.cfm - Support setting Use cfFormProtect (thanks Todd Sharp!)

Last Updated: July 15, 2009 (BlogCFC 5.9.4 (Test)) | Raymond Camden 

WARNING - PLEASE READ THIS CAREFULLY. THIS RELEASE ADDS NEW TABLES AND NEW SETTINGS AND IF YOU DO NOT FOLLOW THESE DIRECTIONS, YOU WILL NOT BE ABLE TO LOGON TO YOUR BLOG.
YOU HAVE BEEN WARNING. -ZOD

First off, the new features of this release are NOT documented in the doc/pdf yet. They will be. Check the blog entry for full details. This file will mainly describe what you have to do to get
the new build up and running. Also be sure to copy all the files listed below. Ok, so let's begin.

First, create the tblblogroles table. You will find this in the install scripts for MySQL and SQL Server. Note that you also need to run the seed statements as well.

Second, the tblusers table now has a blog column. THIS IS CRITICAL. You must add the blog column, and for each user, you must enter their blog. This associates
the user with a blog. In the past, we used the "users" property in blog.ini.cfm to say which users were matched to a blog. That property is now gone (ignored). So
if you currently have one user in N blogs, you need to create N rows in the database, one for each blog he used to belong to.

Third, run the create script for tbluserroles. This table sets roles for users. At minimum, you want to set up your Admin user to have the Admin role. You can take this line:

INSERT INTO `blogcfc`.`tbluserroles` VALUES  ('admin','7F25A20B-EE6D-612D-24A7C0CEE6483EC2','Default');

and modify the first value (admin) to match your username. Once you've done that, you have a 'real' admin user with a 'admin' role who can set up your other users.

I'm going to repeat the above to ensure it makes sense. You have one table that lists all roles - you must create and seed it. Your users table now has a blog column. And lastly, tbluserroles creates a
relationship between the two.

Ok - so in theory, thats it. Please the blog entry for a description of how these changes are used.

Oracle/Access NOT updated. Looking for volunteers. On July 20, I checked in an Access update by Andy Florino. May be ok now.



Misc Changes:
Removed old coloredcode function

Updated Files:
/tags/adminlayout.cfm and layout.cfm
/admin/Application.cfm, users.cfm, user.cfm, categories.cfm, category.cfm, entries.cfm, entry.cfm
/rss.cfm
/org/camden/blog/blog.cfc, utils.cfc
/includes/udf.cfm
/trackbacks.cfm (fix by Ben Forta)
/admin/settings.cfm





Last Updated: June 18, 2009 (BlogCFC 5.9.3.006) | Raymond Camden 
Locale files for DE, CH, AT by Mischa Sameli
/stats.cfm - various SQL Server fixes
/admin/settings.cfm - suggestion by Forta to sort tb spam list
/admin/entry.cfm - fix the image upload url
/org/camden/blog/blog.cfc - version
/org/camden/blog/blog.ini - the trackback spam list is sorted, but not different

Last Updated: May 14, 2009 (BlogCFC 5.9.3.005) | Raymond Camden 

Note - the main fix in this build is to SweetTweets. ST can be VERY slow on the first hit. I've switched to using jQuery to dynamically load the STs in. So
when you first hit the page, you will see a loading msg in that area.

/admin/entry.cfm - Fix to image url issue for uploaded images.
/org/camden/blog/blog.cfc - version only
/tags/layout.cfm - support loading jQuery library
/loadtweetbacks.cfm - New file
/index.cfm - support changes to tweetbacks
/includes/jquery.min.js - new file
/includes/style.css - SweetTweet icon fix

Last Updated: June 1, 2009 (BlogCFC 5.9.3.004) | Dan G. Switzer, II 
/client/googlesitemap.cfm
 * Added "reset=true" attribute to <cfcontent /> tag
 * Fixed bug introduces when getEntries() method return structure was changed

Last Updated: May 21, 2009 (BlogCFC 5.9.3.003) | Dan G. Switzer, II 
/org/camden/blog/blog.cfc
 * Added check to renderEntry() function to look for existing <p> tags and if they exist, it does not use the xParagraphFormatting (although you can override this behavior by setting the ignoreParagraphFormat to false.) Adding this check helps produce valid XHTML when you're blog is already correctly entered in as XHTML.

Last Updated: May 14, 2009 (BlogCFC 5.9.3.002) | Raymond Camden 
/client/include/pods/calendar.cfm - Oracle fix.
/client/stats.cfm - Oracle fix
/org/camdne/blog/blog.cfc - version #
/install/BLogCFC.pdf and doc - Oracle notes.

All of the above thanks to Nick Hill.

/client/xmlrpc/xmlrpc.cfm
 * Added some code to clean up <more /> tags entered when use the url.parseMarkup variable. The new code removes <p> elements wrapped around a <p>&lt;more/&gt;</p> string, which helps to produce valid XHTML.

Last Updated: May 1, 2009 (BlogCFC 5.9.3.001) | Raymond Camden 
/client/xmlrpc/xmlrpc.cfm - some small fixes, but NOTE, I officially consider XMLRPC support to be a bit fubared.
/org/camden/blog/blog.cfc - Removed author name from the RSS. Why? It was causing an issue with validation. The author value for RSS2 must be an email address, and I was
using a username. This kinda sucks for multiuser blogs. For now, what I recommend is this:

a) If you store usernames, consider a small mod to the RSS method to say, 'if username=X,do email address Y.'
Yes, it's a hack, but it would get proper attribution back in the RSS feed.

b) I thought I had a b, but I don't. So this b is superflorous.

/org/sweettweets/SweetTweets.cfc - Fix to a case sensitivity issue. I also reported the issue to the official SweetTweets project.

Last Updated: April 1, 2009 (BlogCFC 5.9.3.000) | Dan G. Switzer, II 
/client/addcomment.cfm
/client/contact.cfm
 * Errors are now stored in an array instead of a string

/client/Application.cfm
 * Simplified detection of currentPath, theFile, lylaFile and slideshowDir variables

/client/xmlrpc/xmlrpc.cfm
 * Fixed bug metaWeblog.getRecentPosts not retrieving entries do to change in return type of the new blog.getEntries() method
 * Fixed bug in metaWeblog.editPost when trying to edit a draft-based entry (which failed because you were not logged in as an admin)
 * Enhanced metaWeblog.editPost to convert some UTF & ASCII characters to their HTML entity (em-dashes and ellipses)
 * Added additional code to prevent errors in metaWeblog.editPost if username does not exist

/client/includes/udf.cfm
 * Added getRelativePath() function

/client/tags/getpods.cfm
 * Fixed pathing issue with podDir if "includes" folder has CF mapping

/client/admin/settings.cfm
 * Added red message box to top of page to inform user when the settings have changed and the blog cache cleared

/client/admin/index.cfm
 * Added red message box to top of page to inform user when the blog cache has been refreshed

/client/admin/imgwin.cfm
/client/admin/imgbrowse.cfm
 * Added fix to handle some pathing issues with images directory

/client/admin/entry_comments.cfm
 * New template for handling comments on entry page

/client/admin/entries.cfm
 * Added url.adminview to "View" links, which allow viewing of draft entries in Admin mode

/client/admin/entry.cfm
 * When changing a draft entry to being released, the posted date is updated with the current date/time
 * Added "Comments" tab for viewing entry-related comments
 * Added fix to handle some pathing issues with images directory

/client/tags/getmode.cfm
 * Added check for url.adminview, which sets params.releasedonly to false so draft messages can be viewed

/org/camden/blog/blog.cfc
 * Added htmlToPlainText() to variables being output in cfmail subject attributes--this replace entities such as an em-dash or ellipse with their plain text representation
 * The makeTitle() function now removes HTML entities from the title and replaces &amp; entity with the word "and"
 * Added trim() statement to code being passed to the codeRenderer.formatString() render--this prevents the formatter from adding <br /> before and after the code
 * The saveEntry() method now grabs a copy of the entry after updating and these values are used--we do this to make sure we have the correct "posted" value since the value in the arguments isn't always saved to the database (especially in XML-RPC calls)
 * Fixed title column to getEntries() query when returning an empty query--which is need for spryproxy.cfm to not throw errors when getting the related entries
 * Added cacheLink() function
 * Added code so that the saveEntry() updates the entry's link cache
 * Fixed issue in retrieving of entries where the value of params.releasedonly is assumed true if it exists

/org/camden/blog/utils.cfc
 * Added htmlToPlainText() method which is a utility helper for removing HTML from plain text e-mails--this is used to clean up the title of a blog entry be replacing entities so the subject in e-mails appears cleaner
 * Added fixUrl() which cleans up URLs and is used in the admin section

/org/delmore/coldfish.cfc
 * Updated HTML comment color to green from grey
 * Updated HTML tag color from blue to blue-green (which better differentiates between tag and attributes--since both were a very close blue)


