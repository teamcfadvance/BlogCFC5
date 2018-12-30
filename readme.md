**Updates to BlogCFC**


**2018/12/28 Update 2**: 

* Merged in my own BlogCFC Extension. 
    * Created download tracker code for tracking and reporting on enclosure downloads
    * Added a tableprefix= config property.  This is if you want to add a prefix to the table name and will be appended to all queries.  If you use this, then you won't be able to use the SQL Generate scripts or the install/update package.
    * Added BlogDBName argument to blog.cfc init.  This refers to name of the blog in the database and allows you to use different db names in the config file vs the database.
    * Added isAvailable argument to blog.cfc entryexists() and getEntry(). If passed in as true, will allow an entry to exist even if it is not available yet
    * Tweaked RSS 2.0 generation to add media tags; I think this supports podcasting platforms other than iTunes.
    * Added a bunch more functions to utils--don't remember what they are all used for.

**ToDo**:
I still need to add scripts for the relevant new tables info.

**2018/12/28**: 

Since the project hasn't had an update in ages, I probably won't bother to try to do PRs back to the main branch, but decided to stick with BlogCFC for the moment for my own personal blog.

My instructions including table modifications on updating the database from 5.9.2.002 to the current at located in: 

    install/Upgrade5.9.2.00.2To5.9.8.001.txt 
        
I use SQL Server, so that is all that you're find.


I added a new property to the `blog.ini.cfm`: 


    maxentriesadmin=10
    
This allows you to show a different number of posts in the client UI compare to a different number of posts in the admin.


