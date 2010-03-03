
<cf_layout title="Installation Complete!">

<p>
Shiny! Your BlogCFC install is now complete. You can view it in all it's shining glory here:
</p>

<cfoutput>
<p>
<a href="#session.blogurl#">#session.blogurl#</a>
</p>
</cfoutput>

<p>
As a reminder, this installer will now be disabled.
</p>

</cf_layout>

<cfset setProfileString(application.iniFile, session.blogname, "installed", "yes")>
<cf_disableinstaller>
