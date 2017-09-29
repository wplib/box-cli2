#
# Command: box pantheon deploy <environment> <message>
#

environment="${1:-}"
message="${2:-}"

if [ "" == "${message}" ] ; then
    echo "You must provide a deploy message"
fi
[[ "test" == "${environment}" ]] && SYNC="--sync-content" || SYNC=""
echo
echo "terminus env:deploy ${SYNC} --cc --note=\"${message}\" ${environment}"
echo
terminus env:deploy ${SYNC} --cc --note="${message}" "${environment}"
