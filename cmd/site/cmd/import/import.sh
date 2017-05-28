#@IgnoreInspection BashAddShebang
#
# Command: box site import <import_file>
#

import_file="$1"

if [ ! -f "${import_file}" ] ; then 
	stdErr "The import file [${import_file}] does not exist."
	exit 1
fi

if ! isZipFile "${import_file}" ; then
	stdErr "Site import currently only supports importing .ZIP files."
	exit 1
fi

json="$(box util recognize-file "${import_file}" --json)"
if isEmpty "${json}" ; then
	stdErr "The file [${import_file}] is not a recognized type of import file."
	return 1
fi

pushProjectDir
project_dir="$(pwd)"
webroot_path="$(getWebrootPath)"
while 
	if [ ! -d "${webroot_path}" ] ; then 
		break
	fi
	if [ "" == "$(ls "${webroot_path}")" ] ; then 
		break
	fi
	if ! box archive webroot ; then
		exit 1
	fi
	sudo rm -rf "${webroot_path}"
	if ! box archive webroot ; then
		exit 1
	fi
do false ; done

popProjectDir

echo -e $json
exit




tmp_dir="/tmp/boxcli/snapshots/tmp"
mkdir -p "${tmp_dir}"

