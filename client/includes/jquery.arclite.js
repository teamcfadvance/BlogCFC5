


if(isIE == 'undefined') var isIE = false;
if(isIE6 == 'undefined') var isIE6 = false;
if(lightbox == 'undefined') var lightbox = 0;

/* easing */

// t: current time, b: begInnIng value, c: change In value, d: duration
jQuery.easing['jswing'] = jQuery.easing['swing'];

jQuery.extend(jQuery.easing, {
  def: 'easeOutQuad',
  swing: function (x, t, b, c, d) {
    //alert(jQuery.easing.default);
    return jQuery.easing[jQuery.easing.def](x, t, b, c, d);
  },
  easeInQuad: function (x, t, b, c, d) {
    return c * (t /= d) * t + b;
  },
  easeOutQuad: function (x, t, b, c, d) {
    return -c * (t /= d) * (t - 2) + b;
  },
  easeInOutQuad: function (x, t, b, c, d) {
    if ((t /= d / 2) < 1) return c / 2 * t * t + b;
    return -c / 2 * ((--t) * (t - 2) - 1) + b;
  },
  easeInCubic: function (x, t, b, c, d) {
    return c * (t /= d) * t * t + b;
  },
  easeOutCubic: function (x, t, b, c, d) {
    return c * ((t = t / d - 1) * t * t + 1) + b;
  },
  easeInOutCubic: function (x, t, b, c, d) {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
    return c / 2 * ((t -= 2) * t * t + 2) + b;
  },
  easeInQuart: function (x, t, b, c, d) {
    return c * (t /= d) * t * t * t + b;
  },
  easeOutQuart: function (x, t, b, c, d) {
    return -c * ((t = t / d - 1) * t * t * t - 1) + b;
  },
  easeInOutQuart: function (x, t, b, c, d) {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
    return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
  },
  easeInQuint: function (x, t, b, c, d) {
    return c * (t /= d) * t * t * t * t + b;
  },
  easeOutQuint: function (x, t, b, c, d) {
    return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
  },
  easeInOutQuint: function (x, t, b, c, d) {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
    return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
  },
  easeInSine: function (x, t, b, c, d) {
    return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
  },
  easeOutSine: function (x, t, b, c, d) {
    return c * Math.sin(t / d * (Math.PI / 2)) + b;
  },
  easeInOutSine: function (x, t, b, c, d) {
    return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
  },
  easeInExpo: function (x, t, b, c, d) {
    return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
  },
  easeOutExpo: function (x, t, b, c, d) {
    return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
  },
  easeInOutExpo: function (x, t, b, c, d) {
    if (t == 0) return b;
    if (t == d) return b + c;
    if ((t /= d / 2) < 1) return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
    return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
  },
  easeInCirc: function (x, t, b, c, d) {
    return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
  },
  easeOutCirc: function (x, t, b, c, d) {
    return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
  },
  easeInOutCirc: function (x, t, b, c, d) {
    if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
    return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
  },
  easeInElastic: function (x, t, b, c, d) {
    var s = 1.70158;
    var p = 0;
    var a = c;
    if (t == 0) return b;
    if ((t /= d) == 1) return b + c;
    if (!p) p = d * .3;
    if (a < Math.abs(c)) {
      a = c;
      var s = p / 4;
    }
    else var s = p / (2 * Math.PI) * Math.asin(c / a);
    return - (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
  },
  easeOutElastic: function (x, t, b, c, d) {
    var s = 1.70158;
    var p = 0;
    var a = c;
    if (t == 0) return b;
    if ((t /= d) == 1) return b + c;
    if (!p) p = d * .3;
    if (a < Math.abs(c)) {
      a = c;
      var s = p / 4;
    }
    else var s = p / (2 * Math.PI) * Math.asin(c / a);
    return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
  },
  easeInOutElastic: function (x, t, b, c, d) {
    var s = 1.70158;
    var p = 0;
    var a = c;
    if (t == 0) return b;
    if ((t /= d / 2) == 2) return b + c;
    if (!p) p = d * (.3 * 1.5);
    if (a < Math.abs(c)) {
      a = c;
      var s = p / 4;
    }
    else var s = p / (2 * Math.PI) * Math.asin(c / a);
    if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
    return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
  },
  easeInBack: function (x, t, b, c, d, s) {
    if (s == undefined) s = 1.70158;
    return c * (t /= d) * t * ((s + 1) * t - s) + b;
  },
  easeOutBack: function (x, t, b, c, d, s) {
    if (s == undefined) s = 1.70158;
    return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
  },
  easeInOutBack: function (x, t, b, c, d, s) {
    if (s == undefined) s = 1.70158;
    if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
    return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
  },
  easeInBounce: function (x, t, b, c, d) {
    return c - jQuery.easing.easeOutBounce(x, d - t, 0, c, d) + b;
  },
  easeOutBounce: function (x, t, b, c, d) {
    if ((t /= d) < (1 / 2.75)) {
      return c * (7.5625 * t * t) + b;
    } else if (t < (2 / 2.75)) {
      return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
    } else if (t < (2.5 / 2.75)) {
      return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
    } else {
      return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
    }
  },
  easeInOutBounce: function (x, t, b, c, d) {
    if (t < d / 2) return jQuery.easing.easeInBounce(x, t * 2, 0, c, d) * .5 + b;
    return jQuery.easing.easeOutBounce(x, t * 2 - d, 0, c, d) * .5 + c * .5 + b;
  }
});




// ie 6 png fix
(function($) {
	$.fn.pngfix = function(options) {

		// Review the Microsoft IE developer library for AlphaImageLoader reference
		// http://msdn2.microsoft.com/en-us/library/ms532969(VS.85).aspx

		// ECMA scope fix
		var elements 	= this;
		var settings 	= $.extend({
			imageFixSrc: 	false,
			sizingMethod: 	false
		}, options);

		if(!$.browser.msie || ($.browser.msie &&  $.browser.version >= 7)) {
			return(elements);
		}

		function setFilter(el, path, mode) {
			var fs = el.attr("filters");
			var alpha = "DXImageTransform.Microsoft.AlphaImageLoader";
			if (fs[alpha]) {
				fs[alpha].enabled = true;
				fs[alpha].src = path;
				fs[alpha].sizingMethod = mode;
			} else {
				el.css("filter", 'progid:' + alpha + '(enabled="true", sizingMethod="' + mode + '", src="' + path + '")');
			}
		}

		function setDOMElementWidth(el) {
			if(el.css("width") == "auto" & el.css("height") == "auto") {
				el.css("width", el.attr("offsetWidth") + "px");
			}
		}

		return(
			elements.each(function() {

				// Scope
				var el = $(this);

				if(el.attr("tagName").toUpperCase() == "IMG" && (/\.png/i).test(el.attr("src"))) {
					if(!settings.imageFixSrc) {

						// Wrap the <img> in a <span> then apply style/filters,
						// removing the <img> tag from the final render
						el.wrap("<span></span>");
						var par = el.parent();
						par.css({
							height: 	el.height(),
							width: 		el.width(),
							display: 	"inline-block"
						});
						setFilter(par, el.attr("src"), "scale");
						el.remove();
					} else if((/\.gif/i).test(settings.imageFixSrc)) {

						// Replace the current image with a transparent GIF
						// and apply the filter to the background of the
						// <img> tag (not the preferred route)
						setDOMElementWidth(el);
						setFilter(el, el.attr("src"), "image");
						el.attr("src", settings.imageFixSrc);
					}

				} else {
					var bg = new String(el.css("backgroundImage"));
					var matches = bg.match(/^url\("(.*)"\)$/);
					if(matches && matches.length) {

						// Elements with a PNG as a backgroundImage have the
						// filter applied with a sizing method relevant to the
						// background repeat type
						setDOMElementWidth(el);
						el.css("backgroundImage", "none");

						// Restrict scaling methods to valid MSDN defintions (or one custom)
						var sc = "crop";
						if(settings.sizingMethod) {
							sc = settings.sizingMethod;
						}
						setFilter(el, matches[1], sc);

						// Fix IE peek-a-boo bug for internal links
						// within that DOM element
						el.find("a").each(function() {
							$(this).css("position", "relative");
						});
					}
				}

			})
		);
	}

})(jQuery)


// fixes for IE-7 cleartype bug on fade in/out
jQuery.fn.fadeIn = function(speed, callback) {
 return this.animate({opacity: 'show'}, speed, function() {
  if (jQuery.browser.msie) this.style.removeAttribute('filter');
  if (jQuery.isFunction(callback)) callback();
 });
};

jQuery.fn.fadeOut = function(speed, callback) {
 return this.animate({opacity: 'hide'}, speed, function() {
  if (jQuery.browser.msie) this.style.removeAttribute('filter');
  if (jQuery.isFunction(callback)) callback();
 });
};

jQuery.fn.fadeTo = function(speed,to,callback) {
 return this.animate({opacity: to}, speed, function() {
  if (to == 1 && jQuery.browser.msie) this.style.removeAttribute('filter');
  if (jQuery.isFunction(callback)) callback();
 });
};


// time based tooltips
function initTooltips(o) {
  var showTip = function() {
  	var el = jQuery('.tip', this).css('display', 'block')[0];
  	var ttHeight = jQuery(el).height();
    var ttOffset =  el.offsetHeight;
	var ttTop = ttOffset + ttHeight;
    jQuery('.tip', this)
	  .stop()
	  .css({'opacity': 0, 'top': 2 - ttOffset})
  	  .animate({'opacity': 1, 'top': 18 - ttOffset}, 250);
	};
	var hideTip = function() {
  	  var self = this;
	  var el = jQuery('.tip', this).css('display', 'block')[0];
      var ttHeight = jQuery(el).height();
	  var ttOffset =  el.offsetHeight;
	  var ttTop = ttOffset + ttHeight;
      jQuery('.tip', this)
	  	.stop()
	  	.animate({'opacity': 0,'top': 10 - ttOffset}, 250, function() {
		   el.hiding = false;
		   jQuery(this).css('display', 'none');
		}
      );
	};
	jQuery('.tip').hover(
	  function() { return false; },
	  function() { return true; }
	);
	jQuery('.tiptrigger, .cat-item').hover(
	  function(){
	  	var self = this;
	  	showTip.apply(this);
	  	if (o.timeout) this.tttimeout = setTimeout(function() { hideTip.apply(self) } , o.timeout);
	  },
	  function() {
	  	clearTimeout(this.tttimeout);
	  	hideTip.apply(this);
	  }
	);
}

// simple tooltips
function webshot(target_items, name){
 jQuery(target_items).each(function(i){
		jQuery("body").append("<div class='"+name+"' id='"+name+i+"'><p><img src='http://images.websnapr.com/?size=s&amp;url="+jQuery(this).attr('href')+"' /></p></div>");
		var my_tooltip = jQuery("#"+name+i);

		jQuery(this).mouseover(function(){
				my_tooltip.css({opacity:0.8, display:"none"}).fadeIn(400);
		}).mousemove(function(kmouse){
				my_tooltip.css({left:kmouse.pageX+15, top:kmouse.pageY+15});
		}).mouseout(function(){
				my_tooltip.fadeOut(400);
		});
	});
}





/*
 * FancyBox - simple and fancy jQuery plugin
 * Examples and documentation at: http://fancy.klade.lv/
 * Version: 1.2.1 (13/03/2009)
 * Copyright (c) 2009 Janis Skarnelis
 * Licensed under the MIT License: http://en.wikipedia.org/wiki/MIT_License
 * Requires: jQuery v1.3+

 http://fancybox.net

*/
(function (jQuery) {

  var elem, opts, busy = false,
  imagePreloader = new Image,
  loadingTimer, loadingFrame = 1,
  imageRegExp = /\.(jpg|gif|png|bmp|jpeg)(.*)?$/i;

  jQuery.fn.fancybox = function (settings) {
    settings = jQuery.extend({},
    jQuery.fn.fancybox.defaults, settings);

    var matchedGroup = this;

    function _initialize() {
      elem = this;
      opts = settings;

      _start();

      return false;
    };

    function _start() {
      if (busy) return;

      if (jQuery.isFunction(opts.callbackOnStart)) {
        opts.callbackOnStart();
      }

      opts.itemArray = [];
      opts.itemCurrent = 0;

      if (settings.itemArray.length > 0) {
        opts.itemArray = settings.itemArray;

      } else {
        var item = {};

        if (!elem.rel || elem.rel == '') {
          var item = {
            href: elem.href,
            title: elem.title
          };

          if (jQuery(elem).children("img:first").length) {
            item.orig = jQuery(elem).children("img:first");
          }

          opts.itemArray.push(item);

        } else {

          var subGroup = jQuery(matchedGroup).filter("a[rel=" + elem.rel + "]");

          var item = {};

          for (var i = 0; i < subGroup.length; i++) {
            item = {
              href: subGroup[i].href,
              title: subGroup[i].title
            };

            if (jQuery(subGroup[i]).children("img:first").length) {
              item.orig = jQuery(subGroup[i]).children("img:first");
            }

            opts.itemArray.push(item);
          }

          while (opts.itemArray[opts.itemCurrent].href != elem.href) {
            opts.itemCurrent++;
          }
        }
      }

      if (opts.overlayShow) {
        if (isIE6) {
          jQuery('embed, object, select').css('visibility', 'hidden');
        }

        jQuery("#fancyoverlay").css('opacity', 0).show().animate({
          opacity: opts.overlayOpacity
        },
        166);
      }

      _change_item();
    };

    function _change_item() {
      jQuery("#fancyright, #fancyleft, #fancytitle").fadeOut(333);

      var href = opts.itemArray[opts.itemCurrent].href;

      if (href.match(/#/)) {
        var target = window.location.href.split('#')[0];
        target = href.replace(target, '');
        target = target.substr(target.indexOf('#'));

        _set_content('<div id="fancydiv">' + jQuery(target).html() + '</div>', opts.frameWidth, opts.frameHeight);

      } else if (href.match(imageRegExp)) {
        imagePreloader = new Image;
        imagePreloader.src = href;

        if (imagePreloader.complete) {
          _proceed_image();

        } else {
          jQuery.fn.fancybox.showLoading();

          jQuery(imagePreloader).unbind().bind('load', function () {
            jQuery(".fancyloading").hide();

            _proceed_image();
          });
        }

      } else if (href.match("iframe") || elem.className.indexOf("iframe") >= 0) {
        _set_content('<iframe id="fancyframe" onload="jQuery.fn.fancybox.showIframe()" name="fancyiframe' + Math.round(Math.random() * 1000) + '" frameborder="0" hspace="0" src="' + href + '"></iframe>', opts.frameWidth, opts.frameHeight);

      } else {
        jQuery.get(href, function (data) {
          _set_content('<div id="fancyajax">' + data + '</div>', opts.frameWidth, opts.frameHeight);
        });
      }
    };

    function _proceed_image() {
      if (opts.imageScale) {
        var w = jQuery.fn.fancybox.getViewport();

        var r = Math.min(Math.min(w[0] - 36, imagePreloader.width) / imagePreloader.width, Math.min(w[1] - 60, imagePreloader.height) / imagePreloader.height);

        var width = Math.round(r * imagePreloader.width);
        var height = Math.round(r * imagePreloader.height);

      } else {
        var width = imagePreloader.width;
        var height = imagePreloader.height;
      }

      _set_content('<img alt="" id="fancyimg" src="' + imagePreloader.src + '" />', width, height);
    };

    function _preload_neighbor_images() {
      if ((opts.itemArray.length - 1) > opts.itemCurrent) {
        var href = opts.itemArray[opts.itemCurrent + 1].href;

        if (href.match(imageRegExp)) {
          objNext = new Image();
          objNext.src = href;
        }
      }

      if (opts.itemCurrent > 0) {
        var href = opts.itemArray[opts.itemCurrent - 1].href;

        if (href.match(imageRegExp)) {
          objNext = new Image();
          objNext.src = href;
        }
      }
    };

    function _set_content(value, width, height) {
      busy = true;

      var pad = opts.padding;

      if (isIE6) {
        jQuery("#fancycontent")[0].style.removeExpression("height");
        jQuery("#fancycontent")[0].style.removeExpression("width");
      }

      if (pad > 0) {
        width += pad * 2;
        height += pad * 2;

        jQuery("#fancycontent").css({
          'top': pad + 'px',
          'right': pad + 'px',
          'bottom': pad + 'px',
          'left': pad + 'px',
          'width': 'auto',
          'height': 'auto'
        });

        if (isIE6) {
          jQuery("#fancycontent")[0].style.setExpression('height', '(this.parentNode.clientHeight - 20)');
          jQuery("#fancycontent")[0].style.setExpression('width', '(this.parentNode.clientWidth - 20)');
        }

      } else {
        jQuery("#fancycontent").css({
          'top': 0,
          'right': 0,
          'bottom': 0,
          'left': 0,
          'width': '100%',
          'height': '100%'
        });
      }

      if (jQuery("#fancyouter").is(":visible") && width == jQuery("#fancyouter").width() && height == jQuery("#fancyouter").height()) {
        jQuery("#fancycontent").fadeOut(99, function () {
          jQuery("#fancycontent").empty().append(jQuery(value)).fadeIn(99, function () {
            _finish();
          });
        });

        return;
      }

      var w = jQuery.fn.fancybox.getViewport();

      var itemLeft = (width + 36) > w[0] ? w[2] : (w[2] + Math.round((w[0] - width - 36) / 2));
      var itemTop = (height + 50) > w[1] ? w[3] : (w[3] + Math.round((w[1] - height - 50) / 2));

      var itemOpts = {
        'left': itemLeft,
        'top': itemTop,
        'width': width + 'px',
        'height': height + 'px'
      };

      if (jQuery("#fancyouter").is(":visible")) {
        jQuery("#fancycontent").fadeOut(99, function () {
          jQuery("#fancycontent").empty();
          jQuery("#fancyouter").animate(itemOpts, opts.zoomSpeedChange, opts.easingChange, function () {
            jQuery("#fancycontent").append(jQuery(value)).fadeIn(99, function () {
              _finish();
            });
          });
        });

      } else {

        if (opts.zoomSpeedIn > 0 && opts.itemArray[opts.itemCurrent].orig !== undefined) {
          jQuery("#fancycontent").empty().append(jQuery(value));

          var orig_item = opts.itemArray[opts.itemCurrent].orig;
          var orig_pos = jQuery.fn.fancybox.getPosition(orig_item);

          jQuery("#fancyouter").css({
            'left': (orig_pos.left - 18) + 'px',
            'top': (orig_pos.top - 18) + 'px',
            'width': jQuery(orig_item).width(),
            'height': jQuery(orig_item).height()
          });

          if (opts.zoomOpacity) {
            itemOpts.opacity = 'show';
          }

          jQuery("#fancyouter").animate(itemOpts, opts.zoomSpeedIn, opts.easingIn, function () {
            _finish();
          });

        } else {

          jQuery("#fancycontent").hide().empty().append(jQuery(value)).show();
          jQuery("#fancyouter").css(itemOpts).fadeIn(99, function () {
            _finish();
          });
        }
      }
    };

    function _set_navigation() {
      if (opts.itemCurrent != 0) {
        jQuery("#fancyleft, #fancyleftico").unbind().bind("click", function (e) {
          e.stopPropagation();

          opts.itemCurrent--;
          _change_item();

          return false;
        });

        jQuery("#fancyleft").show();
      }

      if (opts.itemCurrent != (opts.itemArray.length - 1)) {
        jQuery("#fancyright, #fancyrightico").unbind().bind("click", function (e) {
          e.stopPropagation();

          opts.itemCurrent++;
          _change_item();

          return false;
        });

        jQuery("#fancyright").show();
      }
    };

    function _finish() {
      _set_navigation();

      _preload_neighbor_images();

      jQuery(document).keydown(function (e) {
        if (e.keyCode == 27) {
          jQuery.fn.fancybox.close();
          jQuery(document).unbind("keydown");

        } else if (e.keyCode == 37 && opts.itemCurrent != 0) {
          opts.itemCurrent--;
          _change_item();
          jQuery(document).unbind("keydown");

        } else if (e.keyCode == 39 && opts.itemCurrent != (opts.itemArray.length - 1)) {
          opts.itemCurrent++;
          _change_item();
          jQuery(document).unbind("keydown");
        }
      });

      if (opts.centerOnScroll) {
        jQuery(window).bind("resize scroll", jQuery.fn.fancybox.scrollBox);
      } else {
        jQuery("div#fancyouter").css("position", "absolute");
      }

      if (opts.hideOnContentClick) {
        jQuery("#fancywrap").click(jQuery.fn.fancybox.close);
      }

      jQuery("#fancyoverlay").bind("click", jQuery.fn.fancybox.close);

      if (opts.itemArray[opts.itemCurrent].title !== undefined && opts.itemArray[opts.itemCurrent].title.length > 0) {
        jQuery('#fancytitle').html(opts.itemArray[opts.itemCurrent].title);
        jQuery('#fancytitle').fadeIn(133);
      }

      if (opts.overlayShow && isIE6) {
        jQuery('embed, object, select', jQuery('#fancycontent')).css('visibility', 'visible');
      }

      if (jQuery.isFunction(opts.callbackOnShow)) {
        opts.callbackOnShow();
      }

      busy = false;
    };

    return this.unbind('click').click(_initialize);
  };

  jQuery.fn.fancybox.scrollBox = function () {
    var pos = jQuery.fn.fancybox.getViewport();

    jQuery("#fancyouter").css('left', ((jQuery("#fancyouter").width() + 36) > pos[0] ? pos[2] : pos[2] + Math.round((pos[0] - jQuery("#fancyouter").width() - 36) / 2)));
    jQuery("#fancyouter").css('top', ((jQuery("#fancyouter").height() + 50) > pos[1] ? pos[3] : pos[3] + Math.round((pos[1] - jQuery("#fancyouter").height() - 50) / 2)));
  };

  jQuery.fn.fancybox.getNumeric = function (el, prop) {
    return parseInt(jQuery.curCSS(el.jquery ? el[0] : el, prop, true)) || 0;
  };

  jQuery.fn.fancybox.getPosition = function (el) {
    var pos = el.offset();

    pos.top += jQuery.fn.fancybox.getNumeric(el, 'paddingTop');
    pos.top += jQuery.fn.fancybox.getNumeric(el, 'borderTopWidth');

    pos.left += jQuery.fn.fancybox.getNumeric(el, 'paddingLeft');
    pos.left += jQuery.fn.fancybox.getNumeric(el, 'borderLeftWidth');

    return pos;
  };

  jQuery.fn.fancybox.showIframe = function () {
    jQuery(".fancyloading").hide();
    jQuery("#fancyframe").show();
  };

  jQuery.fn.fancybox.getViewport = function () {
    return [jQuery(window).width(), jQuery(window).height(), jQuery(document).scrollLeft(), jQuery(document).scrollTop()];
  };

  jQuery.fn.fancybox.animateLoading = function () {
    if (!jQuery("#fancyloading").is(':visible')) {
      clearInterval(loadingTimer);
      return;
    }

    loadingFrame = (loadingFrame + 1) % 12;
  };

  jQuery.fn.fancybox.showLoading = function () {
    clearInterval(loadingTimer);

    var pos = jQuery.fn.fancybox.getViewport();

    jQuery("#fancyloading").css({
      'left': ((pos[0] - 40) / 2 + pos[2]),
      'top': ((pos[1] - 40) / 2 + pos[3])
    }).show();
    jQuery("#fancyloading").bind('click', jQuery.fn.fancybox.close);

    loadingTimer = setInterval(jQuery.fn.fancybox.animateLoading, 66);
  };

  jQuery.fn.fancybox.close = function () {
    busy = true;

    jQuery(imagePreloader).unbind();

    jQuery("#fancyoverlay").unbind();

    if (opts.hideOnContentClick) {
      jQuery("#fancywrap").unbind();
    }

    jQuery(".fancyloading, #fancyleft, #fancyright, #fancytitle").fadeOut(133);

    if (opts.centerOnScroll) {
      jQuery(window).unbind("resize scroll");
    }

    __cleanup = function () {
      jQuery("#fancyouter").hide();
      jQuery("#fancyoverlay").fadeOut(133);

      if (opts.centerOnScroll) {
        jQuery(window).unbind("resize scroll");
      }

      if (isIE6) {
        jQuery('embed, object, select').css('visibility', 'visible');
      }

      if (jQuery.isFunction(opts.callbackOnClose)) {
        opts.callbackOnClose();
      }

      busy = false;
    };

    if (jQuery("#fancyouter").is(":visible") !== false) {
      if (opts.zoomSpeedOut > 0 && opts.itemArray[opts.itemCurrent].orig !== undefined) {
        var orig_item = opts.itemArray[opts.itemCurrent].orig;
        var orig_pos = jQuery.fn.fancybox.getPosition(orig_item);

        var itemOpts = {
          'left': (orig_pos.left - 18) + 'px',
          'top': (orig_pos.top - 18) + 'px',
          'width': jQuery(orig_item).width(),
          'height': jQuery(orig_item).height()
        };

        if (opts.zoomOpacity) {
          itemOpts.opacity = 'hide';
        }

        jQuery("#fancyouter").stop(false, true).animate(itemOpts, opts.zoomSpeedOut, opts.easingOut, __cleanup);

      } else {
        jQuery("#fancyouter").stop(false, true).fadeOut(99, __cleanup);
      }

    } else {
      __cleanup();
    }

    return false;
  };

  jQuery.fn.fancybox.build = function () {
    var html = '';

    html += '<div id="fancyoverlay"></div>';
    html += '<div id="fancywrap">';
    html += '<div class="fancyloading" id="fancyloading"><div></div></div>';
    html += '<div id="fancyouter">';
    html += '<div id="fancyinner">';
    html += '<a href="javascript:;" id="fancyleft"><span class="fancyico" id="fancyleftico"></span></a><a href="javascript:;" id="fancyright"><span class="fancyico" id="fancyrightico"></span></a>';
    html += '<div id="fancycontent"></div>';
    html += '</div>';
    html += '<div id="fancytitle"></div>';
    html += '</div>';
    html += '</div>';

    jQuery(html).appendTo("body");

    if (isIE6) {
      jQuery("#fancyinner").prepend('<iframe class="fancybigIframe" scrolling="no" frameborder="0"></iframe>');
    }
  };

  jQuery.fn.fancybox.defaults = {
    padding: 10,
    imageScale: true,
    zoomOpacity: true,
    zoomSpeedIn: 0,
    zoomSpeedOut: 0,
    zoomSpeedChange: 300,
    easingIn: 'swing',
    easingOut: 'swing',
    easingChange: 'swing',
    frameWidth: 425,
    frameHeight: 355,
    overlayShow: true,
    overlayOpacity: 0.3,
    hideOnContentClick: true,
    centerOnScroll: true,
    itemArray: [],
    callbackOnStart: null,
    callbackOnShow: null,
    callbackOnClose: null
  };

  jQuery(document).ready(function () {
    jQuery.fn.fancybox.build();
  });

})(jQuery);

function liteboxCallback() {
  jQuery('.flickrGallery li a').fancybox({
    'zoomSpeedIn': 333,
    'zoomSpeedOut': 333,
    'zoomSpeedChange': 133,
    'easingIn': 'easeOutQuart',
    'easingOut': 'easeInQuart',
    'overlayShow': true,
    'overlayOpacity': 0.75
  });
}





// quote comment
(function (jQuery) {
  jQuery.fn.quoteComment = function (options) {

    jQuery.fn.quoteComment.defaults = {
      comment: 'li.comment',
      comment_id: '.comment-id',
      author: '.comment-author',
      source: '.comment-body',
      target: '#comment'
    };

    jQuery.fn.appendVal = function(txt) {
     return this.each(function(){
        this.value += txt;
     });
    };

    var o = jQuery.extend({},
    jQuery.fn.quoteComment.defaults, options);

    return this.each(function () {

        jQuery(this).click(
          function(){
            $c = jQuery(this).parents(o.comment).find(o.source);
            $author = jQuery(this).parents(o.comment).find(o.author);
            $cid = jQuery(this).parents(o.comment).find(o.comment_id).attr('href');
            jQuery(o.target).appendVal('<blockquote>\n<a href="'+$cid+'">\n<strong><em>'+$author.html()+':</em></strong>\n</a>\n '+$c.html()+'</blockquote>');
            jQuery(o.target).focus();
            return false;
           })
    });
  };
})(jQuery);



/*
 * Superfish v1.4.8 - jQuery menu widget
 * Copyright (c) 2008 Joel Birch
 *
 * Dual licensed under the MIT and GPL licenses:
 * 	http://www.opensource.org/licenses/mit-license.php
 * 	http://www.gnu.org/licenses/gpl.html
 *
 * CHANGELOG: http://users.tpg.com.au/j_birch/plugins/superfish/changelog.txt
 */

;(function(jQuery){
    jQuery.fn.superfish = function(op){

        var sf = jQuery.fn.superfish,
            c = sf.c,
            $arrow = jQuery(['<span class="',c.arrowClass,'"> &#187;</span>'].join('')),
            over = function(){
                var $$ = jQuery(this), menu = getMenu($$);
                clearTimeout(menu.sfTimer);
                $$.showSuperfishUl().siblings().hideSuperfishUl();
            },
            out = function(){
                var $$ = jQuery(this), menu = getMenu($$), o = sf.op;
                clearTimeout(menu.sfTimer);
                menu.sfTimer=setTimeout(function(){
                    o.retainPath=(jQuery.inArray($$[0],o.$path)>-1);
                    $$.hideSuperfishUl();
                    if (o.$path.length && $$.parents(['li.',o.hoverClass].join('')).length<1){over.call(o.$path);}
                },o.delay);
            },
            getMenu = function($menu){
                var menu = $menu.parents(['ul.',c.menuClass,':first'].join(''))[0];
                sf.op = sf.o[menu.serial];
                return menu;
            },
            addArrow = function($a){ $a.addClass(c.anchorClass).append($arrow.clone()); };

        return this.each(function() {
            var s = this.serial = sf.o.length;
            var o = jQuery.extend({},sf.defaults,op);
            o.$path = jQuery('li.'+o.pathClass,this).slice(0,o.pathLevels).each(function(){
                jQuery(this).addClass([o.hoverClass,c.bcClass].join(' '))
                    .filter('li:has(ul)').removeClass(o.pathClass);
            });
            sf.o[s] = sf.op = o;

            jQuery('li:has(ul)',this)[(jQuery.fn.hoverIntent && !o.disableHI) ? 'hoverIntent' : 'hover'](over,out).each(function() {
                if (o.autoArrows) addArrow( jQuery('>a:first-child',this) );
            })
            .not('.'+c.bcClass)
                .hideSuperfishUl();

            var $a = jQuery('a',this);
            $a.each(function(i){
                var $li = $a.eq(i).parents('li');
                $a.eq(i).focus(function(){over.call($li);}).blur(function(){out.call($li);});
            });
            o.onInit.call(this);

        }).each(function() {
            var menuClasses = [c.menuClass];
            jQuery(this).addClass(menuClasses.join(' '));
        });
    };

    var sf = jQuery.fn.superfish;
    sf.o = [];
    sf.op = {};
    sf.c = {
        bcClass     : 'sf-breadcrumb',
        menuClass   : 'sf-js-enabled',
        anchorClass : 'sf-with-ul',
        arrowClass  : 'arrow'
    };
    sf.defaults = {
        hoverClass	: 'sfHover',
        pathClass	: 'overideThisToUse',
        pathLevels	: 1,
        delay		: 333,
        speed		: 'normal',
        autoArrows	: true,
        disableHI	: false,		// true disables hoverIntent detection
        onInit		: function(){}, // callback functions
        onBeforeShow: function(){},
        onShow		: function(){},
        onHide		: function(){}
    };


    jQuery.fn.extend({
        hideSuperfishUl : function(){
            var o = sf.op,
                not = (o.retainPath===true) ? o.$path : '';
            o.retainPath = false;
            if(isIE) {
              css1 = {marginTop:20};

            } else {
              css1 = {opacity: 0,marginTop:20};
            }
            var $ul = jQuery(['li.',o.hoverClass].join(''),this).add(this).not(not).removeClass(o.hoverClass).find('>ul').animate(css1,150,'swing', function() {
              jQuery(this).css({display:"none"})});
              o.onHide.call($ul);
              return this;
        },
        showSuperfishUl : function(){
            var o = sf.op,
            $ul = this.addClass(o.hoverClass).find('>ul:hidden').css('visibility','visible');
            o.onBeforeShow.call($ul);
            if(isIE) {
              css1 = {display: "block",marginTop:20};
              css2 = {marginTop:0};
            } else {
              css1 = {display: "block",opacity:0,marginTop:20};
              css2 = {opacity: 1,marginTop:0};
            }
            $ul.css(css1).animate(css2,150,'swing',function(){ o.onShow.call($ul); });
            return this;
        }
    });

})(jQuery);


// init.

jQuery(document).ready(function(){
  jQuery(".comment .avatar").pngfix();
  jQuery("h1.logo a img").pngfix();

  // fade span
  jQuery('.fadeThis, ul#footer-widgets li.widget li').append('<span class="hover"></span>').each(function () {
    var jQueryspan = jQuery('> span.hover', this).css('opacity', 0);
	  jQuery(this).hover(function () {
	    jQueryspan.stop().fadeTo(333, 1);
	  }, function () {
	    jQueryspan.stop().fadeTo(333, 0);
	  });
	});


  jQuery('#sidebar ul.menu li li a').mouseover(function () {
   	jQuery(this).animate({ marginLeft: "5px" }, 100 );
  });
  jQuery('#sidebar ul.menu li li a').mouseout(function () {
    jQuery(this).animate({ marginLeft: "0px" }, 100 );
  });


  jQuery('a.toplink').click(function(){
    jQuery('html').animate({scrollTop:0}, 'slow');
  });

  //navigationeffects();
  jQuery('#nav').superfish({autoArrows:true});

  jQuery("a.quote").quoteComment({comment:'li.comment',comment_id: '.comment-id',author:'.comment-author',source:'.comment-text',target:'#comment'});

  if(lightbox){
  // enable fancyBox for any link with rel="lightbox" and on links which references end in image extensions (jpg, gif, png)
  jQuery("a[rel='lightbox'], a[href$='.jpg'], a[href$='.jpeg'], a[href$='.gif'], a[href$='.png'], a[href$='.JPG'], a[href$='.JPEG'], a[href$='.GIF'], a[href$='.PNG']").fancybox({
    'zoomSpeedIn': 333,
    'zoomSpeedOut': 333,
    'zoomSpeedChange': 133,
    'easingIn': 'easeOutQuart',
    'easingOut': 'easeInQuart',
    'overlayShow': true,
    'overlayOpacity': 0.75
  });
  }

  if (document.all && !window.opera && !window.XMLHttpRequest && jQuery.browser.msie) { var isIE6 = true; }
  else { var isIE6 = false;} ;
  jQuery.browser.msie6 = isIE6;
  if (!isIE6) {
    initTooltips({
		timeout: 6000
   });
  }

  webshot(".with-tooltip a","tooltip");

  // widget title adjustments
  jQuery('.widget .titlewrap').each(function(){ jQuery(this).prependTo(this.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode);  });

  // set roles on some elements (for accessibility)
  jQuery("#nav").attr("role","navigation");
  jQuery("#main-content").attr("role","main");
  jQuery("#sidebar").attr("role","complementary");
  jQuery("#searchform").attr("role","search");

 });