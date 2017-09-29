#
# Command: box pantheon promote <message> <direction> <environment>
#

message="${1:-}"
direction="${2:-}"
environment="${3:-}"

if [ "" == "${message}" ] ; then
    echo "You must provide a message as 1st parameter"
fi

if [ "to" != "${direction}" ] ; then
    echo "You must provide a direction as 2nd parameter and it must have a value of 'to'."
fi

[[ "test" == "${environment}" ]] && SYNC="--sync-content" || SYNC=""
echo
echo "terminus env:deploy ${SYNC} --cc --note=\"${message}\" ${environment}"
echo
terminus env:deploy ${SYNC} --cc --note="${message}" "${environment}"
