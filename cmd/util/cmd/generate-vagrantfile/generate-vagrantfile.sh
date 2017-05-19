#
# Command: box util generate-vagrantfile
#
# See: https://serverfault.com/a/287690/101860
#

project_dir="$(getProjectDir)"
echo "${project_dir}"
vagrant_file="${project_dir}/Vagrantfile"

if [ -f "${vagrant_file}" ] ; then
	if readNo "Overwrite existing ${vagrant_file}" ; then 
		stdErr "User aborted."
		exit 1
	fi
fi	

tmp_file="${BOXCLI_TMP_DIR}/Vagrantfile"

box util load-template "Vagrantfile" > $tmp_file

box util copy-to-project-dir "${tmp_file}" --quiet

statusMsg "Vagrant file generated: ${vagrant_file}"
exit





