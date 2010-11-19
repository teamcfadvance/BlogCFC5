<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : podlayout.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : July 22, 2005
	History      : PaulH added cfproc (rkc 7/22/05)
	Purpose		 : Pod Layout
--->

<cfparam name="attributes.title">

<cfif thisTag.executionMode is "start">

	<cfoutput>

            <div class="box">
             <div class="titlewrap"><h4><span>#attributes.title#</span></h4></div>

             <div class="wrapleft">
              <div class="wrapright">
               <div class="tr">
                <div class="bl">
                 <div class="tl">
                  <div class="br the-content">
				  
	</cfoutput>		

<cfelse>

	<cfoutput>
                  </div>
                 </div>
                </div>
               </div>
              </div>
             </div>

            </div>
	</cfoutput>

</cfif>

<cfsetting enablecfoutputonly=false>