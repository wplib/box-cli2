#
# Command: box util generate-vagrantfile
#
# See: https://serverfault.com/a/287690/101860
#

project_dir="$(getProjectDir)"
vagrant_filepath="${project_dir}/Vagrantfile"
statusMsg "Generating ${vagrant_filepath}..."
if [ -f "${vagrant_filepath}" ] ; then
	if readNo "Overwrite ${vagrant_filepath}" ; then
		stdErr "User aborted."
		exit 1
	fi
fi
vagrant_file="$(box util load-template "Vagrantfile")"
echo -e "${vagrant_file}" > $vagrant_filepath
statusMsg "Vagrant file generated: ${vagrant_filepath}"