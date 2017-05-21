#
# Installable Command: box install fuse
#
url_path="https://github.com/osxfuse/osxfuse/releases/download/osxfuse-3.5.8"
dmg_file="osxfuse-3.5.8.dmg"
package_name="FUSE for macOS"
package_file="/Volumes/${package_name}/${package_name}.pkg"
tmp_dir="${BOXCLI_TEMP_DIR}/fuse"

if readYes "This will install FUSE for macOS 3.5.8. Continue [y/N]:" ; then 

	pushTmpDir "${tmp_dir}" 

	box util download-file "${url_path}/${dmg_file}"

    box util mount-dmg "${dmg_file}"

    box util install-pkg "${package_file}"

    box util unmount-volume "${package_name}"

	popTmpDir "${tmp_dir}" 

fi
