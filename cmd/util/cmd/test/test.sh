#
# Command: box util test [<arg>]
#

tmp_dir="/tmp/boxcli/snapshots/tmp"
mkdir -p "${tmp_dir}"

snapshot_file="site-archive-rentblog-live-2017-05-13-3am-UTC.zip"
unzip -qq "${project_dir}/snapshots/${snapshot_file}"  -d "${tmp_dir}"

rsync -avz --no-perms --no-owner --no-group --ignore-existing -q "${tmp_dir}/" "${project_dir}/www"

cd "${project_dir}/www"

mkdir -p wp
mv wp-admin/    wp/wp-admin
mv wp-includes/ wp/wp-includes
mv wp-content/  content

sed -i.bak 's/\/wp-blog-header/\/wp\/wp-blog-header/' index.php

rm license.txt
rm readme.html
rm xmlrpc.php
rm wp-config-sample.php


mv wp-*.php wp
mv wp/wp-config.php .

wget https://raw.githubusercontent.com/wplib/wplib-box/0.14.0/Vagrantfile
# Fix stupid problem
sed -i.bak 's/0.13.0/0.14.0' index.php

rm *.bak

