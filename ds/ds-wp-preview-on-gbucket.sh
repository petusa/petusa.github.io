#!/bin/bash
website=$1
[ ! "$website" ] && echo "Please provide an existing WP website domain, e.g. gapps-in.doctusoft.com" && exit 1
target_bucket_root=$2
[ ! "$target_bucket_root" ] && echo "Please provide a target domain where your WP website should be uploaded, e.g. gapps.doctusoft.com" && exit 1
target_version_folder=v
workdir=/srv/ds_wp_websites
additional_links_file=wp-additional-links.txt
httrack_work_folder=httrack-work-folder
echo "workdir set to $workdir"
echo ""
echo "1. Grabbing static content from source website..."
echo ""
START=$(date +%s)
httrack --update -X -C2 http://$website -c16 -A2500000 -O $workdir/$httrack_work_folder
END=$(date +%s)
DIFF=$(($END - $START))
echo ""
echo "finished (in $DIFF seconds)"
echo ""
echo "2. Grabbing additional files (robots.txt, ...) listed in $additional_link_file"
echo ""
sed -e "s/^/http:\/\/${website}\//" $additional_links_file | xargs wget -N --directory-prefix=$workdir/$httrack_work_folder/$website
echo ""
echo "finished"
echo ""
echo "3. Grabbing sitemap files..."
echo ""
echo "TODO change sitemap file to a non WP/Yoast SEO style"
wget --quiet "http://${website}/sitemap_index.xml" --output-document - | egrep -o "https?://[^<]+" | wget -i - -N --directory-prefix=$workdir/$httrack_work_folder/$website
echo ""
echo "finished"
echo ""
echo "4. Creating versioned folder..."
echo ""
now=$(date +%Y_%m_%d_%H%M%S)
destination_folder=$target_bucket_root/$target_version_folder/$now
mkdir -p $workdir/$destination_folder
cp -a $workdir/httrack-work-folder/$website/* $workdir/$destination_folder
echo "folder created: '$destination_folder'"
echo ""
echo "5. Making extra transformations on versioned folder content..."
echo ""
echo 'grep -rl "http://${website}" $workdir/$website/$now/ | xargs sed -i "s/http:\/\/${website}/http:\/\/${target_bucket_root}\/${target_version_folder}\/${now}/g"'
grep -rl "http://${website}" $workdir/$destination_folder/ | xargs sed -i "s/http:\/\/${website}/http:\/\/${target_bucket_root}\/${target_version_folder}\/${now}/g"
echo ""
echo "TODO: temporarily rewriting js/gapps/elision specific theme root"
grep -rli --include \*.js "theme_root = 'wp-content" $workdir/$destination_folder/ | xargs sed -i "s/theme_root = 'wp-content\/themes\/elision\/index.html'/theme_root = 'http:\/\/${target_bucket_root}\/${target_version_folder}\/${now}\/wp-content\/themes\/elision\/'/g"
echo "transformations done"
echo ""
echo "Fixing canonical urls in index.html pages"
echo ""
current=$(pwd)
cd $workdir
# creates: <link rel="canonical" href="index.html" />   ==>>   <link rel="canonical" href="http://gapps.doctusoft.com/v/2016_04_04_155037/biztonsag/" />
grep -rli --include index.html "<link rel=\"canonical\"" $destination_folder/ | sed "s/index.html$//" | xargs -I {INPUT} sed -i "s|<link rel=\"canonical\" href=\"index.html\"|<link rel=\"canonical\" href=\"http:\/\/{INPUT}\"|g" ${workdir}/{INPUT}/index.html #sed -i "s|<link rel=\"canonical\" href=|<link rel=\"canonical\" href=\"http:\/\/{INPUT}\"|g" ${${workdir}/{INPUT}/index.html}
cd $current
echo ""
echo "finished"
echo
echo "TODO: temporarily copying wp-content from local server folder"
echo ""
echo $workdir
echo $destination_folder
/root/gsutil/gsutil -m rsync -C -r /var/www/html/googleapps.doctusoft.com/www/wp-content/uploads/ $workdir/$destination_folder/wp-content/uploads
echo ""
echo "6. Uploading versioned folder to a target Google test bukcet..."
echo ""
START=$(date +%s)
/root/gsutil/gsutil -m rsync -r $workdir/$target_bucket_root/$target_version_folder/ gs://$target_bucket_root/$target_version_folder
END=$(date +%s)
DIFF=$(($END - $START))
echo ""
echo "finished (in $DIFF seconds)"
echo ""
echo "Please check the website hosted from test bucket: $destination_folder. Set it as the default if no error found."
echo ""
CONTEXT=$destination_folder