#
# Command: box util test [<arg>]
#

if isJSON ; then
    echo "JSON! :-)"
else
    echo "No json. :-("
fi



exit


unzip -qq -n "${project_dir}/snapshots/${snapshot_file}" -d "${tmp_dir}" -x "wp-content/uploads/*"

rsync -avz --no-perms --no-owner --no-group --ignore-existing -q "${tmp_dir}/" "${webroot_path}"

rm -rf "${tmp_dir}"

mv "${webroot_path}/wp-content/mysql.sql" "sql/initial.sql"


cd www
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






# Get the Box IP
#box_ip_file="$(pwd)/IP"
#box_ip="$(if [ -f "${box_ip_file}" ] ; then cat "${box_ip_file}" ; fi)"
#if [ -n "${box_ip}" ] ; then 
#	project_json+=",\n\t\"box\": {\n\t\t\"ip_address\": \"${box_ip}\"\n\t}"
#fi

