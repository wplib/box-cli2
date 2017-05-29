#
# Command: box util get-webroot-path
#

local="$(box util get-project-info ".hosts.roles.local")"
hasError && exit 1
webroot_path="$(box util get-project-info ".hosts.list.${local}.webroot_path")" 
hasError && exit 1
echo -e "${webroot_path}"
setQuiet
