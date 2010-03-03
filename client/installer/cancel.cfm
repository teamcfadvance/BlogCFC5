
<cf_layout title="Installer Cancelled">

<p>
You have elected to stop the installer. Please read the BlogCFC installation instructions for how to manually install BlogCFC.
</p>

<p>
Your BlogCFC configuration file was updated to specify that the installer is no longer necessary. Also, this application has been disabled. It can not be run again.
</p>


</cf_layout>

<cfset setProfileString(application.iniFile, session.blogname, "installed", "yes")>
<cf_disableinstaller>
