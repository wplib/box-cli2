#
# Command: box util get-local-domain
#

local="$(box util get-project-info ".hosts.roles.local" "local")"
hasError && exit 1
local_domain="$(box util get-project-info ".hosts.list.${local}.domain")"
hasError && exit 1
echo -e "${local_domain}"
setQuiet

