/*
 * Debate Summary - Croudsource arguments and debates
 * Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>
 *
 * This file is part of Debate Summary.
 *
 * Debate Summary is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Debate Summary is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Debate Summary.  If not, see <http://www.gnu.org/licenses/>.
 */

// markup layout fix
function initBlocksHeight(){
  setSameHeight({
    holder: 'div.container',
    elements: 'div.block',
    flexible: true,
    multiLine: true
  });
}
// // clear inputs on focus
// function initInputs() {
//   PlaceholderInput.replaceByOptions({
//     // filter options
//     clearInputs: true,
//     clearTextareas: true,
//     clearPasswords: true,
//     skipClass:'default',
    
//     // input options
//     wrapWithElement:false,
//     showUntilTyping:false,
//     getParentByClass:false,
//     placeholderAttr: 'value'
//   });
// }

// // placeholder class
// ;(function(){
//   var placeholderCollection = [];
//   PlaceholderInput = function() {
//     this.options = {
//       element:null,
//       showUntilTyping:false,
//       wrapWithElement:false,
//       getParentByClass:false,
//       placeholderAttr:'value',
//       inputFocusClass:'focus',
//       inputActiveClass:'text-active',
//       parentFocusClass:'parent-focus',
//       parentActiveClass:'parent-active',
//       labelFocusClass:'label-focus',
//       labelActiveClass:'label-active',
//       fakeElementClass:'input-placeholder-text'
//     }
//     placeholderCollection.push(this);
//     this.init.apply(this,arguments);
//   }
//   PlaceholderInput.refreshAllInputs = function(except) {
//     for(var i = 0; i < placeholderCollection.length; i++) {
//       if(except !== placeholderCollection[i]) {
//         placeholderCollection[i].refreshState();
//       }
//     }
//   }
//   PlaceholderInput.replaceByOptions = function(opt) {
//     var inputs = [].concat(
//       convertToArray(document.getElementsByTagName('input')),
//       convertToArray(document.getElementsByTagName('textarea'))
//     );
//     for(var i = 0; i < inputs.length; i++) {
//       if(inputs[i].className.indexOf(opt.skipClass) < 0) {
//         var inputType = getInputType(inputs[i]);
//         if((opt.clearInputs && (inputType === 'text' || inputType === 'email')) ||
//           (opt.clearTextareas && inputType === 'textarea') || 
//           (opt.clearPasswords && inputType === 'password')
//         ) {
//           new PlaceholderInput({
//             element:inputs[i],
//             wrapWithElement:opt.wrapWithElement,
//             showUntilTyping:opt.showUntilTyping,
//             getParentByClass:opt.getParentByClass,
//             placeholderAttr: inputs[i].getAttribute('placeholder') ? 'placeholder' : opt.placeholderAttr
//           });
//         }
//       }
//     }
//   }
//   PlaceholderInput.prototype = {
//     init: function(opt) {
//       this.setOptions(opt);
//       if(this.element && this.element.PlaceholderInst) {
//         this.element.PlaceholderInst.refreshClasses();
//       } else {
//         this.element.PlaceholderInst = this;
//         if(this.elementType !== 'radio' || this.elementType !== 'checkbox' || this.elementType !== 'file') {
//           this.initElements();
//           this.attachEvents();
//           this.refreshClasses();
//         }
//       }
//     },
//     setOptions: function(opt) {
//       for(var p in opt) {
//         if(opt.hasOwnProperty(p)) {
//           this.options[p] = opt[p];
//         }
//       }
//       if(this.options.element) {
//         this.element = this.options.element;
//         this.elementType = getInputType(this.element);
//         this.wrapWithElement = (this.elementType === 'password' || this.options.showUntilTyping ? true : this.options.wrapWithElement);
//         this.setPlaceholderValue(this.options.placeholderAttr);
//       }
//     },
//     setPlaceholderValue: function(attr) {
//       this.origValue = (attr === 'value' ? this.element.defaultValue : (this.element.getAttribute(attr) || ''));
//       if(this.options.placeholderAttr !== 'value') {
//         this.element.removeAttribute(this.options.placeholderAttr);
//       }
//     },
//     initElements: function() {
//       // create fake element if needed
//       if(this.wrapWithElement) {
//         this.fakeElement = document.createElement('span');
//         this.fakeElement.className = this.options.fakeElementClass;
//         this.fakeElement.innerHTML += this.origValue;
//         this.fakeElement.style.color = getStyle(this.element, 'color');
//         this.fakeElement.style.position = 'absolute';
//         this.element.parentNode.insertBefore(this.fakeElement, this.element);
        
