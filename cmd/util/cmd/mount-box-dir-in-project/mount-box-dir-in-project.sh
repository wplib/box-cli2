#
# Command: box util mount-box-project_dir-in-project <project_dir>
#

mount_path="$1"
project_dir="$(findProjectDir)/${mount_path}"

box_ip="$(box util get-box-ip-address)"

if [ "" == "${box_ip}" ]; then
	echo "No IP address configured for the box."
	exit
fi

if ! cmdExists "sshfs"; then
	box install sshfs
fi

if ! cmdExists "sshfs"; then
	echo "No installation of sshfs."
	exit
fi

if [ ! -d "${project_dir}" ]; then
	mkdir -p "${project_dir}"
fi

mount="vagrant@${box_ip}:/box/${mount_path}"

if [ "" != "$(mount | grep "${mount}")" ] ; then
	echo "${project_dir} already mounted."
	exit
fi

echo "vagrant" | sshfs "${mount}" "${project_dir}" -o password_stdin
