#
# Command: box util install-wordpress-core
#

project_dir="$(getSwitchValue "project_dir")"
# @todo Test it is a valid directory
if isEmpty "${project_dir}"; then
    strErr "You must specify a project dir."
    exit 1
fi

webroot_dir="$(getSwitchValue "webroot_dir" "${project_dir}/www")"
# @todo Test not empty and is a valid directory
# @todo Ensure $webroot_dir within $project_dir

core_dir="$(getSwitchValue "core_dir" "${project_dir}/www/wp")"
# @todo Test not empty and is a valid directory
# @todo Ensure $core_dir within $project_dir

content_dir="$(getSwitchValue "content_dir" "${project_dir}/www/content")"
# @todo Test not empty and is a valid directory
# @todo Ensure $content_dir within $project_dir

config_dir="$(getSwitchValue "config_dir" "${project_dir}/www")"
# @todo Test not empty and is a valid directory
# @todo Ensure $content_dir within $project_dir

secrets_dir="$(getSwitchValue "secrets_dir" "${project_dir}/www/config")"
# @todo Test not empty and is a valid directory
# @todo Ensure $content_dir within $project_dir

#
# Paths in this script are root relative to webroot_dir.
#
# They gave leading / but no trailing /, or are empty
#
#   core_path is the path to core from the webroot_dir
#   content_path is the path to plugins/themes/etc dir from the webroot_dir
#   config_path is the path to wp-config.php from the webroot_dir
#   config_path is the path to secrets from the webroot_dir
#
# @example #1: WordPress Default
#   $project_dir    => /{hostroot_dir}/example.dev
#   $webroot_dir    => /{hostroot_dir}/example.dev
#   $core_dir       => /{hostroot_dir}/example.dev
#   $content_dir    => /{hostroot_dir}/example.dev/wp-content
#   $config_dir     => /{hostroot_dir}/example.dev
#   $secrets_dir    => /{hostroot_dir}/example.dev
#   $core_path      =>
#   $content_path   => /wp-content
#   $config_path    => 
#   $secrets_path   => 
#
# @example #2: WordPress Skeleton
#   $project_dir    => /{hostroot_dir}/example.dev
#   $webroot_dir    => /{hostroot_dir}/example.dev/www
#   $core_dir       => /{hostroot_dir}/example.dev/www/wp
#   $content_dir    => /{hostroot_dir}/example.dev/www/content
#   $config_dir     => /{hostroot_dir}/example.dev/www/
#   $secrets_dir    => /{hostroot_dir}/example.dev/www/config
#   $core_path      => /wp
#   $content_path   => /content
#   $config_path    => /
#   $secrets_path   => /config
#
# @example #3: Pantheon
#   $project_dir    => /{hostroot_dir}/example.dev
#   $webroot_dir    => /{hostroot_dir}/example.dev/web
#   $core_dir       => /{hostroot_dir}/example.dev/web
#   $content_dir    => /{hostroot_dir}/example.dev/web/wp-content
#   $config_dir     => /{hostroot_dir}/example.dev
#   $secrets_dir    => /{hostroot_dir}/example.dev/private
#   $core_path      =>
#   $content_path   => /wp-content
#   $config_path    => 
#   $secrets_path   => /private
#
# @example #4: WordPress default w/config outside of webroot
#   $project_dir    => /{hostroot_dir}/example.dev
#   $webroot_dir    => /{hostroot_dir}/example.dev
#   $core_dir       => /{hostroot_dir}/example.dev
#   $content_dir    => /{hostroot_dir}/example.dev/wp-content
#   $config_dir     => /{hostroot_dir}
#   $secrets_dir    => /{hostroot_dir}/config
#   $core_path      =>
#   $content_path   => /wp-content
#   $config_path    => /..
#   $secrets_path   => /../config
#

core_path="${core_dir#$webroot_dir}"
content_path="${content_dir#$webroot_dir}"
config_path="$(getRelativePath "${webroot_dir}" "${config_dir}")"
secrets_path="$(getRelativePath "${webroot_dir}" "${secrets_dir}")"

stdOut "Downloading WordPress..."

#
# Download WordPress core
#
wp_filepath="$(box util download-wordpress)"
hasError && exit 1

#
# Define a tmp dir to copy WordPress core .tar.gz
# file into from download cache.
# It will be deleted automatically after this box
# command is run.
#
tmpDir="${BOXCLI_TEMP_DIR}/wp-core"
rm -rf "${tmpDir}"
mkdir -p "${tmpDir}"

#
# Copy WordPress core .tar.gz file from download cache
#
cp "${wp_filepath}" "${tmpDir}"

#
# Grab the full filepath to this copy of WordPress core
#
wp_filepath="${tmpDir}/$(basename "${wp_filepath}")"

#
# Get a tmp directory name within the project
#
wordpress_tmp_dir="$(mktemp -d "${project_dir}/tmp-XXXX")"

#
# Unzip the copy of WordPress core into the tmp
# directory name within the project
#
tar -xzf "${wp_filepath}" -C "${wordpress_tmp_dir}"

#
# Ensure all our expected directories are available
#
mkdir -p "${project_dir}"
mkdir -p "${project_dir}/archive"
mkdir -p "${project_dir}/sql"
mkdir -p "${webroot_dir}"
mkdir -p "${core_dir}"
mkdir -p "${content_dir}"
mkdir -p "${content_dir}/mu-plugins"
mkdir -p "${content_dir}/plugins"
mkdir -p "${content_dir}/themes"
mkdir -p "${content_dir}/uploads"

#
# Name the subdir created by unzipping WordPress core
# This is where WordPress code source files will exist
#
wordpress_dir="${wordpress_tmp_dir}/wordpress"

#
# Now copy WordPress core source files
# as specified in project.json
#

#
# Copy the root files to the root
# @todo These will need to be modifies and/or replaced
#
mv "${wordpress_dir}/index.php" "${webroot_dir}"
mv "${wordpress_dir}/wp-config-sample.php" "${webroot_dir}"

#
# Copy the content dir to the appropriate place
#
mv "${wordpress_dir}/wp-content" "${content_dir}"

#
# Copy remaining core files to the core directory
#
mv "${wordpress_dir}/wp-admin" "${core_dir}"
mv "${wordpress_dir}/wp-includes" "${core_dir}"
mv "${wordpress_dir}/wp-"*.php "${core_dir}"
mv "${wordpress_dir}/"* "${core_dir}"

#
# Clean up and delete the tmp dir that held WordPress core
#
rm -rf "${wordpress_dir}"

exit





