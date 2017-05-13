#
# Installable Command: box install js
#
url_path="https://github.com/stedolan/jq/releases/download/jq-1.5"
bin_file="jq-osx-amd64"
tmp_dir="${BOXCLI_TMP_DIR}/jq"

if readYes "This will install jq 1.5. Continue [y/N]:" ; then 

	pushTmpDir "${tmp_dir}" 

	box util download-file "${url_path}/${bin_file}"

	box util move-to-bin "${bin_file}" jq

	popTmpDir "${tmp_dir}" 

fi
