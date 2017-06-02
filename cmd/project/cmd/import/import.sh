#@IgnoreInspection BashAddShebang
#
# Command: box project import <import_filepath>
#

if [ "0" = "$#" ] ; then
	stdErr "No import file specified."
	exit 1
fi

import_filepath="$(realPath "$1")"

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
ensureDir "${tmp_dir}"

source="$(readJsonValue "${json}" ".source")"
hasError && exit 1
scope="$(readJsonValue "${json}" ".scope")"
hasError && exit 1
type="$(readJsonValue "${json}" ".type")"
hasError && exit 1

#
# Calculate the importer filename
#
importer_filepath="${BOXCLI_ROOT_DIR}/imp/${source}-${scope}-${type}-importer.sh"

if ! [ -f "${importer_filepath}" ] ; then
    stdErr "The importer ["${importer_filepath}"] does not exist."
    exit 1
fi

statusMsg "Importing [${import_filepath}]..."

#
# Run the selected importer
#
source "${importer_filepath}" "${import_filepath}" "${json}" "${tmp_dir}"

statusMsg "Import of [${import_filepath}] complete."
setQuiet