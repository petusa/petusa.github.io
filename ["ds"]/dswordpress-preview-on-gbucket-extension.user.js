// ==UserScript==
// @name         dswordpress-preview-on-gbucket-extension
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Extends the Wordpress Admin pages with an Uploader button. This button makes WP to Google Bucket upload possible using webmin services in the background. The solution only works within DS internal network.
// @author       Peter Nagy
// @require      https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.6.15/browser-polyfill.min.js
// @require      https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.6.15/browser.min.js
// @require      https://code.jquery.com/jquery-2.2.0.min.js
// @match        *.doctusoft.com/wp-admin/**
// @require      https://gist.github.com/raw/2625891/waitForKeyElements.js
// ==/UserScript==

/* jshint ignore:start */
var inline_src = (<><![CDATA[
/* jshint ignore:end */
/* jshint esnext:true */

/* jshint ignore:start */

    waitForKeyElements("#preview-action", (div) => {
        console.log("found preview container");
        let button = document.createElement('a');
        button.className="preview button button-primary"; 
        button.href="https://websrv.doctusoft.com:10000/custom/run.cgi?id=1458912451&v=" + document.location.hostname;
        button.target="_blank";
        button.id="dspreview-action";
        button.innerText="Preview (Google Bucket)";
        div.append(button);
        console.log("button added...");
    });
    
]]></>).toString();
var c = babel.transform(inline_src);
eval(c.code);
/* jshint ignore:end */
