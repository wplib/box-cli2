#
# Command: box util read-project-file-value <query>
#

if (( 0 == "$#" )) ; then
    stdErr "No JSON query passed."
    return 1
fi

query="$1"
project_filepath="$(getProjectFilePath)"
if hasError ; then
    exit 1
fi

result="$(box util read-json-file-value "${project_filepath}" "${query}")"
hasError && exit 1
echo -e "${result}"
setQuiet

