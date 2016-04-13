#!/bin/bash
[ ! "$1" ] && echo "Please provide an preview test website version, e.g. gapps.doctusoft.com/v/2016_03_25_123159" && exit 1
website=$(dirname $(dirname "$1"))
version=$(basename "$1")
version_folder=$(basename $(dirname "$1"))
workdir=/srv/ds_wp_websites
echo "website:$website"
echo "version:$version"
echo "version folder:$version_folder"
echo "workdir set to $workdir"
echo ""
echo "1. Erasing local folder content, except for version folder"
echo ""
current=$(pwd)
cd $workdir/$website
ls $workdir/$website | grep -v "${version_folder}$"
rm -r `ls $workdir/$website | grep -v "${version_folder}$"`
cd $current
echo ""
echo "finished"
echo ""
echo "2. Creating live folder content..."
echo ""
cp -r $workdir/$website/$version_folder/$version/* $workdir/$website
echo "folder content added: $website"
echo ""
echo "3. Making link transformations on live folder content..."
echo ""
grep -rl "http://${website}/${version_folder}/${version}" $workdir/$website/ --exclude-dir=${version_folder} | xargs sed -i "s/http:\/\/${website}\/${version_folder}\/${version}/http:\/\/${website}/g"
echo ""
echo "links updated"
echo ""
echo "4. Updating robots.txt..."
echo ""
echo "Disallow: /${version_folder}/" >> $workdir/$website/robots.txt
echo ""
echo "updated"
echo ""
echo "5. Uploading website folder to Google live bucket..."
echo ""
START=$(date +%s)
/root/gsutil/gsutil -m rsync -r $workdir/$website/ gs://$website
END=$(date +%s)
DIFF=$(($END - $START))
echo ""
echo "finished (in $DIFF seconds)"
echo ""
echo "Please check the live website version hosted google bucket: $website."
CONTEXT=$website