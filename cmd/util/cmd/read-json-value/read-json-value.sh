#@IgnoreInspection BashAddShebang
#
# Command: box util read-json-value <json> <query>
#
if (( 0 == "$#" )) ; then
    stdErr "No JSON string passed."
    exit 1
fi
if (( 1 == "$#" )) ; then
    stdErr "No JSON query passed."
    exit 1
fi

json="$1"
query="$2"

#
# Turn off error exit
# See https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
#
set +o errexit
result="$(echo -e "${json}" | jq -r "${query}" 2>&1)"
set -o errexit
if [ "null" == "${result}" ] ; then
    stdErr "The query [${query}] does not match the supplied JSON."
    exit 1
else
    if [[ "${result}" =~ ^jq: && "${result}" == *"jq: error:"* ]] ; then
        stdErr "The query [${query}] does not match the supplied JSON."
        exit 1
    fi
fi
if ! isEmpty "${result}" ; then
    echo -e "${result}"
fi

setQuiet
