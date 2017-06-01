#@IgnoreInspection BashAddShebang
#
# Importer for a WPEngine Site Full Backup
#
import_filepath="$1"
recognizer_json="$2"
tmp_dir="$3"
tmp_dir="${tmp_dir%/}"
project_filepath="$(pwd)"


project_dir="$(pushProjectDir)"
hasError && exit 1

webroot_path="$(getWebrootPath)"
hasError && exit 1
webroot_dir="${project_dir%/}/${webroot_path}"

content_path="$(getContentPath)"
hasError && exit 1

core_path="$(getCorePath)"
hasError && exit 1

#import_content_path="$(readJsonValue "${recognizer_json}" ".content_path")"
hasError && exit 1

#
# Unzip import file to tmp directory.
# Ignore uploads because we'll use live site instead
#
statusMsg "Unzipping import file..."
unzip -qq -n "${import_filepath}" -d "${tmp_dir}" -x "wp-content/uploads/*"

statusMsg "Fixing permissions"
find "${tmp_dir}"/. -type d -exec chmod 755 {} \;
find "${tmp_dir}"/. -type f -exec chmod 644 {} \;


#
# Rsyncing file to actuals directory.
# This code strips permissions and ownership from the zip file
#
#rsync -avz --no-perms --no-owner --no-group --ignore-existing -q "${tmp_dir}/" "${webroot_dir}"

statusMsg "Moving files from temp to project dir..."

mkdir -p archive
mkdir -p sql

#
# WPEngine puts the database into the ZIP file in /wp-content/ as mysql.sql
#
mv "${tmp_dir}/wp-content/mysql.sql" "sql/initial.sql"

cd "${webroot_path}"
mv "${tmp_dir}/index.php" .
mv "${tmp_dir}/wp-config.php" .
mv "${tmp_dir}/robots.txt" .

cd "${content_path}"
mv "${tmp_dir}/wp-content/*" .
rm -rf "${tmp_dir}/wp-content"

cd "${core_path}"
mv "${tmp_dir}/wp-admin" .
mv "${tmp_dir}/wp-includes" .
mv "${tmp_dir}/wp-*.php" .
mv "${tmp_dir}/xmlrpc.php" .

cd archive
mv "${tmp_dir}/license.txt" .
mv "${tmp_dir}/readme.html" .
mv "${tmp_dir}/*" .

cd "${project_dir}"



popProjectDir