//         if(this.element.value === this.origValue || !this.element.value) {
//           this.element.value = '';
//           this.togglePlaceholderText(true);
//         } else {
//           this.togglePlaceholderText(false);
//         }
//       } else if(!this.element.value && this.origValue.length) {
//         this.element.value = this.origValue;
//       }
//       // get input label
//       if(this.element.id) {
//         this.labels = document.getElementsByTagName('label');
//         for(var i = 0; i < this.labels.length; i++) {
//           if(this.labels[i].htmlFor === this.element.id) {
//             this.labelFor = this.labels[i];
//             break;
//           }
//         }
//       }
//       // get parent node (or parentNode by className)
//       this.elementParent = this.element.parentNode;
//       if(typeof this.options.getParentByClass === 'string') {
//         var el = this.element;
//         while(el.parentNode) {
//           if(hasClass(el.parentNode, this.options.getParentByClass)) {
//             this.elementParent = el.parentNode;
//             break;
//           } else {
//             el = el.parentNode;
//           }
//         }
//       }
//     },
//     attachEvents: function() {
//       this.element.onfocus = bindScope(this.focusHandler, this);
//       this.element.onblur = bindScope(this.blurHandler, this);
//       if(this.options.showUntilTyping) {
//         this.element.onkeydown = bindScope(this.typingHandler, this);
//         this.element.onpaste = bindScope(this.typingHandler, this);
//       }
//       if(this.wrapWithElement) this.fakeElement.onclick = bindScope(this.focusSetter, this);
//     },
//     togglePlaceholderText: function(state) {
//       if(this.wrapWithElement) {
//         this.fakeElement.style.display = state ? '' : 'none';
//       } else {
//         this.element.value = state ? this.origValue : '';
//       }
//     },
//     focusSetter: function() {
//       this.element.focus();
//     },
//     focusHandler: function() {
//       clearInterval(this.checkerInterval);
//       this.checkerInterval = setInterval(bindScope(this.intervalHandler,this), 1);
//       this.focused = true;
//       if(!this.element.value.length || this.element.value === this.origValue) {
//         if(!this.options.showUntilTyping) {
//           this.togglePlaceholderText(false);
//         }
//       }
//       this.refreshClasses();
//     },
//     blurHandler: function() {
//       clearInterval(this.checkerInterval);
//       this.focused = false;
//       if(!this.element.value.length || this.element.value === this.origValue) {
//         this.togglePlaceholderText(true);
//       }
//       this.refreshClasses();
//       PlaceholderInput.refreshAllInputs(this);
//     },
//     typingHandler: function() {
//       setTimeout(bindScope(function(){
//         if(this.element.value.length) {
//           this.togglePlaceholderText(false);
//           this.refreshClasses();
//         }
//       },this), 10);
//     },
//     intervalHandler: function() {
//       if(typeof this.tmpValue === 'undefined') {
//         this.tmpValue = this.element.value;
//       }
//       if(this.tmpValue != this.element.value) {
//         PlaceholderInput.refreshAllInputs(this);
//       }
//     },
//     refreshState: function() {
//       if(this.wrapWithElement) {
//         if(this.element.value.length && this.element.value !== this.origValue) {
//           this.togglePlaceholderText(false);
//         } else if(!this.element.value.length) {
//           this.togglePlaceholderText(true);
//         }
//       }
//       this.refreshClasses();
//     },
//     refreshClasses: function() {
//       this.textActive = this.focused || (this.element.value.length && this.element.value !== this.origValue);
//       this.setStateClass(this.element, this.options.inputFocusClass,this.focused);
//       this.setStateClass(this.elementParent, this.options.parentFocusClass,this.focused);
//       this.setStateClass(this.labelFor, this.options.labelFocusClass,this.focused);
//       this.setStateClass(this.element, this.options.inputActiveClass, this.textActive);
//       this.setStateClass(this.elementParent, this.options.parentActiveClass, this.textActive);
//       this.setStateClass(this.labelFor, this.options.labelActiveClass, this.textActive);
//     },
//     setStateClass: function(el,cls,state) {
//       if(!el) return; else if(state) addClass(el,cls); else removeClass(el,cls);
//     }
//   }
  
//   // utility functions
//   function convertToArray(collection) {
//     var arr = [];
//     for (var i = 0, ref = arr.length = collection.length; i < ref; i++) {
//       arr[i] = collection[i];
//     }
//     return arr;
//   }
//   function getInputType(input) {
//     return (input.type ? input.type : input.tagName).toLowerCase();
//   }
//   function hasClass(el,cls) {
//     return el.className ? el.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)')) : false;
//   }
//   function addClass(el,cls) {
//     if (!hasClass(el,cls)) el.className += " "+cls;
//   }
//   function removeClass(el,cls) {
//     if (hasClass(el,cls)) {el.className=el.className.replace(new RegExp('(\\s|^)'+cls+'(\\s|$)'),' ');}
//   }
//   function bindScope(f, scope) {
//     return function() {return f.apply(scope, arguments)}
//   }
//   function getStyle(el, prop) {
//     if (document.defaultView && document.defaultView.getComputedStyle) {
//       return document.defaultView.getComputedStyle(el, null)[prop];
//     } else if (el.currentStyle) {
//       return el.currentStyle[prop];
//     } else {
//       return el.style[prop];
//     }
//   }
// }());

