// ==UserScript==
// @name         Anti-PopAds
// @namespace    *
// @description  PopAds are slimey fucks who won't honour obvious attempts to deny their attempts to run code on _our_ machines. Override some of the crap they use
// @author       B Tasker
// @match        *
// @grant        none
// @version 	 1.3
// @downloadURL  https://www.bentasker.co.uk/adblock/greasemonkey/antiPopAds2017.user.js
// @updateURL    https://www.bentasker.co.uk/adblock/greasemonkey/antiPopAds2017.user.js
// ==/UserScript==

/* PopAds can very seriously go fuck themselves */
Object.defineProperty(window, '_pao', {value: function parse() {console.log('PopAds Detected');}});
Object.defineProperty(window, '_pop',{value: function parse() {console.log('PopAdsDetected');}} );
Object.defineProperty(window, 'popns',{value: function parse() {console.log('PopAdsDetected');}} );

console.log("Loaded");
