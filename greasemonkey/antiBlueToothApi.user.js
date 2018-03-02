// ==UserScript==
// @name         Anti-Bluetooth API
// @namespace    *
// @description  I've no need or interest in having the bluetooth API. Needs to be tested on an up-to-date Chrome to check whether this works
// @author       B Tasker
// @match        *://*/*
// @grant        none
// @version 	 1.2
// @downloadURL  https://www.bentasker.co.uk/adblock/greasemonkey/antiBlueToothApi.user.js
// @updateURL    https://www.bentasker.co.uk/adblock/greasemonkey/antiBlueToothApi.user.js
// ==/UserScript==

Object.defineProperty(window.navigator, 'bluetooth', {value: function requestDevice(){console.log('Bluetooth access attempt');}});
Object.defineProperty(window.navigator.bluetooth, 'requestDevice', {value: function requestDevice(){console.log('Bluetooth access attempt');}});
