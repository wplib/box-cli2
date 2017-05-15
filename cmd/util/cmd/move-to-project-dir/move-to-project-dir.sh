#
# Installable Command: box util move-to-project-dir <source_file> 
#

source_file="$1"

project_dir="$(getProjectDir)"

if isEmpty "${project_dir}" ; then

	exit

else	

	source_base="$(basename "$1")"

	destination_file="${project_dir}/${source_base}"

	statusMsg "Moving ${source_file} to ${destination_file}..."

	sudo mv "${source_file}" "${destination_file}"

fi