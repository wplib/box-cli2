# constants.sh

BOXCLI_INC_DIR="${BOXCLI_ROOT_DIR}/inc"
BOXCLI_LIB_DIR="${BOXCLI_ROOT_DIR}/lib"
BOXCLI_CMD_DIR="${BOXCLI_ROOT_DIR}/cmd"
BOXCLI_OPT_DIR="${BOXCLI_ROOT_DIR}/opt"

BOXCLI_ARGS=()
BOXCLI_OPTS=()

function _process_args {
    for arg in "$@" ; do
        if [[ $arg == -* ]] ; then
            if [[ "--" == "${arg:0:2}" ]] ; then
                arg=${arg:2}
            else
                arg=${arg#"-"}
            fi
            BOXCLI_OPTS+=($arg)
        else
            BOXCLI_ARGS+=($arg)
        fi
    done
}
_process_args "$@"
