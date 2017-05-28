#
# Command: 		box util get-project-filepath
# Description: 	Used to get the project file or trigger an error 
#               and exit not found in parent directory
#

if ! isEmpty "${BOXCLI_PROJECT_FILEPATH}" ; then
    echo "${BOXCLI_PROJECT_FILEPATH}"
else
    project_dir="$(box util get-project-dir)"
    if ! isEmpty "${project_dir}" ; then
        project_filepath="${project_dir}/project.json"
        if jq -r "." "${project_filepath}" >/dev/null 2>&1 ; then
            echo "${project_filepath}"
            export BOXCLI_PROJECT_FILEPATH="${project_filepath}"
            return 0
        else
            stdErr "ERROR: Invalid JSON in ${project_filepath}."
            stdErr "Please validate at jsonformatter.org, correct the error and try again."
            throwError
            exit 1
        fi
    fi
fi
return 1



