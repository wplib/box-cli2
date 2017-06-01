#
# Command: box util get-content-path
#

local="$(box util get-project-info ".hosts.roles.local")"

content_path="$(box util get-project-info ".wordpress.hosts.list.${local}.core_path")"

echo -e "${content_path%/}"
exit

