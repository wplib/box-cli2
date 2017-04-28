# funcs.sh

function stdOut {
    if ! isQuiet ; then
        echo "$1"
    fi
}

function stdErr {
    echo "$1"
}

function isHost {
    if [ $(uname) = "Darwin" ] ; then
        return 0
    fi
    return 1
}

function isGuest {
    if [ $(uname) = "Darwin" ] ; then
        return 1
    fi
    return 0
}

BOXCLI_CLAUSES=()
BOXCLI_OPTIONS=()

function isQuiet {
    export BOXCLI_IS_QUIET="${BOXCLI_IS_QUIET:=!}"
    if [ '!' = "${BOXCLI_IS_QUIET}" ] ; then
        if (( 0 == "${#BOXCLI_OPTIONS[@]}" )) ; then
            return 1
        fi
        for opt in "${BOXCLI_OPTIONS[@]}" ; do
            case "${opt}" in
                q|quiet)
                BOXCLI_IS_QUIET="${opt}"
                return 0
                ;;
            esac
        done
        return 1
    fi
    return 0
}

function _box_process_params {
    for arg in "$@" ; do
        if [[ $arg == -* ]] ; then
            if [[ "--" == "${arg:0:2}" ]] ; then
                arg=${arg:2}
            else
                arg=${arg#"-"}
            fi
            BOXCLI_OPTIONS+=($arg)
        else
            BOXCLI_CLAUSES+=($arg)
        fi
    done
}

