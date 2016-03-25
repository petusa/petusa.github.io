#!/bin/bash
echo "<style>body{margin:0;padding:0;background-color:white;} #content{padding:10px;position:absolute;width:100%;height:100%;background-color:white;z-index:99;}</style>"
echo "<div id='content'>Please wait while generating the Google Bucket hosted preview version for the current WP Site... (it may take minutes)</div>"
CONTEXT=""
. /srv/ds-wp-preview-on-gbucket.sh "$1"
echo "<script>var c=document.getElementById('content');</script>"
echo "<script>c.innerHTML='Your web page seems to be ready. Have a look at it <a target="_blank" href=\"http://"${CONTEXT}"\">here</a>.';</script>"
echo "<script>c.innerHTML+='<br><a href=\"javascript:void(0)\" onclick=\"c.style.zIndex=\'-1\';c.style.visibility=\'hidden\'\">Check the logs here</a>.';</script>"