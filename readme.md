**Updates to BlogCFC**

**2018/12/28**: 

Since the project hasn't had an update in ages, I probably won't bother to try to do PRs back to the main branch, but decided to stick with BlogCFC for the moment for my own personal blog.

My instructions including table modifications on updating the database from 5.9.2.002 to the current at located in: 

    install/Upgrade5.9.2.00.2To5.9.8.001.txt 
        
I use SQL Server, so that is all that you're find.


I added a new property to the `blog.ini.cfm`: 


    maxentriesadmin=10
    
This allows you to show a different number of posts in the client UI compare to a different number of posts in the admin.