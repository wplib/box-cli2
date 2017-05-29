#
# Command: box util read-project-value
#
if (( 0 == "$#" )) ; then
    stdErr "No JSON query passed."
    return 1
fi

query="$1"
project_filepath="$(getProjectFilePath)"
if hasError ; then
    exit 1
else
    setQuiet
    #
    # Turn off error exit
    # See https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
    #
    set +o errexit
    result="$(jq -r "${query}" "${project_filepath}" 2>&1)"
    set -o errexit
    if [ "null" == "${result}" ] ; then
        result=""
    else
        if [[ "${result}" =~ ^jq: && "${result}" == *"jq: error:"* ]] ; then
            stdErr "The query [${query}] does not match the JSON in ${project_filepath}."
            exit 1
        fi
    fi
    if ! isEmpty "${result}" ; then
        echo -e "${result}"
    fi
fi

