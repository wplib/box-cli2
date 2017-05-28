#
# Command: box util get-local-host-id
#

echo -e "$(box util read-project-value ".hosts.roles.local")"
exit

