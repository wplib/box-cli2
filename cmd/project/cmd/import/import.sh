#@IgnoreInspection BashAddShebang
#
# Command: box project import <import_filepath>
#

if [ "0" = "$#" ] ; then
	stdErr "No import file specified."
	exit 1
fi

import_filepath="$1"

if [ ! -f "${import_filepath}" ] ; then 
	stdErr "The import file [${import_filepath}] does not exist."
	exit 1
fi

if ! isZipFile "${import_filepath}" ; then
	stdErr "Project import currently only supports importing .ZIP files."
	exit 1
fi

json="$(box util recognize-file "${import_filepath}" --json)"
if isEmpty "${json}" ; then
	stdErr "The file [${import_filepath}] is not a recognized type of import file."
	exit 1
fi

#
# "pi" means project import
#
tmp_dir="${BOXCLI_TEMP_DIR}/pi"


#source importer here


exit

while
	if [ ! -d "${webroot_dir}" ] ; then
		break
	fi
	if [ "" == "$(ls "${webroot_dir}")" ] ; then
		break
	fi
	if ! box webroot archive ; then
		exit 1
	fi
	sudo rm -rf "${webroot_dir}"
	if ! box webroot archive ; then
		exit 1
	fi
do false ; done

popProjectDir

exit
