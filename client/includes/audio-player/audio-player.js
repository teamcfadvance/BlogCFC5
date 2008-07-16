var AudioPlayer = function () {
	var instances = [];
	var activeInstanceID;
	var playerURL = "";
	var defaultOptions = {};
	var currentVolume = -1;
	
	var getMovie = function (name) {
		return document.all ? window[name] : document[name];
	};
	
	return {
		setup: function (url, options) {
	        playerURL = url;
	        defaultOptions = options;
	    },
	    
	    embed: function (elementID, options) {
	        var instanceOptions = {};
	        var key;
	        var so;
			var bgcolor;
			var wmode;
			
			var flashParams = {};
			var flashVars = {};
			var flashAttributes = {};
	
	        // Merge default options and instance options
			for (key in defaultOptions) {
	            instanceOptions[key] = defaultOptions[key];
	        }
	        for (key in options) {
	            instanceOptions[key] = options[key];
	        }
	        
			if (instanceOptions.transparentpagebg == "yes") {
				flashParams.bgcolor = "#FFFFFF";
				flashParams.wmode = "transparent";
			} else {
				if (instanceOptions.pagebg) {
					flashParams.bgcolor = "#" + instanceOptions.pagebg;
				}
				flashParams.wmode = "opaque";
			}
			
			flashParams.menu = "false";
			
	        for (key in instanceOptions) {
				if (key == "pagebg" || key == "width" || key == "transparentpagebg") {
					continue;
				}
	            flashVars[key] = instanceOptions[key];
	        }
			
			flashAttributes.name = elementID;
			flashAttributes.style = "outline: none";
			
			flashVars.playerID = elementID;
			
			swfobject.embedSWF(playerURL, elementID, instanceOptions.width.toString(), "24", "8.0.0", false, flashVars, flashParams, flashAttributes);
			
			instances.push(elementID);
	    },
		
		syncVolumes: function (playerID, volume) {	
			currentVolume = volume;
			for (var i = 0; i < instances.length; i++) {
				if (instances[i] != playerID) {
					getMovie(instances[i]).setVolume(currentVolume);
				}
			}
		},
		
		activate: function (playerID) {
			if (activeInstanceID && activeInstanceID != playerID) {
				getMovie(activeInstanceID).closePlayer();
			}
			
			activeInstanceID = playerID;
		},
		
		getVolume: function (playerID) {
			return currentVolume;
		}
		
	}
	
}();
