#
# Command: box util read-project-file
#
query="$1"
project_file=$(box util get-project-file)

result="$(jq -r "${query}" "${project_file}")"
if [ "null" == "${result}" ] ; then
	result=""
fi
if ! isEmpty "${result}" ; then 
	echo -e "${result}"
fi

