# funcs.sh

function stdOut {
    if ! isQuiet ; then
        echo "$1"
    fi
}

function stdErr {
    echo ""
}

function isQuiet {
    export BOXCLI_IS_QUIET="${BOXCLI_IS_QUIET:=!}"
    if [ '!' = "${BOXCLI_IS_QUIET}" ] ; then
        for opt in "${BOXCLI_OPTS[@]}" ; do
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

