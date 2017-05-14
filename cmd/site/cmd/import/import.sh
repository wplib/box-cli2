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

echo -e $json
exit