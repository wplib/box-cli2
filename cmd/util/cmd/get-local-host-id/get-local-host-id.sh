#
# Command: box util get-local-host-id
#

echo "$(box util read-project-file ".hosts.roles.local")"
exit
