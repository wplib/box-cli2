#
# Command: box util get-webroot-path
#

local="$(box util get-project-info ".hosts.roles.local")"

webroot_path="$(box util get-project-info ".hosts.list.${local}.webroot_path")" 

echo -e "${webroot_path}"

exit

