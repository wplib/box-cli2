# constants.sh
#
# Note: params.sh also defines constants

#
# This is set in box
#
#export BOXCLI_PLATFORM


export BOXCLI_BOX_VERSION="0.15.0"

export BOXCLI_ROOT_DIR="$1"
export BOXCLI_INCLUDE_DIR="${BOXCLI_ROOT_DIR}/inc"
export BOXCLI_LIBRARY_DIR="${BOXCLI_ROOT_DIR}/lib"
export BOXCLI_COMMAND_DIR="${BOXCLI_ROOT_DIR}/cmd"
export BOXCLI_SWITCH_DIR="${BOXCLI_ROOT_DIR}/switches"
export BOXCLI_RECOGNIZER_DIR="${BOXCLI_ROOT_DIR}/rec"
export BOXCLI_IMPORTER_DIR="${BOXCLI_ROOT_DIR}/imp"
export BOXCLI_TEMPLATE_DIR="${BOXCLI_ROOT_DIR}/tpl"

# Define later, for optimizing 'box util get-project-dir'
export BOXCLI_PROJECT_DIR="${BOXCLI_PROJECT_DIR:=""}"
export BOXCLI_PROJECT_FILEPATH="${BOXCLI_PROJECT_FILEPATH:=""}"

# Default Local Top Level Domain, e.g. "example.dev"
export BOXCLI_DEFAULT_LOCAL_TLD=".dev"


