#
# Command: box util install-wordpress-core
#


cd ~/Sites/
rm -rf ~/Sites/test.dev/
mkdir -p ~/Sites/test.dev/
cd ~/Sites/test.dev/

project_dir="$(pwd)"
webroot_dir="${project_dir}/www"
core_dir="${webroot_dir}/wp"
content_dir="${webroot_dir}/content"

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





