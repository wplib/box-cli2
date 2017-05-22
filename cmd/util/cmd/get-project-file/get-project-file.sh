#
# Command: 		box util get-project-file
# Description: 	Used to get the project file or trigger an error 
#               and exit not found in parent directory
#
project_file="$(box util get-project-dir)"
echo -e "${project_file}/project.json"
