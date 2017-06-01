#
# Command: box util get-content-dir
#

project_dir="$(box util get-project-dir)"
hasError && exit 1

content_path="$(box util get-content-path)"
hasError && exit 1

echo "${project_dir}/${content_path}"

setQuiet

exit

