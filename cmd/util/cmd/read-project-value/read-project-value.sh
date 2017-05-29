#
# Command: box util read-project-value
#
if (( 0 == "$#" )) ; then
    stdErr "No JSON query passed."
    return 1
fi

query="$1"
project_filepath="$(getProjectFilePath)"
if isError ; then
    exit 1
else
    setQuiet
    result="$(jq -r "${query}" "${project_filepath}")"
    if [ "null" == "${result}" ] ; then
        result=""
    fi
    if ! isEmpty "${result}" ; then
        echo -e "${result}"
    fi
fi

