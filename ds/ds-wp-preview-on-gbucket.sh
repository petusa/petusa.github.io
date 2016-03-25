#!/bin/bash
website=$1
[ ! "$website" ] && echo "Please provide an existing WP website domain, e.g. gapps-in.doctusoft.com" && exit 1
target_bucket_root=gapps.doctusoft.com
target_version_folder=v
workdir=/srv/ds_wp_websites
echo "workdir set to $workdir"
echo ""
echo "1. Grabbing static content from source website..."
echo ""
START=$(date +%s)
httrack --update -X -C2 http://$website -c16 -A2500000 -O $workdir/httrack-work-folder
END=$(date +%s)
DIFF=$(($END - $START))
echo ""
echo "finished (in $DIFF seconds)"
echo ""
echo "2. Creating versioned folder..."
echo ""
now=$(date +%Y_%m_%d_%H%M%S)
#now=2016_03_24_123701
destination_folder=$target_bucket_root/$target_version_folder/$now
mkdir -p $workdir/$destination_folder
cp -a $workdir/httrack-work-folder/$website/* $workdir/$destination_folder
echo "folder created: '$destination_folder'"
echo ""
echo "3. Making extra transformations on versioned folder content..."
echo ""
echo 'grep -rl "http://${website}" $workdir/$website/$now/ | xargs sed -i "s/http:\/\/${website}/http:\/\/${target_bucket_root}\/${target_version_folder}\/${now}/g"'
grep -rl "http://${website}" $workdir/$destination_folder/ | xargs sed -i "s/http:\/\/${website}/http:\/\/${target_bucket_root}\/${target_version_folder}\/${now}/g"
echo ""
echo "TODO: termprarily rewriting js/gapps/elision specific theme root"
grep -rli --include \*.js "theme_root = 'wp-content" $workdir/$destination_folder/ | xargs sed -i "s/theme_root = 'wp-content\/themes\/elision\/index.html'/theme_root = 'http:\/\/${target_bucket_root}\/${target_version_folder}\/${now}\/wp-content\/themes\/elision\/'/g"
echo "transformations done"
echo ""
echo "TODO: tempararily copying wp-content from local server folder"
echo ""
echo $workdir
echo $destination_folder
gsutil -m rsync -C -r /var/www/html/googleapps.doctusoft.com/www/wp-content/uploads/ $workdir/$destination_folder/wp-content/uploads
echo ""
echo "4. Uploading versioned folder to a target Google test bukcet..."
echo ""
START=$(date +%s)
#gsutil -m cp -r $workdir/$destination_folder gs://$target_bucket_root/$target_version_folder/$now
gsutil -m rsync -r $workdir/$target_bucket_root/$target_version_folder/ gs://$target_bucket_root/$target_version_folder
END=$(date +%s)
DIFF=$(($END - $START))
echo ""
echo "finished (in $DIFF seconds)"
echo ""
echo "Please check the website hosted from test bucket: $destination_folder. Set it as the default if no error found."
echo ""
CONTEXT=$destination_folder