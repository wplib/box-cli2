#
# Command: box util get-local-host-id
#

echo -e "$(box util read-project-file ".hosts.roles.local")"
exit

