LICENSE 
Copyright 2008-2009 Raymond Camden

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


Last Updated: March 30, 2009 (BlogCFC 5.9.2.005)
/org/camden/blog/blog.cfc - Var scope fix, and version. Support tweetbacks settings.
/org/camden/blog/blog.ini.cfm - Added the usetweetbacks settings.
/client/admin/settings.cfm - Added usetweetbacks setting support.
/client/Application.cfm - same as above.
/client/includes/main.properties and main_en_US.properties - support for tweetbacks
/client/includes/style.css - ditto
/client/index.cfm - ditto ditto

Last Updated: March 29, 2009 (BlogCFC 5.9.2.004)
/org/camden/blog/blog.cfc - Simple fix for OpenBD when no blog entries existed. If you don't use OpenBD, it is probably a good fix
to get anyway, although I doubt most folks _stay_ at having no entries.

Last Updated: February 23, 2009 (BlogCFC 5.9.2.003)
/client/trackbacks.cfm - extra protection from spammers (thx Ben Forta)
/client/search.cfm - support for new way we return entries
/client/index.cfm - ditto above
/client/tags/datacolnew.cfm and datatablenew.cfm - Kind of a hack, but new table/customtags for the new way we return entry data. Will refactor later.
/client/tags/getmode.cfm - support maxrows now that we support it in backend, and start
/client/pods/recent.cfm - support new way of returning entries, and always show last 5 (so if you haven't blogged for a while, it will still show content)
/client/admin/entries.cfm - ditto above
/client/admin/spryproxy.cfm - ditto above
/client/statsbyyear.cfm - initial draft of yearly stats
/org/camden/blog/blog.cfc - include author in rss feed for entries, and getEntries massively updated
/client/admin/entry.cfm - BlueDragon fix
/client/Application.cfm - ditto above
/client/index.cfm - Support for new Gravatar URLs
/org/camden/blog/blog.cfc - OpenBlueDragon fix
/org/hastings/locale/utils.cfc - ditto
/install/doc+pdf - mentions BD fixes

Last Updated: January 5, 2009 (BlogCFC 5.9.2.002)
/client/addcomment.cfm - fix non-boolean issue
/org/camden/blog/blog.cfc - just the version

Last Updated: December 10, 2008 (BlogCFC 5.9.2.001)
/client/cfformprotect/cffp.cfm and cffpVerify.cfc - fixed two issues for folks who install BlogCFC in a non-root folder.

Last Updated: December 10, 2008 (BlogCFC 5.9.2)
/install/accessblog.mdb - typo fix by David Brown
/org/camden/blog/blog.ini.cfm - property 'usecfp' - You must add this to your ini file. If true, uses CFFORMPROTECT (cfformprotect.riaforge.org)
/org/camden/blog/blog.cfc - Version, getComments supports filtering, blogNow marked private
/client/index.cfm - Did I somehow forget to check in the code that shows links for subscribing to a blog entry?
/client/googlesitemap.cfm - Now includes pages. Thanks to Edward Beckett
/client/Application.cfm - store useCFP in App scope
/client/includes/style.css - mods as described by http://rickosborne.org/blog/index.php/2008/12/05/blogcfc-users-stop-or-youll-go-blind/
/client/includes/layout.css - mods as described by http://rickosborne.org/blog/index.php/2008/12/05/blogcfc-users-stop-or-youll-go-blind/
/client/cfformprotect - cfformprotect code
/client/admin/comments.cfm - Simple filtering
/client/admin/notify.cfm - Fixes a bug with entry notifications
/client/addcomment.cfm - cfformprotect

Last Updated: September 10, 2008 (BlogCFC 5.9.1.002)
/org/camden/blog/blog.cfc - Fix bug where if a user edits an entry written by another user, they steal ownership
/org/camden/blog/blog.cfc - Oracle fix to getComment by Steven Tomcavage
/client/index.cfm, /client/includes/pod/subscribe.cfm - XSS attack fix, http://www.coldfusionjedi.com/forums/messages.cfm?threadid=4DF1ED1F-19B9-E658-9D12DBFBCA680CC6
/client/googlesitemap.cfm - fix by ScottP for blogs with no entries

Last Updated: August 13, 2008 (BlogCFC 5.9.1.001)
/client/stats.cfm - Oracle fixes (thanks to Steven Tomcavage)
/client/index.cfm - Forgot to use #application.rooturl# in podcasting support - thanks to Marion Bass
/org/camden/blog/blog.cfc - Include author name in emails
/install/mysql.sql - Changed the text fields in entries (body, morebody) to longtext. It may be a good idea for you to manually update your table.
/xmlrpc/xmlrpc.cfm - when deleting, clear cache
/client/tags/textarea.cfm - make the custom tag correctly handle a closing tag
/client/admin/page.cfm - Use the textarea custom tag. For those who modded textarea to use an RTE, it adds RTE to the page editor.

Last Updated: July 30, 2008 (BlogCFC 5.9.1)
Lots of changes. Please see update_591.txt for detailed instructions.

Last Updated: July 29, 2008 (BlogCFC 5.9.1 - Beta)
/client/includes/udf.cfm - isEmail updated for new TLDs and + emails (scott bennett)
/client/admin/entry.cfm - If you pick related entries and have an error, your picks are lost. Fix by Spencer Strickland.
/org/camden/blog/blog.cfc, /client/Application.cfm - You can approve comments via email (thanks Brian Kotek)
/client/search.cfm - When you search and match X, don't change the case when you highlight
/client/admin/moderate.cfm - fixes a bug identified here: http://blogcfc.riaforge.org/index.cfm?event=page.issueedit&issueid=51113EBD-C825-717F-5502AC1A0F6EAF79


Last Updated: July 16, 2008 (BlogCFC 5.9.1 - Beta)
Please see upgrade_591.txt.
/admin/entry.cfm - New podcasting form fields, support for manually setting enclosures
/admin/index.cfm - this file no longer is run after updating settings
/admin/settings.cfm - podcasting support
/includes/audio-player/* - podcasting
/includes/swfobject_modified.js
/index.cfm - podcasting support, use ", " for category list
/org/camden/blog.cfc, blog.ini.cfm - podcasting
/org/camden/blog.cfc - rss feeds, version 1, were borked - thanks Rob Brooks-Bilson
Note - Podcasting support provided by Brian Meloche!

Last Updated: July 1, 2008 (BlogCFC 5.9.1 - Alpha)
Please see upgrade_591.txt.
/admin/entries.cfm - When we link to front end, use the nice SES url.
/admin/index.cfm - Removed Google AdSense referal. When you update settings, I use text now, not a JS alert.
/includes/main.properties and main_en_US.properties - new strings
/tags/datatable.cfm - small mod to support change to /admin/entries.cfm
/tags/layout.cfm - changes for subscription
/addcomment.cfm - Changes to support one click comment kills
/addsub.cfm - Initial support for comment subscriptions
/Application.cfm - support one click comment kills
/index.cfm - support comment subs
/org/camden/blog - Support for stuff above
/admin/entries.cfm - fixed a silly space after N entries.

Last Updated: June 6, 2008 (BlogCFC 5.9.004)
/org/delmore/coldfish.cfc - ColdFish should work in MX and MX7 now.
/org/camden/blog.cfc - just the version
/client/admin/category.cfm - Mod by Adam Tuttle, small fixes to the forms
/client/includes/pods/feed.cfm - use CFBloggers for default feed, not MXNA

Last Updated: May 22, 2008 (BlogCFC 5.9.003)
/client/index.cfm - right link for technorati
/client/rss.cfm - handle ensuring each cat in a list (if supplied) is 35 chars long
/client/Application.cfm - load ColdFish
/org/delmore/coldfish.cfc - New code formatting by ColdFish (coldfish.riaforge.org) by Jason Delmore
/org/hastings/* - various var scope fixes
/org/camden/blog.cfc, pods.cfc, render/renderer.cfc - var scope fixes, support for ColdFish

Last Updated: January 14, 2008 (BlogCFC 5.9.002)
/client/admin/entry.cfm - another date fix
/org/camden/blog/blog.cfc - additional xmlformatting

Last Updated: November 19, 2007 (BlogCFC 5.9.001)
NOTE - Many of these fixes thanks to Dan Switzer
/client/admin/entry.cfm - fix to Spry code
/client/includes/pod.cfm and recentcomments.cfm - missing cfsetting
/client/rss.cfm and search.cfm - don't show unreleased items.
/org/camden/blog/blog.cfc - just the version

Last Updated: October 12, 2007 (BlogCFC 5.9)

Note - for this release, I decided to stop updating the headers in the files. It was redundant when I'm providing
the information here, and while I see merit in it (makes it easy when editing the file to see the history), I 
decided I'd skip that since BlogCFC 6 will have new files. 

/client/addcomment.cfm - Default http:// in the URL. For times, use BlogCFC's offset time. 
/client/admin/index.cfm - Two small text changes.
/client/admin/pod.cfm, podform.cfm, pods.cfm - Scott P's changes to allow you to edit pods
/client/admin/settings.cfm - Increase maxlength on users field.
/client/admin/spryproxy.cfm - specify UTF-8
/client/includes/admin.css - made some form fields 100% wide. To me - makes editing easier.
/client/includes/pod.cfm - add a timeout to the CFHTTP
/client/includes/style.css - few small changes. Only one I remember is the Mac font fix. 
/client/rss.cfm - specify UTF-8
/client/search.cfm - remove debug code, fix cgi code
/client/tags/getmode.cfm - Don't restrict to last 30 days, and handle 'large url var' issue.
/client/tags/scopecache.cfm - Fix the damn 'dependancies' error that shouldn't exist.
/client/install/mysql.sql - updated install sql
/org/camden/blog/ping.cfc, ping7.cfc, ping8.cfc - New ping support. In CF8, we use CFTHREAD to fire the pings.
/org/camden/blog/blog.cfc - Detect if cf8, load right ping, fix in generateRSS for format of times, run <code> blocks before Render, 
							allow for verify via email, getNumberUnmoderated fixed to get # for blog
/org/camden/blog/render/render.cfm - Trim results, this was someone else's idea - I believe Scott P.
/client/admin/entry.cfm - Fix a bug with dates (again), make the table wider.
/client/includes/spry/* - Minimized, 1.6 versions
/client/admin/subscribers.cfm - Let admin verify people
/client/tags/datatable.cfm - support for above
/client/admin/entries.cfm - On delete, clear cache
/client/admin/settings.cfm - Handle cases where a login attempt sets username/password in the form scope
/client/stats.cfm - Added an average views per entry value
/client/includes/main.properties - For above
/client/includes/main_en_US.properties - For above (and added stuff for contact form)
/org/camden/blog/ping7.cfc - wrap the cfhttp with a try/catch. Only done for bare pings.
/org/camden/blog/blog.cfc - Use Brian Kotek's code to allow IP wildcards for spam blocking.

Removed: sex, lesbian, porn, from the spam block list. I felt these words were a bit too vague to be included.

/client/contact.cfm - New contact form
/client/tags/layout.cfm - new URLs for me, link to contact.
/client/xmlrpc/xmlrpc.cfm - Scott P's tweak


----------------------------------------------------------------
Last Updated:  (BlogCFC 5.8.001)
/org/camden/blog/render/render.cfc - CF8 compatability fix
/client/includes/pods/recent.cfm - Future entries were showing up.
/org/camden/blog/blog.ini.cfm - Nothingimportant - just changed to mysql for my local env.
/org/camden/blog/blog.cfc - Version

Last Updated: May 18, 2007 (BlogCFC 5.8)
/org/captcha/* - Please replace all captcha files with these new ones. Updates described at Lyla Captcha site: http://lyla.maestropublishing.com/
/client/includes/captcha.xml - support for above
/org/camden/blog/blog.cfc - Category passed ot getEntries can be a list. New approveComment method.
/client/tags/layout.cfm - support category as a list.
/client/rss.cfm - support category as a list.
/client/index.cfm - bug where 11 items showed up instead of 11
/client/admin/moderate.cfm - When approving a comment, use approveComment. Also, it doesn't make sense to show the IP of the sender, so we just say Moderated.
/client/admin/entry.cfm - delete cookies on cancel

I updated the docs to talk about the new "blended" RSS/front page view. It lets you display N categories at once.

Last Updated: April 20, 2007 (BlogCFC 5.7.002)
/client/error.cfm - I left a OR 1 in. Thanks Todd! 
/org/camden/blog/blog.cfc - Just the version

Last pdated: April 19, 2007 (BlogCFC 5.7.001)
/client/rss.cfm - Major performance updates in regards to aggregators. Code written by Rob Wilkerson
/client/search.cfm - Changes to how search results are displayed:
HTML is removed.
If searches are found in the title, it is highlighted.
The excerpt now shows the portion of the entry that has the search terms.
The last two were ideas I got from Adam Podolnick.
/org/camden/blog/blog.cfc - just version

Last Updated: April 13, 2007 (BlogCFC 5.7)

/client/admin/entry.cfm - When editing an existing entry, do not use JavaScript to store text. This was done
to fix a bug where you would click to edit, not save, and then click add new entry and see the text from the
other entry. 

/client/admin/moderate.cfm - Send email properly for moderated comments.
/client/admin/pod.cfm, podform.cfm, pods.cfm, showpods.cfm - Pod Manager from Scott Pinkston
/client/admin/settings.cfm - simple label change

/client/includes/udf.cfm - fix to regex in replacelinks 
/client/includes/ - All locale files updated.

/client/tags/adminlayout.cfm - link to Pod Manager
/client/tags/getmode.cfm - Now passes a flag to hide unreleased/future entries from home page. Fixes a bug where admin
get see a post and it gets added to cache.
/client/tags/getpods.cfm - Pod Manager by Scott P
/client/tags/layout.cfm - use PM by Scott P

/client/xmlrpc/xmlrpc.cfm - Use cfloginuser so remote clients can see unreleased/future entries.

/client/addcomment.cfm - Don't mail (except to admin) if comment moderation is on.
/client/Application.cfm - mainly comments, but also added Scott P's pod manager cfc 
/client/stats.cfm - use 50/50 column widths

/org/camden/blog/blog.cfc - 
Lots of small fixes. One important one is that BlogCFC will send email when you save an entry if you keep
Send Email turned on. This was mainly done for folks who update and release an entry, but keep it in mind if you fix
a typo.
/org/camden/blog/pod.cfc - Pod Manager added 

/install/mysql.sql - Correction to indexes

Last Updated: March 9, 2007 (BlogCFC 5.6.002)
/org/camden/blog/utils.cfc - mail function support bcc. I don't use it - but it supports it.
/org/camden/blog/blog.cfc - just the version
/client/admin/filemanager.cfm - security fix 
/client/admin/Application.cfm - security fix for bruteforce attack

Last Updated: March 2, 2007 (BlogCFC 5.6.001)
/stats.cfm - fix a bug that occured in MS Access. The bug was that Access sucks.
/admin/entry.cfm - fix an issue where the cookies didn't seem to delete. Fix an issue where you could save from Preview w/o picking a category
/org/camden/blog/blog.cfc - version only

Last Updated: February 28, 2007 (BlogCFC 5.6)
/client/admin/entry.cfm - Now uses a cookie to save entry data. This is useful in case of a browser crash.
/client/admin/index.cfm - show the top entries from past 7 days
/client/admin/notify.cfm - Make getEntry not log (helps keep Views down)
/client/admin/slideshow.cfm - fix to finding the right folder
/client/includes/pods/archives.cfm - add noindex/nofollow - Thanks Rob Brooks-Bilson
/client/includes/pods/rss.cfm - ditto above
/client/includes/pods/search.cfm - point to new search page
/client/includes/pod/subscribe.cfm - return a msg. Someone else did this fix. I forget who.
/client/includes - The properties files have been updated. Copy them over. Also, Martin B. supplied us with a German file.
/client/tags/datatable.cfm - removed dupe cfparam tag
/client/tags/layout.cfm - don't log the view more than once a session
/client/tags/trackbackemail.cfm - don't log the view
/client/addcomment.cfm - ditto
/client/Application.cfm - session struct to remmeber what you saw.
/client/index.cfm - 2 small changes, one is a Digg link
/client/print.cfm - don't log the view
/client/search.cfm - New Search view
/client/send.cfm - don't log view
/client/stats.cfm - top commenters support
/client/trackback.cfm - don't log view
/org/camden/blog/blog.cfc - 4-5 very small bug fixes
/install/mysql.sql - MySQL code updated with Indexes. Thank you Ben Forta. There was NO excuse for me not doing this earlier. Next rev will have the same in the SQL Server code.

Last Updated: December 26, 2006 (BlogCFC 5.5.1)
/org/camden/blog - just version update 
/client/index.cfm - gravatar fix, thanks Pete F
/client/admin/entry.cfm - International dates failed if you had an error or used preview. They work now. I swear.


Last Updated: December 14, 2006 (BlogCFC 5.5.006)

Please note that the following changes were created to help support folks who 
want to run multiple, virtual blogs. They allow you to disable filebrowsing 
(which could be useful for folks who don't trust their blog editors), disable
the settings, and specify an imageoot. The imageroot is a folder name, like foo,
or 2, or whatever. Any image uploaded in the blog editor will be put in images/foo.
Any slideshow created will be in images/slideshows/foo. Why? Again - imagine you have
multiple virtual blogs. The imageroot prop will let you specify a particular subfolder 
for the virtual blog.

/org/camden/blog/slideshow.cfc - New methods to store slideshow dir
/org/camden/blog/blog.cfc - new properties
/org/camden/blog/blog.ini.cfm - new properties. Please see the docs for what they mean. The new
properties are filebrowse, settings, and imageroot
/slideshow.cfm - support or getting image root from cfc
/Application.cfm - changes to slideshowdir, imageroot
/tags/adminlayout.cfm - support the new props 
/admin/slideshow.cfm - ditto
/admin/slideshows.cfm - ditto
/admin/imgwin.cfm - use imageroot 
/admin/imgbrowse.cfm - use imageroot
/admin/settings.cfm - support new props 
/admin/filemanager.cfm - support prop 
/admin/entry.cfm - support imageroot prop


Last Updated: December 7, 2006 (BlogCFC 5.5.005)
Please note 90% of the comment moderation support was done by Trent Richardson!

/admin/comment.cfm - comment mod support
/admin/moderate.cfm - ditto
/includes/main.properties, main_en_us.properties - ditto
/admin/settings.cfm - ditto
/tags/adminlayout.cfm - ditto
/Application.cfm - ditto
/index.cfm - ditto
/stats.cfm - ditto
/org/camden/blog/blog.cfc - ditto (plus version update)
/org/camdenb/blog/blog.ini.cfm - Added the moderate=BOOL property. You MUST do this yourself.
/install - Docs updated to mention comment moderation.
/install - All DB scripts

DATABASE UPDATE: Note to existing users. You must add the moderated column to your comments table. Then update all your old comments ot have moderated=1/true. 

Last Updated: November 30, 2006 (BlogCFC 5.5.004)
/admin/entry.cfm - Date locale fix, changed tab name, support for Image Browser
/admin/filemanager.cfm - moved UDF to udfs.cfm
/admin/imagebrowse.cfm - New image browser for editing.
/includes/tabber.js and tab.css added
/admin/entry.cfm - use tabs, Aaron West added ability to resend entries for old posts
/includes/pods/subscribe.cfm - Fix to JS
/includes/admin_popup.css - CSS used by imagebrowse.cfm popup
/includes/udf.cfm - Moved a UDF into it.
/includes/tags/datatable.cfm - empty data fix
/xmlrpc/xmlrpc.cfm - Yet another fix for yet another XMLRPC client.
/googlesitemap.cfm - Missing cfsetting at end of file.
/index.cfm - big change to cut down on white space generated by the index file.
/org/camden/blog/blog.cfc - I forgot to mention this back in 5.5.003, but makeLink caches now. Version update.
/org/hastings/locale/utils.cfc - Utility function to translate Java locales to CF6 locales. Thanks to Tom Jordhal for this.

Last Updated: October 31, 2006 (BlogCFC 5.5.003)
/client/admin/entry.cfm - Fix an issue where if you add an entry with an enclosure and your session times out, 
then we have to deal with it. We deal with it by removing your enclosure and adding a special error to let you 
know what happaned. Basically you just reupload the file. 

/client/admin/entry.cfm - We now prompt you if you want to send an email to subscribers for the blog entry. This ONLY
works with new entries, and defaults to true.

/client/admin/login.cfm - See above.
/client/addcomment.cfm - Don't throw error if form.captcha doesn't exist. Stops dumb spammers. 
/client/send.cfm - support blog titles that include <> characters in them. Update to last fix.
/client/xmlrpc/xmlrpc.cfc - remove cflogs, support for Captivate

/org/camden/blog/blog.cfc - support for send email

/install/sqlserver.sql - removed the darn null character that popped in again

/client/showCaptcha.cfm defaults url.hasreference

Last Updated: October 12, 2006 (BlogCFC 5.5.002)
/client/admin/index.cfm - htmlEditFormat the blog title
/client/tags/adminlayout.cfm - ditto above
/client/tags/layout.cfm - ditto above
/client/send.cfm - ditto above
/org/camden/blog/blog.cfc - ditto above
/xmlrpc/xmlrpc.cfm - fix for categories
/org/hastings/locale/utils.cfc - two fixes related to BlueDragon

Last Updated: September 26, 2006 (BlogCFC 5.5.001)
/org/camden/blog/blog.cfc - RSS category fix

Last Updated: September 26, 2006 (BlogCFC 5.5 / RC again)
/org/hastings/locale: Both CFCs updated. BlogCFC will now attempt to load your locale file, 
and if it can't find it, will load main.properties. This means you can pick a locale and NOT write
a properties file for it. Thanks to Paul Hastings. You will also get an error now if you specify
a bad locale.

/client/includes/main.properties - new core properties file loaded as a last resort.

Last Updated: September 23, 2006 (BlogCFC 5.5 / RC)
/org/camden/blog/blog.cfc - change render function used for dynamic render CFCs 
/org/camden/blog/render/render.cfc - ditto above
/org/camden/blog/render/amazonbox.cfc - initial check in
/install/ - Docs updated

Last Updated: September 17, 2006 (BlogCFC 5.5 / Beta 1)
/client/includes/admin.css - small changes by Ray in prep for changes by Scott. Scott made his changes for the logo
/client/tags/adminlayout.cfm - changes by Scott.
/client/includes/pods: feed.cfm and pages.cfm, new pods, not included in layout.cfm
/install/sqlserver.sql - the dang null char got in again

Last Updated: September 17, 2006 (BlogCFC 5.5 / Beta 1)
/client/includes/captcha.xml - simpler captcha, thanks to Charlie Arehart
/client/index.cfm - change how categories are handled 
/org/camden/blog/blog.cfc - ditto, fixes bug with commas in category names
/client/rss.cfm - ditto

Last Updated: September 15, 2006 (BlogCFC 5.5 / Beta 1)
/client/admin/entry.cfm - upload image support
/client/admin/imgwin.cfm - ditto
/client/tags/textarea.cfm - ditto
/client/index.cfm - fix for pagination

Last Updated: September 14, 2006 (BlogCFC 5.5 / Beta 1)
/client/admin/filemanager.cfm - allow file uploads
/client/admin/entry.cfm - don't throw error if you try to add new cat with same name as old cat

Last Updated: September 14, 2006 (BlogCFC 5.5 / Beta 1)
/client/admin/updatepassword.cfm - new file
/client/tag/adminlayout.cfm - point to new file
/client/includes/admin.css - new style. that's right - I got style now baby
XMLRPC updates
/client/images/ multiple new images
/client/admin/filemanager.cfm - First draft. Can browse, download, delete.

Last Updated: September 5, 2006 (BlogCFC 5.5 / Beta 1)
Yes, I went from 5.2 to 5.5
/client/slideshow.cfm - Uses metadata for slideshow titles + captions
/client/addcomment.cfm - Show IP of person adding comment, check rememberMe and subscribe form values for being boolean
/client/admin/index.cfm - Use JS alert to let folks know when settings are updated
/client/admin/slideshows.cfm + slideshow.cfm - new files - support to edit slideshows
/client/admin/settings.cfm - forgotten keys + new keys
/client/includes/pods/search.cfm - Use a button for search
/client/includes/pods/tagcloud.cfm - use SES for links
/client/includes/main_en_US.properties - new keys
/client/tags/adminlayout.cfm - reorganized links a bit
/client/tags/datatable.cfm - low level hack - ignore it ;)
/client/tags/layout.cfm - just a white space change 
/client/tag/parseses.cfm - catch issues with bad cat names
/client/xmlrpc/* - Initial XMLRPC support. NOT COMPLETE NOT SECURE!
/org/camden/blog/slideshow.cfc - initial checkin
/org/camden/blog/blog.cfc - version change

Last Updated: August 24, 2006 (BlogCFC 5.2 (Alpha 2))
/client/includes/main_en_US - few new keys
/client/includes/pod/recentcomments.cfm - missing a few localized strings
/client/Application.cfm - support Deanna's u/p changes
/org/camdenb/blog/blog.cfc, blog.ini.cfm, page.cfc, textblock.cfc - Deanna's Oracle support and U/P support in queries
/install/ - Oracle scrips from Deanna 
/install/ - Doc updates
/client/stats.cfm - use U/P for queries
/client/addcomment.cfm - slight design tweak by Scott Stroz
/client/send.cfm - Scott made the send.cfm file CSS-ized.
/includes/style.css - see above 2 lines

Last Updated: August 22, 2006 (BlogCFC 5.2 (Alpha 1 again))
/tags/layout.cfm - frame buster code and use tag cloud pod
/includes/pods/tagcloud.cfm - Tag Cloud support by Stephen Erat

Last Updated: August 16, 2006 (BlogCFC 5.2 (Alpha 1))
/client/slideshow.cfm - Slide show support (see docs in final release)
/client/unsubscribe.cfm,/client/trackbacks.cfm,/client/stats.cfm,/client/send.cfm,/client/print.cfm,/client/addcomment.cfm,/client/confirmsubscription.cfm,/client/error.cfm,/client/index.cfm,/client/Application.cfm - All support for RB()
/client/stats.cfm - For subscribers, the total wasn't the total verified
/client/index.cfm - use of icons and other small mods
/client/includes/main_en_US - new Views key
/org/hastings/locale - Added support for rb()
/org/camden/blog/utils.cfc - Support for rb()
/org/camden/blog/blog.cfc - Initial render support, small fixes as well
/org/camden/blog/render/* -> Initial render pods
/client/send.cfm - Use captcha for send requests 
/client/includes/subscribe.cfm - Dynamic field name (from Andy Jarret)

Last Updated: August 1, 2006 (BlogCFC 5.1.004)
/admin/entry.cfm - Fixed an issue with related entries 
/includes/main_en_US.properties - new value
/addentry.cfm - Cancel confirmation
/org/camden/blog/blog.cfc - New returnType (just made it more precise), new version #
/install/skins - New skins by Scott Stroz
/includes/layout.css - New liquid layout. You can find the old fixed one in install/skins
/install/BlogCFC - Updates by Lola J. Lee Beno. She cleaned up the text a bit. I added some text about Scott's skins.
/install/mysql.sql - user reported some missing lines from older install file. I'm not sure why mysql-front doesn't include them anymore, 
but I coped them in.
/includes/pod/calendar.cfm - Bug with SES urls in first row of calendar
/tags/adminlayout.cfm - Scott P suggested adding the blogname to the layout. 

Last Updated: July 21, 2006 (BlogCFC 5.1.003)
/org/camden/blog/blog.cfc - removeUnverifiedSubscribers added
/admin/sbuscribers.cfm - button to let you remove all the unsubscribed people at once
/includes/udf.cfm - update to replaceLinks to let you specify max length of links. Thanks to Charlie for the idea.
/includes/pods/recentcomments.cfm - use the feature above to limit length of links
/admin/entry.cfm - Added editing instructions.

Last Updated: July 16, 2006 (BlogCFC 5.1.002)
Wrong title, and typo on /client/admin/textblocks.cfm - Thanks Steve Elliot!
/client/admin/spryproxy.cfm: Two fixes to correct differneces under BlueDragon.Net. Thank you to Charlie Arehart for the help!
/org/camden/blog/blog.cfc - two missing var statements, missing cfsqltype
/client/admin/entry.cfm - don't throw an error if you preview w/o picking a category
/client/admin/entry.cfm - fix JavaScript error in IE


Last Updated: July 15, 2006 (BlogCFC 5.1.001)
/client/page.cfm - new logic to get /..... part
MySQL db script had "verified" on users, not subscribers.
/client/index.cfm - a "test" msg was left in for No Entry cases. I blame Microsoft.
/client/index.cfm - in the same area, part of the output wasn't cfoutputted
/org/camden/blog/blog.cfc - I forgot to use the variables scope when referring to the utils component. One line did cfset "" instead of cfreturn "". 
Thanks Sarge for finding these.


Last Updated: July 14, 2006 (BlogCFC 5.1)
DB CHANGE: Add verified as a bit to the tblblogsubscribers table. You should write
a quick script to update your current subscribers with verified=1. If you do not, they will 
not get email.

DB CHANGE: New table, tblblogpages. Columns:
	id, nvarchar 35, primary key
	title, nvarchar 255
	alias, nvarchar 100
	body, ntext,
	blog, nvarchar 50

DB CHANGE: New table, tblblogtextblocks. Columns:
	id, nvarchar 35, primary key
	label, nvarchar 255,
	body, ntext,
	blog, nvarchar 50
	
/client/rss.cfm - Cache the main RSS feed	
/tags/datatable.cfm - support for url format, support for static data
/org/camden/blog/utils.cfc - added mail()
/org/camden/blog/blog.cfc - support for new subscriber logic
/client/admin/comments.cfm - show entry title 
/client/admin/mailsubscribers.cfm - new file
/client/admin/subscribers.cfm - show verified subscribers
/client/includes/pods/subscribe.cfm - send email on subscribe
/client/includes/main_en_US.propertes - few new strings
/client/confirmsubscription.cfm - new files
/client/send.cfm - use new Mail() function
/client/admin/spryproxy.cfm - new file
/client/includes/spry/* - new files. NOTE - THESE FILES ARE FROM ADOBE AND HAVE THEIR OWN LICENSE!
/client/admin/entry.cfm - New Spry based related entries logic.
/tags/adminlayout.cfm - new links
/client/admin/entries.cfm, comments.cfm - show a link

Last Updated: July 7, 2006 (BlogCFC 5.007)
/client/includes/pod/calendar.cfm - forgot to SES the first row of dates. Thanks to Lucas for pointing it out.
/client/includes/admin.cff - Charlie A suggested a slight mod to CSS used for entry editing preview.
/org/camden/blog/blog.cfc - I only changed the version #

Last Updated: June 25, 2006 (BlogCFC 5.006)
/org/camden/blog/blog.cfc, getEntry was updated (as well as /client/admin/entry.cfm) to not log Views during editing. Thanks to Jeff C for pointing this out.
/client/admin/entry.cfm - updated to preserve html in edits
/client/send.cfm - Send wasn't using mail s/u/p like blog.cfc does
/client/index.cfm - More entries linked fixed for sites where blog wasn't root

Last Updated: June 9, 2006 (BlogCFC 5.005)
/org/camden/blog/blog.cfc - Changed access attribute on a few methods (thanks Pete F)
/client/includes/pods/recentcomments.cfm - bug with cropped html
Documentation updates
/client/Application.cfm (minor sec fix, thanks Pete F)

Last Updated: June 2, 2006 (BlogCFC 5.004)
User pointed out the code that got related entries in the admin didn't filter by blog
Doc update (nothing worth noting for current users)

Last Updated: May 12, 2006 (BlogCFC 5.003)
Two security issues pointed out by Pete Freitag. Fixes in getComments/getTrackbacks

Last Updated: May 12, 2006 (BlogCFC 5.002)
/client/admin/entry.cfm - removed an extra line that was accidently duplicated 
/org/camden/blog.cfc - fixes to getComments and getRecentComments
/tag/adminlayout.cfm - add link to stats.cfm
/admin/index.cfm - just added the blog title 
/includes/main_en_us.properties - new translation
/client/stats.cfm - fix for gettopviews and added gettotalviews
	
Last Updated: May 12, 2006 (BlogCFC 5)

CAPTCHA support does not work on BlueDragon.Net.

Files: Pretty much every file changed.
Database changes include the following:

tblBlogCategories:
	categoryalias(nvarchar/50) added
	
tblBlogEntries:
	views(int) added - You must set all old views to 0
	released(bit) added - You must set your old data to released=1 with a quick query
	mailed(bit) added - You can set the old ones to true, but you don't need to)

tblBlogEntriesRelated: (New table)
	entryid (nvarchar/35)
	relatedid (nvarchar/35)

tblUsers:
	name(nvarchar/50) added - You should add your name here, or your code name. Or whatever you go by.