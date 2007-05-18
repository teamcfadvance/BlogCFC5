<!---
Copyright: (c) 2007 Maestro Publishing, LLC
Author: Peter J. Farrell (pjf@maestropublishing.com)
License:
Copyright 2007 Maestro Publishing, LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

$Id: captchaServiceConfigBean.cfc 6056 2007-05-13 20:16:22Z pfarrell $
--->
<cfcomponent
	displayname="captchaServiceConfigBean"
	output="false"
	hint="A bean which models the captchaServiceConfigBean form.">

	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="captchaServiceConfigBean" output="false">
		<cfargument name="outputDirectory" type="string" required="false" default="img/" />
		<cfargument name="outputDirectoryIsRelative" type="boolean" required="false" default="TRUE" />
		<cfargument name="hashValidPeriod" type="numeric" required="false" default="1800000" />
		<cfargument name="jpegQuality" type="numeric" required="false" default="0.90" />
		<cfargument name="jpegUseBaseline" type="boolean" required="false" default="TRUE" />
		<cfargument name="useAntiAlias" type="boolean" required="false" default="TRUE" />
		<cfargument name="randStrType" type="string" required="false" default="alpha" />
		<cfargument name="randStrLen" type="numeric" required="false" default="6" />
		<cfargument name="width" type="numeric" required="false" default="250" />
		<cfargument name="height" type="numeric" required="false" default="75" />
		<cfargument name="fontsize" type="numeric" required="false" default="30" />
		<cfargument name="leftOffset" type="numeric" required="false" default="20" />
		<cfargument name="shearXRange" type="numeric" required="false" default="25" />
		<cfargument name="shearYRange" type="numeric" required="false" default="25" />
		<cfargument name="fontColor" type="string" required="false" default="light" />
		<cfargument name="backgroundColor" type="string" required="false" default="dark" />
		<cfargument name="useGradientBackground" type="boolean" required="false" default="TRUE" />
		<cfargument name="backgroundColorUseCyclic" type="boolean" required="false" default="TRUE" />
		<cfargument name="useOvals" type="boolean" required="false" default="TRUE" />
		<cfargument name="ovalColor" type="string" required="false" default="medium" />
		<cfargument name="ovalUseTransparency" type="boolean" required="false" default="TRUE" />
		<cfargument name="minOvals" type="numeric" required="false" default="15" />
		<cfargument name="maxOvals" type="numeric" required="false" default="20" />
		<cfargument name="useBackgroundLines" type="boolean" required="false" default="TRUE" />
		<cfargument name="backgroundLineColor" type="string" required="false" default="medium" />
		<cfargument name="backgroundLineUseTransparency" type="boolean" required="false" default="TRUE" />
		<cfargument name="backgroundMinLines" type="numeric" required="false" default="5" />
		<cfargument name="backgroundMaxLines" type="numeric" required="false" default="10" />
		<cfargument name="useForegroundLines" type="boolean" required="false" default="TRUE" />
		<cfargument name="foregroundlineColor" type="string" required="false" default="light" />
		<cfargument name="foregroundLineUseTransparency" type="boolean" required="false" default="TRUE" />
		<cfargument name="foregroundMinLines" type="numeric" required="false" default="5" />
		<cfargument name="foregroundMaxLines" type="numeric" required="false" default="10" />
		<cfargument name="definedFonts" type="array" required="false" default="#ArrayNew(1)#" />

		<cfscript>
			// run setters
			setOutputDirectory(arguments.outputDirectory);
			setOutputDirectoryIsRelative(arguments.outputDirectoryIsRelative);
			setHashValidPeriod(arguments.hashValidPeriod);
			setJpegQuality(arguments.jpegQuality);
			setJpegUseBaseline(arguments.jpegUseBaseline);
			setUseAntiAlias(arguments.useAntiAlias);
			setRandStrType(arguments.randStrType);
			setRandStrLen(arguments.randStrLen);
			setWidth(arguments.width);
			setHeight(arguments.height);
			setFontsize(arguments.fontsize);
			setLeftOffset(arguments.leftOffset);
			setShearXRange(arguments.shearXRange);
			setShearYRange(arguments.shearYRange);
			setFontColor(arguments.fontColor);
			setBackgroundColor(arguments.backgroundColor);
			setUseGradientBackground(arguments.useGradientBackground);
			setBackgroundColorUseCyclic(arguments.backgroundColorUseCyclic);
			setUseOvals(arguments.useOvals);
			setOvalColor(arguments.ovalColor);
			setOvalUseTransparency(arguments.ovalUseTransparency);
			setMinOvals(arguments.minOvals);
			setMaxOvals(arguments.maxOvals);
			setUseBackgroundLines(arguments.useBackgroundLines);
			setBackgroundLineColor(arguments.backgroundLineColor);
			setBackgroundLineUseTransparency(arguments.backgroundLineUseTransparency);
			setBackgroundMinLines(arguments.backgroundMinLines);
			setBackgroundMaxLines(arguments.backgroundMaxLines);
			setUseForegroundLines(arguments.useForegroundLines);
			setForegroundlineColor(arguments.foregroundlineColor);
			setForegroundLineUseTransparency(arguments.foregroundLineUseTransparency);
			setForegroundMinLines(arguments.foregroundMinLines);
			setForegroundMaxLines(arguments.foregroundMaxLines);
			setDefinedFonts(arguments.definedFonts);
		</cfscript>

		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="captchaServiceConfigBean" output="false">
		<cfargument name="memento" type="struct" required="true"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>
	<cffunction name="getMemento" access="public"returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setOutputDirectory" access="private" returntype="void" output="false">
		<cfargument name="outputDirectory" type="string" required="true" />
		<cfset variables.instance.outputDirectory = trim(arguments.outputDirectory) />
	</cffunction>
	<cffunction name="getOutputDirectory" access="public" returntype="string" output="false">
		<cfreturn variables.instance.outputDirectory />
	</cffunction>

	<cffunction name="setOutputDirectoryIsRelative" access="private" returntype="void" output="false">
		<cfargument name="outputDirectoryIsRelative" type="boolean" required="true" />
		<cfset variables.instance.outputDirectoryIsRelative = trim(arguments.outputDirectoryIsRelative) />
	</cffunction>
	<cffunction name="getOutputDirectoryIsRelative" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.outputDirectoryIsRelative />
	</cffunction>
	
	<cffunction name="setHashValidPeriod" access="private" returntype="void" output="false">
		<cfargument name="hashValidPeriod" type="numeric" required="true" />
		<cfset variables.instance.hashValidPeriod = trim(arguments.hashValidPeriod) />
	</cffunction>
	<cffunction name="getHashValidPeriod" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.hashValidPeriod />
	</cffunction>

	<cffunction name="setJpegQuality" access="private" returntype="void" output="false">
		<cfargument name="jpegQuality" type="numeric" required="true" />
		<cfset variables.instance.jpegQuality = trim(arguments.jpegQuality) />
	</cffunction>
	<cffunction name="getJpegQuality" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.jpegQuality />
	</cffunction>

	<cffunction name="setJpegUseBaseline" access="private" returntype="void" output="false">
		<cfargument name="jpegUseBaseline" type="boolean" required="true" />
		<cfset variables.instance.jpegUseBaseline = trim(arguments.jpegUseBaseline) />
	</cffunction>
	<cffunction name="getJpegUseBaseline" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.jpegUseBaseline />
	</cffunction>

	<cffunction name="setUseAntiAlias" access="private" returntype="void" output="false">
		<cfargument name="useAntiAlias" type="boolean" required="true" />
		<cfset variables.instance.useAntiAlias = trim(arguments.useAntiAlias) />
	</cffunction>
	<cffunction name="getUseAntiAlias" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.useAntiAlias />
	</cffunction>

	<cffunction name="setRandStrType" access="private" returntype="void" output="false">
		<cfargument name="randStrType" type="string" required="true" />
		<cfset variables.instance.randStrType = trim(arguments.randStrType) />
	</cffunction>
	<cffunction name="getRandStrType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.randStrType />
	</cffunction>

	<cffunction name="setRandStrLen" access="private" returntype="void" output="false">
		<cfargument name="randStrLen" type="numeric" required="true" />
		<cfset variables.instance.randStrLen = trim(arguments.randStrLen) />
	</cffunction>
	<cffunction name="getRandStrLen" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.randStrLen />
	</cffunction>

	<cffunction name="setWidth" access="private" returntype="void" output="false">
		<cfargument name="width" type="numeric" required="true" />
		<cfset variables.instance.width = trim(arguments.width) />
	</cffunction>
	<cffunction name="getWidth" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.width />
	</cffunction>

	<cffunction name="setHeight" access="private" returntype="void" output="false">
		<cfargument name="height" type="numeric" required="true" />
		<cfset variables.instance.height = trim(arguments.height) />
	</cffunction>
	<cffunction name="getHeight" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.height />
	</cffunction>

	<cffunction name="setFontsize" access="private" returntype="void" output="false">
		<cfargument name="fontsize" type="numeric" required="true" />
		<cfset variables.instance.fontsize = trim(arguments.fontsize) />
	</cffunction>
	<cffunction name="getFontsize" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.fontsize />
	</cffunction>

	<cffunction name="setLeftOffset" access="private" returntype="void" output="false">
		<cfargument name="leftOffset" type="numeric" required="true" />
		<cfset variables.instance.leftOffset = trim(arguments.leftOffset) />
	</cffunction>
	<cffunction name="getLeftOffset" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.leftOffset />
	</cffunction>

	<cffunction name="setShearXRange" access="private" returntype="void" output="false">
		<cfargument name="shearXRange" type="numeric" required="true" />
		<cfset variables.instance.shearXRange = trim(arguments.shearXRange) />
	</cffunction>
	<cffunction name="getShearXRange" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.shearXRange />
	</cffunction>

	<cffunction name="setShearYRange" access="private" returntype="void" output="false">
		<cfargument name="shearYRange" type="numeric" required="true" />
		<cfset variables.instance.shearYRange = trim(arguments.shearYRange) />
	</cffunction>
	<cffunction name="getShearYRange" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.shearYRange />
	</cffunction>

	<cffunction name="setFontColor" access="private" returntype="void" output="false">
		<cfargument name="fontColor" type="string" required="true" />
		<cfset variables.instance.fontColor = trim(arguments.fontColor) />
	</cffunction>
	<cffunction name="getFontColor" access="public" returntype="string" output="false">
		<cfreturn variables.instance.fontColor />
	</cffunction>

	<cffunction name="setBackgroundColor" access="private" returntype="void" output="false">
		<cfargument name="backgroundColor" type="string" required="true" />
		<cfset variables.instance.backgroundColor = trim(arguments.backgroundColor) />
	</cffunction>
	<cffunction name="getBackgroundColor" access="public" returntype="string" output="false">
		<cfreturn variables.instance.backgroundColor />
	</cffunction>

	<cffunction name="setUseGradientBackground" access="private" returntype="void" output="false">
		<cfargument name="useGradientBackground" type="boolean" required="true" />
		<cfset variables.instance.useGradientBackground = trim(arguments.useGradientBackground) />
	</cffunction>
	<cffunction name="getUseGradientBackground" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.useGradientBackground />
	</cffunction>

	<cffunction name="setBackgroundColorUseCyclic" access="private" returntype="void" output="false">
		<cfargument name="backgroundColorUseCyclic" type="boolean" required="true" />
		<cfset variables.instance.backgroundColorUseCyclic = trim(arguments.backgroundColorUseCyclic) />
	</cffunction>
	<cffunction name="getBackgroundColorUseCyclic" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.backgroundColorUseCyclic />
	</cffunction>

	<cffunction name="setUseOvals" access="private" returntype="void" output="false">
		<cfargument name="useOvals" type="boolean" required="true" />
		<cfset variables.instance.useOvals = trim(arguments.useOvals) />
	</cffunction>
	<cffunction name="getUseOvals" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.useOvals />
	</cffunction>

	<cffunction name="setOvalColor" access="private" returntype="void" output="false">
		<cfargument name="ovalColor" type="string" required="true" />
		<cfset variables.instance.ovalColor = trim(arguments.ovalColor) />
	</cffunction>
	<cffunction name="getOvalColor" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ovalColor />
	</cffunction>

	<cffunction name="setOvalUseTransparency" access="private" returntype="void" output="false">
		<cfargument name="ovalUseTransparency" type="boolean" required="true" />
		<cfset variables.instance.ovalUseTransparency = trim(arguments.ovalUseTransparency) />
	</cffunction>
	<cffunction name="getOvalUseTransparency" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.ovalUseTransparency />
	</cffunction>

	<cffunction name="setMinOvals" access="private" returntype="void" output="false">
		<cfargument name="minOvals" type="numeric" required="true" />
		<cfset variables.instance.minOvals = trim(arguments.minOvals) />
	</cffunction>
	<cffunction name="getMinOvals" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.minOvals />
	</cffunction>

	<cffunction name="setMaxOvals" access="private" returntype="void" output="false">
		<cfargument name="maxOvals" type="numeric" required="true" />
		<cfset variables.instance.maxOvals = trim(arguments.maxOvals) />
	</cffunction>
	<cffunction name="getMaxOvals" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.maxOvals />
	</cffunction>

	<cffunction name="setUseBackgroundLines" access="private" returntype="void" output="false">
		<cfargument name="useBackgroundLines" type="boolean" required="true" />
		<cfset variables.instance.useBackgroundLines = trim(arguments.useBackgroundLines) />
	</cffunction>
	<cffunction name="getUseBackgroundLines" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.useBackgroundLines />
	</cffunction>

	<cffunction name="setBackgroundLineColor" access="private" returntype="void" output="false">
		<cfargument name="backgroundLineColor" type="string" required="true" />
		<cfset variables.instance.backgroundLineColor = trim(arguments.backgroundLineColor) />
	</cffunction>
	<cffunction name="getBackgroundLineColor" access="public" returntype="string" output="false">
		<cfreturn variables.instance.backgroundLineColor />
	</cffunction>

	<cffunction name="setBackgroundLineUseTransparency" access="private" returntype="void" output="false">
		<cfargument name="backgroundLineUseTransparency" type="boolean" required="true" />
		<cfset variables.instance.backgroundLineUseTransparency = trim(arguments.backgroundLineUseTransparency) />
	</cffunction>
	<cffunction name="getBackgroundLineUseTransparency" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.backgroundLineUseTransparency />
	</cffunction>

	<cffunction name="setBackgroundMinLines" access="private" returntype="void" output="false">
		<cfargument name="backgroundMinLines" type="numeric" required="true" />
		<cfset variables.instance.backgroundMinLines = trim(arguments.backgroundMinLines) />
	</cffunction>
	<cffunction name="getBackgroundMinLines" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.backgroundMinLines />
	</cffunction>

	<cffunction name="setBackgroundMaxLines" access="private" returntype="void" output="false">
		<cfargument name="backgroundMaxLines" type="numeric" required="true" />
		<cfset variables.instance.backgroundMaxLines = trim(arguments.backgroundMaxLines) />
	</cffunction>
	<cffunction name="getBackgroundMaxLines" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.backgroundMaxLines />
	</cffunction>

	<cffunction name="setUseForegroundLines" access="private" returntype="void" output="false">
		<cfargument name="useForegroundLines" type="boolean" required="true" />
		<cfset variables.instance.useForegroundLines = trim(arguments.useForegroundLines) />
	</cffunction>
	<cffunction name="getUseForegroundLines" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.useForegroundLines />
	</cffunction>

	<cffunction name="setForegroundlineColor" access="private" returntype="void" output="false">
		<cfargument name="foregroundlineColor" type="string" required="true" />
		<cfset variables.instance.foregroundlineColor = trim(arguments.foregroundlineColor) />
	</cffunction>
	<cffunction name="getForegroundlineColor" access="public" returntype="string" output="false">
		<cfreturn variables.instance.foregroundlineColor />
	</cffunction>

	<cffunction name="setForegroundLineUseTransparency" access="private" returntype="void" output="false">
		<cfargument name="foregroundLineUseTransparency" type="boolean" required="true" />
		<cfset variables.instance.foregroundLineUseTransparency = trim(arguments.foregroundLineUseTransparency) />
	</cffunction>
	<cffunction name="getForegroundLineUseTransparency" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.foregroundLineUseTransparency />
	</cffunction>

	<cffunction name="setForegroundMinLines" access="private" returntype="void" output="false">
		<cfargument name="foregroundMinLines" type="numeric" required="true" />
		<cfset variables.instance.foregroundMinLines = trim(arguments.foregroundMinLines) />
	</cffunction>
	<cffunction name="getForegroundMinLines" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.foregroundMinLines />
	</cffunction>

	<cffunction name="setForegroundMaxLines" access="private" returntype="void" output="false">
		<cfargument name="foregroundMaxLines" type="numeric" required="true" />
		<cfset variables.instance.foregroundMaxLines = trim(arguments.foregroundMaxLines) />
	</cffunction>
	<cffunction name="getForegroundMaxLines" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.foregroundMaxLines />
	</cffunction>

	<cffunction name="setDefinedFonts" access="private" returntype="void" output="false">
		<cfargument name="definedFonts" type="array" required="true" />
		<cfset variables.instance.definedFonts = arguments.definedFonts />
	</cffunction>
	<cffunction name="getDefinedFonts" access="public" returntype="array" output="false">
		<cfreturn variables.instance.definedFonts />
	</cffunction>

</cfcomponent>