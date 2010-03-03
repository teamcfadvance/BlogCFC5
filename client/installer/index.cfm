<cf_layout title="Welcome!">

<p>
Welcome to the BlogCFC Installer. This application will attempt to setup BlogCFC so you can immediately begin using it. Before getting started, there are a few things you should know:
</p>

<p>
First, the installer will not be able to create the DSN or database for you. You need to ensure your DSN is created and it points to a valid DSN.
</>

<p>
After the installer creates or selects the DSN, it will then attempt to run the install SQL script. If you have existing tables in the database this might create a conflict. In general you should install BlogCFC into an empty database.
</p>

<p>
The last thing the installer will do is prompt you for some basic settings, like your email address, the name of the blog, etc. Once done with this step the installer is going to edit itself so it cannot be run again. <b>This is intentional.</b> Instructions
on how to run the installer again may be found in the core BlogCFC documentation.
</p>

<p>
One final note - if you don't want to use the installer at all, you will be given a choice to end the process immediately.
</p>

<p>
<form action="step1.cfm" method="post">
<input type="submit" value="Let's Get Started!">
</form>
</p>

</cf_layout>