// ==UserScript==
// @name         dswordpress-deploy-to-gbucket-extension
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Extends the Wordpress Admin pages with an Uploader button. This button makes WP to Google Bucket upload possible using webmin services in the background. The solution only works within DS internal network.
// @author       Peter Nagy
// @require      https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.6.15/browser-polyfill.min.js
// @require      https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.6.15/browser.min.js
// @require      https://code.jquery.com/jquery-2.2.0.min.js
// @match        *.doctusoft.com/v/**
// ==/UserScript==

/* jshint ignore:start */
var inline_src = (<><![CDATA[
/* jshint ignore:end */
/* jshint esnext:true */

/* jshint ignore:start */
    console.dir(document.location.pathname.split("/"));
    let pathParts = document.location.pathname.split("/");
    let version = document.location.host + "/" + pathParts[1] + "/" + pathParts[2];
    let button = document.createElement('a');
    button.className="preview button button-primary"; 
    button.href=`https://websrv.doctusoft.com:10000/custom/run.cgi?id=1458912471&v=${version}`;
    button.target="_blank";
    button.id="dspublish-action";
    button.innerText="Set it as main (Google Bucket)";
    document.body.appendChild(button);    
    GM_addStyle(
`#dspublish-action {
    box-shadow: rgb(0, 103, 153) 0px 1px 0px 0px;
    box-sizing: border-box;
    color: rgb(255, 255, 255);
    cursor: pointer;
    display: block;
    top: 10px;
    left: 10px;
    position: fixed;
    z-index: 999999;
    height: 28px;
    text-align: center;
    text-decoration: none;
    text-shadow: rgb(0, 103, 153) 0px -1px 1px, rgb(0, 103, 153) 1px 0px 1px, rgb(0, 103, 153) 0px 1px 1px, rgb(0, 103, 153) -1px 0px 1px;
    vertical-align: top;
    white-space: nowrap;
    width: 240.25px;
    perspective-origin: 84.125px 14px;
    transform-origin: 84.125px 14px;
    background: rgb(0, 133, 186) none repeat scroll 0% 0% / auto padding-box border-box;
    border-top: 1px solid rgb(0, 115, 170);
    border-right: 1px solid rgb(0, 103, 153);
    border-bottom: 1px solid rgb(0, 103, 153);
    border-left: 1px solid rgb(0, 103, 153);
    border-radius: 3px 3px 3px 3px;
    font: normal normal normal normal 13px / 26px 'Open Sans', sans-serif;
    outline: rgb(255, 255, 255) none 0px;
    padding: 0px 10px 1px;
    transition: border 0.05s ease-in-out 0s, background 0.05s ease-in-out 0s, color 0.05s ease-in-out 0s; 
}`
    );
    
]]></>).toString();
var c = babel.transform(inline_src);
eval(c.code);
/* jshint ignore:end */
