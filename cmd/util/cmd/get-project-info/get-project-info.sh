#
# Command: 		box util get-project-info <query> [<default>]
# Description: 	Used to read the project file and trigger an error and exit if empty
#
# $1 - .jq query
# $2 - Default value [optional]
#

if [ 0 == "$#" ] ; then
    stdErr "No .jq query specified."
    exit 1
fi
query="$1"

default="$(if [ 2 == "$#" ] ; then echo "$2" ; fi)"

value="$(box util read-project-file-value "$1")"
hasError && exit 1

if isEmpty "${value}" ; then
	if ! isEmpty "${default}" ; then
		value="${default}";
	else
		project_file="$(findProjectFilePath)"
		stdErr "No value found in [${project_file}] for [$1]."
		exit 1
	fi
fi	
echo -e "${value}"
setQuiet


