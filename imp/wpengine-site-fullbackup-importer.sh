#@IgnoreInspection BashAddShebang
#
# Importer for a WPEngine Site Full Backup
#
import_filepath="$1"
recognizer_json="$2"

#
# Make damn sure our $tmp_dir is not empty
#
tmp_dir="$3"
tmp_dir="${tmp_dir%/}"
tmp_dir="${tmp_dir:-"${BOXCLI_TEMP_DIR}"}"
if isEmpty "${tmp_dir}" ; then
    stdErr "The TEMP directory passed to WPEngine Site Full Backup importer is empty."
    exit 1
fi
project_filepath="$(pwd)"

project_dir="$(pushProjectDir)"
hasError && exit 1

webroot_path="$(getWebrootPath)"
hasError && exit 1
webroot_dir="${project_dir%/}/${webroot_path}"

content_path="$(getContentPath)"
hasError && exit 1
content_dir="${project_dir%/}/${content_path}"

core_path="$(getCorePath)"
hasError && exit 1
core_dir="${project_dir%/}/${core_path}"

archive_path="archive"
archive_dir="${project_dir}/${archive_path}"
#
# Unzip import file to tmp directory.
# Ignore uploads because we'll use live site instead
#
statusMsg "Unzipping import file..."
unzip -qq -n "${import_filepath}" -d "${tmp_dir}" -x "wp-content/uploads/*"

#
# Rsyncing file to actuals directory.
# This code strips permissions and ownership from the zip file
#
#rsync -avz --no-perms --no-owner --no-group --ignore-existing -q "${tmp_dir}/" "${webroot_dir}"

statusMsg "Moving files to the project directory..."
ensureDir "archive"
ensureDir "sql"

#
# WPEngine puts the database into the ZIP file in /wp-content/ as mysql.sql
#
if [ -f "${tmp_dir}/wp-content/mysql.sql" ] ; then
    ensureDir "sql"
    moveFiles "${tmp_dir}/wp-content/mysql.sql" "sql/project.sql"
fi

changeAbsDir "${webroot_dir}"
moveFiles "${tmp_dir}/index.php"
moveFiles "${tmp_dir}/wp-config.php"
moveFiles "${tmp_dir}/robots.txt"

changeAbsDir "${content_dir}"
moveFiles "${tmp_dir}/wp-content/*"
removeDir "${tmp_dir}/wp-content"
ensureDir "uploads"
ensureDir "logs"

changeAbsDir "${core_dir}"
moveFiles "${tmp_dir}/wp-*.php"
moveFiles "${tmp_dir}/wp-admin"
moveFiles "${tmp_dir}/wp-includes"
moveFiles "${tmp_dir}/xmlrpc.php"

changeAbsDir "${archive_dir}"
moveFiles "${tmp_dir}/license.txt"
moveFiles "${tmp_dir}/readme.html"
moveFiles "${tmp_dir}/*"

statusMsg "Removing old backup files..."
for item in "${content_dir}"/* ; do
    [ -f "${item}" ] && continue
    if [[ "${item}" =~ /backupwordpress-[^-]+-backups$ ]] ; then
        removeDir "${item}"
    fi
done;

statusMsg "Fixing file permissions..."
find "${webroot_dir}/." -type f -exec chmod 644 {} \;

statusMsg "Fixing folder permissions..."
find "${webroot_dir}/." -type d -exec chmod 755 {} \;

#
# Now run Vagrant to bring up a WPLib Box using VirtualBox
#
changeAbsDir "${project_dir}"
vagrant up
hostname="$(cat HOSTNAME)"
open "http://${hostname}/wp/wp-admin"


#TODO
# Handle /www/blog
# Handle adding reference to updating to define( 'DB_HOST', '172.17.0.1' );
# In BOX
#   mysql -e "SET GLOBAL show_compatibility_56=ON;"
#   box import-db project.sql