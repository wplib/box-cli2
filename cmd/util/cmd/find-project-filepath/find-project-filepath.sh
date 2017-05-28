#
# Command: box util find-project-filepath
#

project_dir="$(box util find-project-dir)"
if ! isEmpty "${project_dir}" ; then
	echo "${project_dir}/project.json" 
fi	
exit

