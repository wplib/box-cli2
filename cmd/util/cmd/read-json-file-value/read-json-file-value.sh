#
# Command: box util read-json-file-value <filepath> <query>
#
if (( 0 == "$#" )) ; then
    stdErr "No JSON file passed."
    exit 1
fi
if (( 1 == "$#" )) ; then
    stdErr "No JSON query passed."
    exit 1
fi

filepath="$1"
query="$2"

if ! [ -f "${filepath}" ] ; then
    stdErr "JSON file [${filepath}] does not exist."
    exit 1
fi
json="$(cat "${filepath}")"
result="$(box util read-json-value "${json}" "${query}")"
hasError && exit 1
echo -e "${result}"

setQuiet

