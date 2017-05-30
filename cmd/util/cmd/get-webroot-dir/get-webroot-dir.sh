#
# Command: box util get-webroot-dir
#

project_dir="$(pushProjectDir)"
hasError && exit 1

webroot_path="$(getWebrootPath)"
hasError && exit 1

echo "${project_dir%/}/${webroot_path}"

setQuiet