// if (window.addEventListener) window.addEventListener("load", initInputs, false);
// else if (window.attachEvent) window.attachEvent("onload", initInputs);

// set same height for blocks
function setSameHeight(opt) {
  // default options
  var options = {
    holder: null,
    skipClass: 'same-height-ignore',
    leftEdgeClass: 'same-height-left',
    rightEdgeClass: 'same-height-right',
    elements: '>*',
    flexible: false,
    multiLine: false,
    useMinHeight: false
  }
  for(var p in opt) {
    if(opt.hasOwnProperty(p)) {
      options[p] = opt[p];
    }
  }
  
  // init script
  if(options.holder) {
    var holders = SameHeight.queryElementsBySelector(options.holder);
    for(var i = 0; i < holders.length; i++) {
      (function(i){
        var curHolder = holders[i], curElements = [], resizeTimer;
        var tmpElements = SameHeight.queryElementsBySelector(options.elements, curHolder);
        
        // get resize elements
        for(var i = 0; i < tmpElements.length; i++) {
          if(!SameHeight.hasClass(tmpElements[i], options.skipClass)) {
            curElements.push(tmpElements[i]);
          }
        }
        if(!curElements.length) return;
        
        // resize handler
        function doResize() {
          for(var i = 0; i < curElements.length; i++) {
            curElements[i].style[options.useMinHeight && SameHeight.supportMinHeight ? 'minHeight' : 'height'] = '';
          }
          
          if(options.multiLine) {
            // resize elements row by row
            SameHeight.resizeElementsByRows(curElements, options);
          } else {
            // resize elements by holder
            SameHeight.setSize(curElements, curHolder, options);
          }
        }
        doResize();
        
        // handle flexible layout / font resize
        function flexibleResizeHandler() {
          clearTimeout(resizeTimer);
          resizeTimer = setTimeout(function(){
            doResize();
            setTimeout(doResize, 100);
          },1)
        }
        if(options.flexible) {
          addEvent(window, 'resize', flexibleResizeHandler);
          addEvent(window, 'orientationchange', flexibleResizeHandler);
          FontResize.onChange(flexibleResizeHandler);
        }
        // handle complete page load including images and fonts
        addEvent(window, 'load', flexibleResizeHandler);
      }(i));
    }
  }
  
  // event handler helper functions
  function addEvent(object, event, handler) {
    if(object.addEventListener) object.addEventListener(event, handler, false);
    else if(object.attachEvent) object.attachEvent('on'+event, handler);
  }
}

/*
 * SameHeight helper module
 */
