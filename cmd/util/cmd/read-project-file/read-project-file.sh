#
# Command: box util read-project-dir
#
query="$1"
project_file=$(box util find-project-file)
result="$(jq -r "${query}" "${project_file}")"
if [ "null" == "${result}" ] ; then
	result=""
fi
if ! isEmpty "${result}" ; then 
	stdOut "${result}"
fi

