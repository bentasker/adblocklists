// ==UserScript==
// @name         Anti-WebUSB API
// @namespace    *
// @description  I've no need or interest in having WebUSB. In fact, quite the opposite - I don't want it
// @author       B Tasker
// @match        *://*/*
// @grant        none
// @version 	 1.2
// @downloadURL  https://www.bentasker.co.uk/adblock/greasemonkey/antiWebUSB.user.js
// @updateURL    https://www.bentasker.co.uk/adblock/greasemonkey/antiWebUSB.user.js
// ==/UserScript==

Object.defineProperty(window.navigator, 'usb', {value: function requestDevice(){console.log('USB access attempt');}});
Object.defineProperty(window.navigator.usb, 'requestDevice', {value: function requestDevice(){console.log('USB access attempt');}});
Object.defineProperty(window.navigator.usb, 'getDevices', {value: function getDevices(){console.log('USB access attempt');}});


