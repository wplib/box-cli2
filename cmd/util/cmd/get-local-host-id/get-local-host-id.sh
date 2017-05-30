#
# Command: box util get-local-host-id
#

echo -e "$(box util read-project-file-value ".hosts.roles.local")"
exit

