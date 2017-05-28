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
BOXCLI_PROJECT_DIR="${BOXCLI_PROJECT_DIR:=""}"
BOXCLI_PROJECT_FILEPATH="${BOXCLI_PROJECT_FILEPATH:=""}"

# Default Local Top Level Domain, e.g. "example.dev"
BOXCLI_DEFAULT_LOCAL_TLD=".dev"

# Value to test against for errors when getting the return value
# of a command substitution, .e.g "variable=$(command "${parameter}")"
BOXCLI_ERROR_VALUE="-1"

#
# Set a variable to allow determining how deeply nested a command is.
# IOW, A `box` commmand calls a more fundamental `box` command, etc.
# Most common nested calls are calling `box util` commands
# First time through BOXCLI_NESTING_DEPTH will equal 1.
#
BOXCLI_NESTING_DEPTH=${BOXCLI_DEPTH:=0}
BOXCLI_NESTING_DEPTH=$(( BOXCLI_NESTING_DEPTH + 1 ))

