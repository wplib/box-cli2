#
# Command: box util get-local-domain
#

local="$(box util get-project-info ".hosts.roles.local" "local")"
content_path="$(box util get-project-info ".hosts.list.${local}.domain")" 

echo -e "${content_path}"
exit


