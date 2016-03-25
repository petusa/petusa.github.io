#!/bin/bash
echo "<style>body{margin:0;padding:0;background-color:white;} #content{padding:10px;position:absolute;width:100%;height:100%;background-color:white;z-index:99;}</style>"
echo "<div id='content'>Please wait while publishing this preview version as the main page on Google Bucket. It may take minutes...</div>"
CONTEXT=""
. ./ds-wp-publish-to-gbucket.sh "$1"
echo "<script>var c=document.getElementById('content');</script>"
echo "<script>c.innerHTML='Your web page seems to be ready. Have a look at it <a target="_blank" href=\"http://"${CONTEXT}"\">here</a>.';</script>"
echo "<script>c.innerHTML+='<br><a href=\"javascript:void(0)\" onclick=\"c.style.zIndex=\'-1\';c.style.visibility=\'hidden\'\">Check the logs here</a>.';</script>"