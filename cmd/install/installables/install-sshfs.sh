#
# Installable Command: box install sshfs
#
url_path="https://github.com/osxfuse/sshfs/releases/download/osxfuse-sshfs-2.5.0"
package_file="sshfs-2.5.0.pkg"
tmp_dir="${BOXCLI_TEMP_DIR}/sshfs"

if readYes "This will install SSHFS 2.5.0. Continue [y/N]:" ; then 

	pushTmpDir "${tmp_dir}" 

	box util download-file "${url_path}/${package_file}"

    box util install-pkg "${package_file}"

	popTmpDir "${tmp_dir}" 

fi

