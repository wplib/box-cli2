# constants.sh
BOXCLI_BOX_VER="0.15.0"

BOXCLI_ROOT_DIR="$1"
BOXCLI_INC_DIR="${BOXCLI_ROOT_DIR}/inc"
BOXCLI_LIB_DIR="${BOXCLI_ROOT_DIR}/lib"
BOXCLI_CMD_DIR="${BOXCLI_ROOT_DIR}/cmd"
BOXCLI_OPT_DIR="${BOXCLI_ROOT_DIR}/opt"
BOXCLI_REC_DIR="${BOXCLI_ROOT_DIR}/rec"
BOXCLI_TPL_DIR="${BOXCLI_ROOT_DIR}/tpl"
BOXCLI_TMP_DIR="/tmp/boxcli"

BOXCLI_IS_QUIET=""
BOXCLI_IS_JSON=""
BOXCLI_IS_COMPOSER=""

# Define later, for optimizing 'box util get-project-dir'
BOXCLI_PROJECT_DIR=""


# Clause names
BOXCLI_CLAUSES=()
# Option names
BOXCLI_OPTIONS=()
# Option values
BOXCLI_OPTVALS=()
# Valid Options
BOXCLI_VALOPTS=()
# Valid Option Value Expected
BOXCLI_VALEXP=()
# Options surrounded/separated by '|'
BOXCLI_OPT_STR=""
