#
# Command: box util install-wordpress-core
#

project_dir="$(getSwitchValue "project_dir")"
# @todo Test it is a valid directory
if isEmpty "${project_dir}"; then
    strErr "You must specify a project dir."
    exit 1
fi

#
# @TODO Get these from the project.json file
#
webroot_dir="$(getSwitchValue "webroot_dir" "${project_dir}/www")"
# @todo Test not empty and is a valid directory
# @todo Ensure $webroot_dir within $project_dir

core_dir="$(getSwitchValue "core_dir" "${project_dir}/www/wp")"
# @todo Test not empty and is a valid directory
# @todo Ensure $core_dir within $project_dir

content_dir="$(getSwitchValue "content_dir" "${project_dir}/www/content")"
# @todo Test not empty and is a valid directory
# @todo Ensure $content_dir within $project_dir

boot_dir="$(getSwitchValue "boot_dir" "${project_dir}/www")"
# @todo Test not empty and is a valid directory
# @todo Ensure $content_dir within $project_dir

config_dir="$(getSwitchValue "config_dir" "${project_dir}/www/config")"
# @todo Test not empty and is a valid directory
# @todo Ensure $content_dir within $project_dir

#
# Paths in this script are root relative to webroot_dir.
#
# They gave leading / but no trailing /, or are empty
#
#   core_path is the path to core from the webroot_dir
#   content_path is the path to plugins/themes/etc dir from the webroot_dir
#   boot_path is the path to wp-config.php from the webroot_dir
#   boot_path is the path to secrets from the webroot_dir
#
# @example #1: WordPress Default
#   $project_dir    => /{hostroot_dir}/example.dev
#   $webroot_dir    => /{hostroot_dir}/example.dev
#   $core_dir       => /{hostroot_dir}/example.dev
#   $content_dir    => /{hostroot_dir}/example.dev/wp-content
#   $boot_dir       => /{hostroot_dir}/example.dev
#   $config_dir     => /{hostroot_dir}/example.dev
#   $core_path      =>
#   $content_path   => /wp-content
#   $boot_path      => 
#   $config_path    => 
#
# @example #2: WordPress Skeleton
#   $project_dir    => /{hostroot_dir}/example.dev
#   $webroot_dir    => /{hostroot_dir}/example.dev/www
#   $core_dir       => /{hostroot_dir}/example.dev/www/wp
#   $content_dir    => /{hostroot_dir}/example.dev/www/content
#   $boot_dir       => /{hostroot_dir}/example.dev/www/
#   $config_dir     => /{hostroot_dir}/example.dev/www/config
#   $core_path      => /wp
#   $content_path   => /content
#   $boot_path      => /
#   $config_path    => /config
#
# @example #3: Pantheon
#   $project_dir    => /{hostroot_dir}/example.dev
#   $webroot_dir    => /{hostroot_dir}/example.dev/web
#   $core_dir       => /{hostroot_dir}/example.dev/web
#   $content_dir    => /{hostroot_dir}/example.dev/web/wp-content
#   $boot_dir       => /{hostroot_dir}/example.dev
#   $config_dir     => /{hostroot_dir}/example.dev/private
#   $core_path      =>
#   $content_path   => /wp-content
#   $boot_path      => 
#   $config_path    => /private
#
# @example #4: WordPress default w/config outside of webroot
#   $project_dir    => /{hostroot_dir}/example.dev
#   $webroot_dir    => /{hostroot_dir}/example.dev
#   $core_dir       => /{hostroot_dir}/example.dev
#   $content_dir    => /{hostroot_dir}/example.dev/wp-content
#   $boot_dir       => /{hostroot_dir}
#   $config_dir     => /{hostroot_dir}/config
#   $core_path      =>
#   $content_path   => /wp-content
#   $boot_path      => /..
#   $config_path    => /../config
#

core_path="${core_dir#$webroot_dir}"
content_path="${content_dir#$webroot_dir}"
boot_path="$(getRelativePath "${webroot_dir}" "${boot_dir}")"
config_path="$(getRelativePath "${webroot_dir}" "${config_dir}")"

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
# Create the index.php in webroot
#
php="$(cat <<PHP
<?php
/**
 * Front to the WordPress application. This file doesn't do anything, but loads
 * wp-blog-header.php which does and tells WordPress to load the theme.
 *
 * @package WordPress
 */

/**
 * Tells WordPress to load the WordPress theme and output it.
 *
 * @var bool
 */
define( 'WP_USE_THEMES', true );

/**
 * Loads the WordPress Environment and Template
 * Note: The following filepath my be modified from WordPress
 *       core to support an optionally different ABSPATH.
 */
require( __DIR__ . '${core_path}/wp-blog-header.php' );
PHP
)"
echo "${php}" > ${webroot_dir}/index.php

#
# Create the config-loader.php in webroot
#
cp "${BOXCLI_COMMAND_DIR}/files/config-loader.php" "${webroot_dir}"

#
# @TODO generate a salt file for wp-config.php to load
# https://api.wordpress.org/secret-key/1.1/salt/
#

echo "${content_path}" > "${webroot_dir}/CONTENT_PATH"

#
# Create the config-{hostname}.php in config_dir
# @TODO Loop through and generate one for each server
# @TODO Extract this into a standalone command
# @TODO Create a default one of these and load it first
#
php="$(cat <<PHP
<?php

return array(
	'WP_DEBUG' =>           '${wp_debug}',

	'CORE_PATH' =>          realpath( '${core_path}' ),
	'BOOT_PATH' =>          realpath( '${boot_path}' ),
	'CONTENT_PATH' =>       realpath( '${content_path}' ),
	'CONFIG_PATH' =>        realpath( '${config_path}' ),
	
    'CORE_DIR' =>           realpath( '${core_dir}' ),
	'BOOT_DIR' =>           realpath( '${boot_dir}' ),
	'CONTENT_DIR' =>        realpath( '${content_dir}' ),
	'CONFIG_DIR' =>         realpath( '${config_dir}' ),

	'WP_HOME' =>            '${wp_home}',
	'WP_SITEURL' =>         '${wp_siteurl}',
	'WP_CONTENT_DIR' =>     '${content_dir}',
	'WP_CONTENT_URL' =>     '${wp_content_url}',
	
	'DB_NAME' =>            '${db_name}',
	'DB_USER' =>            '${db_user}',
	'DB_PASSWORD' =>        '${db_password}',
	'DB_HOST' =>            '${db_host}',
	'DB_CHARSET' =>         '${db_charset}',
	'DB_COLLATE' =>         '${db_collate}',
	
	'DISALLOW_FILE_EDIT' => '${disallow_file_edit}',
	
	'TABLE_PREFIX' =>        '${table_prefix}',
	
);
PHP
)"
echo "${php}" > ${webroot_dir}/config-values.php


#
# Copy the root files to the root
#
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





