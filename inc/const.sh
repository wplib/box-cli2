# constants.sh
#
# Note: params.sh also defines constants

BOXCLI_BOX_VERSION="0.15.0"

BOXCLI_ROOT_DIR="$1"
BOXCLI_INCLUDE_DIR="${BOXCLI_ROOT_DIR}/inc"
BOXCLI_LIBRARY_DIR="${BOXCLI_ROOT_DIR}/lib"
BOXCLI_COMMAND_DIR="${BOXCLI_ROOT_DIR}/cmd"
BOXCLI_SWITCH_DIR="${BOXCLI_ROOT_DIR}/switches"
BOXCLI_RECOGNIZER_DIR="${BOXCLI_ROOT_DIR}/rec"
BOXCLI_IMPORTER_DIR="${BOXCLI_ROOT_DIR}/imp"
BOXCLI_TEMPLATE_DIR="${BOXCLI_ROOT_DIR}/tpl"
BOXCLI_TEMP_DIR="/tmp/boxcli"

# Define later, for optimizing 'box util get-project-dir'
BOXCLI_PROJECT_DIR=""

#Default Local Top Level Domain, e.g. "example.dev"
BOXCLI_DEFAULT_LOCAL_TLD=".dev"
