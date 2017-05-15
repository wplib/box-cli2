#
# Command: 		box util get-project-dir
# Description: 	Used to get the project dir or trigger an error 
#               and exit not found in parent directory
#

set -e
project_dir="$(box util find-project-dir)"
if ! isEmpty "${project_dir}" ; then 
	stdOut "${project_dir}"
else	
	stdErr "No [project.json] found in [$(pwd)] or in parent directories."
	exit 1
fi	



