#
# Command: box util generate-vagrantfile
#
# See: https://serverfault.com/a/287690/101860
#

vars=(BOX_VERSION LOCAL_DOMAIN)
exit

project_dir="$(getProjectDir)"
vagrant_file="${project_dir}/Vagrantfile"

if [ -f "${vagrant_file}" ] ; then
	if readNo "The file [${vagrant_file}] exists. Overwrite?" ; then 
		exit 1
	fi
fi	

BOX_VERSION="$(box util get-box-version)"
LOCAL_DOMAIN="$(box util get-local-domain)"


vars=(BOX_VERSION LOCAL_DOMAIN)
box util load-template "Vagrantfile" "${vars[@]}"
exit

foo='BOX_VERSION'
echo "${!foo}"
exit

tmp_file="${BOXCLI_TMP_DIR}/Vagrantfile"

box util load-template "Vagrantfile" 



echo "${content}"

#box util copy-to-project-dir "${tmp_file}"

statusMsg "Vagrant file [${vagrant_file}] generated."