SameHeight = {
  supportMinHeight: typeof document.documentElement.style.maxHeight !== 'undefined', // detect css min-height support
  setSize: function(boxes, parent, options) {
    var holderHeight = typeof parent === 'number' ? parent : this.getHeight(parent);
    
    for(var i = 0; i < boxes.length; i++) {
      var box = boxes[i];
      var depthDiffHeight = 0;
      box.className = box.className.replace(options.leftEdgeClass, '').replace(options.rightEdgeClass, '');
      
      if(typeof parent != 'number') {
        var tmpParent = box.parentNode;
        while(tmpParent != parent) {
          depthDiffHeight += this.getOuterHeight(tmpParent) - this.getHeight(tmpParent);
          tmpParent = tmpParent.parentNode;
        }
      }
      var calcHeight = holderHeight - depthDiffHeight - (this.getOuterHeight(box) - this.getHeight(box));
      if(calcHeight > 0) {
        box.style[options.useMinHeight && this.supportMinHeight ? 'minHeight' : 'height'] = calcHeight + 'px'
      }
    }
    
    boxes[0].className += ' ' + options.leftEdgeClass;
    boxes[boxes.length - 1].className += ' ' + options.rightEdgeClass;
  },
  getOffset: function(obj) {
    if (obj.getBoundingClientRect) {
      var scrollLeft = window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft;
      var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
      var clientLeft = document.documentElement.clientLeft || document.body.clientLeft || 0;
      var clientTop = document.documentElement.clientTop || document.body.clientTop || 0;
      return {
        top:Math.round(obj.getBoundingClientRect().top + scrollTop - clientTop),
        left:Math.round(obj.getBoundingClientRect().left + scrollLeft - clientLeft)
      }
    } else {
      var posLeft = 0, posTop = 0;
      while (obj.offsetParent) {posLeft += obj.offsetLeft; posTop += obj.offsetTop; obj = obj.offsetParent;}
      return {top:posTop,left:posLeft};
    }
  },
  getStyle: function(el, prop) {
    if (document.defaultView && document.defaultView.getComputedStyle) {
      return document.defaultView.getComputedStyle(el, null)[prop];
    } else if (el.currentStyle) {
      return el.currentStyle[prop];
    } else {
      return el.style[prop];
    }
  },
  getStylesTotal: function(obj) {
    var sum = 0;
    for(var i = 1; i < arguments.length; i++) {
      var val = parseFloat(this.getStyle(obj, arguments[i]));
      if(!isNaN(val)) {
        sum += val;
      }
    }
    return sum;
  },
  getHeight: function(obj) {
    return obj.offsetHeight - this.getStylesTotal(obj, 'borderTopWidth', 'borderBottomWidth', 'paddingTop', 'paddingBottom');
  },
  getOuterHeight: function(obj) {
    return obj.offsetHeight;
  },
  resizeElementsByRows: function(boxes, options) {
    var currentRow = [], maxHeight, firstOffset = this.getOffset(boxes[0]).top;
    for(var i = 0; i < boxes.length; i++) {
      if(this.getOffset(boxes[i]).top === firstOffset) {
        currentRow.push(boxes[i]);
      } else {
        maxHeight = this.getMaxHeight(currentRow);
        this.setSize(currentRow, maxHeight, options);
        firstOffset = this.getOffset(boxes[i]).top;
        currentRow = [boxes[i]];
      }
    }
    if(currentRow.length) {
      maxHeight = this.getMaxHeight(currentRow);
      this.setSize(currentRow, maxHeight, options);
    }
  },
  getMaxHeight: function(boxes) {
    var maxHeight = 0;
    for(var i = 0; i < boxes.length; i++) {
      maxHeight = Math.max(maxHeight, this.getOuterHeight(boxes[i]));
    }
    return maxHeight;
  },
  hasClass: function(obj,cname) {
    return (obj.className ? obj.className.match(new RegExp('(\\s|^)'+cname+'(\\s|$)')) : false);
  },
  trim: function (str) {
    return str.replace(/^\s+/, '').replace(/\s+$/, '');
  },
  queryElementsBySelector: function(selector, scope) {
    var searchScope = scope || document;
    if(selector === '>*') return scope.children;
    if(document.querySelectorAll) {
      return searchScope.querySelectorAll(selector);
    } else {
      selector = this.trim(selector);
      if(selector.indexOf('#') === 0) {
        return [searchScope.getElementById(selector.substr(1))];
      } else if(selector.indexOf('.') != -1) {
        selector = selector.split('.');
        var tagName = selector[0], className = selector[1], collection = [];
        var elements = searchScope.getElementsByTagName(tagName || '*');
        for(var i = 0; i < elements.length; i++) {
          if(this.hasClass(elements[i], className)) {
            collection.push(elements[i]);
          }
        }
        return collection;
      } else {
        return searchScope.getElementsByTagName(selector);
      }
    }
  }
}

/*
 * FontResize Event
 */
FontResize = (function(window,document){
  var randomID = 'font-resize-frame-' + Math.floor(Math.random() * 1000);
  var resizeFrame = document.createElement('iframe');
  resizeFrame.id = randomID; resizeFrame.className = 'font-resize-helper';
  resizeFrame.style.cssText = 'position:absolute;width:100em;height:10px;top:-9999px;left:-9999px;border-width:0';
  
  // wait for page load
  function onPageReady() {
    document.body.appendChild(resizeFrame);
    
    // use native IE resize event if possible
    if (/MSIE (6|7|8)/.test(navigator.userAgent)) {
      resizeFrame.onresize = function() {
        window.FontResize.trigger(resizeFrame.offsetWidth / 100);
      }
    }
    // use script inside the iframe to detect resize for other browsers
    else {
      var doc = resizeFrame.contentWindow.document;
      doc.open();
      doc.write('<scri' + 'pt>window.onload = function(){var em = parent.document.getElementById("' + randomID + '");window.onresize = function(){if(parent.FontResize){parent.FontResize.trigger(em.offsetWidth / 100);}}};</scri' + 'pt>');
      doc.close();
    }
    
  }
  if(window.addEventListener) window.addEventListener('load', onPageReady, false);
  else if(window.attachEvent) window.attachEvent('onload', onPageReady);
  
  // public interface
  var callbacks = [];
  return {
    onChange: function(f) {
      if(typeof f === 'function') {
        callbacks.push(f);
      }
    },
    trigger: function(em) {
      for(var i = 0; i < callbacks.length; i++) {
        callbacks[i](em);
      }
    }
  }
}(this, document));
 
if (window.addEventListener) window.addEventListener("load", initBlocksHeight, false);
else if (window.attachEvent) window.attachEvent("onload", initBlocksHeight);
