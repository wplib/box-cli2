#
# Command: box util read-project-dir
#

project_file=$(box util find-project-file)
jq -r "$1" "${project_file}"
exit

