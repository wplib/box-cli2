#
# Command: box util get-content-path
#

local="$(box util get-project-info ".hosts.roles.local")"

content_path="$(box util get-project-info ".hosts.list.${local}.content_path")" 

stdOut "${content_path}"
exit

