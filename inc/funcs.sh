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
    if [ $(uname) = "Linux" ] ; then
        return 0
    fi
    return 1
}

function readYes {
    read -p "$* " yesno
    if [[ "Yy" =~ "${yesno}" ]] ; then
        return 0
    fi
    return 1
}

function readNo {
    if readYes "$*" ; then
        return 1
    fi
    return 0
}

function pushDir {
    pushd "$1" >/dev/null
}
function popDir {
    popd  >/dev/null
}

function pushTmpDir {
    rm -rf "$1"
    mkdir -p "$1"
    pushDir "$1" 
}

function popTmpDir {
    popDir
    rm -rf "$1"
}


BOXCLI_CLAUSES=()
BOXCLI_OPTIONS=()
BOXCLI_IS_QUIET=""
BOXCLI_IS_JSON=""

function isJSON {
    _testBoolOption "BOXCLI_IS_JSON" 'json'
    return $?
}
function isQuiet {
    _testBoolOption "BOXCLI_IS_QUIET" 'q' 'quiet'
    return $?
}

function _testBoolOption {
    varName=$1
    shift
    if [ "" == "${!varName}" ] ; then
        if [ "" == "${BOXCLI_OPTIONS}" ] ; then
            eval $varName='!'
            return 1
        fi
        for option in "$@" ; do
            if [[ "${BOXCLI_OPTIONS}" =~ "|${option}|" ]] ; then
                eval $varName="${option}"
                return 0
            fi
        done
        return 1
    fi
    if [ "!" == "${!varName}" ] ; then
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
                if [[ 1 < ${#arg} ]] ; then
                    stdErr "Invalid option -${arg}. Did you mean --${arg}?"
                    exit
                fi
            fi
            BOXCLI_OPTIONS+=($arg)
        else
            BOXCLI_CLAUSES+=($arg)
        fi
    done
    #
    # TODO: Need to validate options at some point
    #
    if (( 0 == "${#BOXCLI_OPTIONS[@]}" )) ; then
        BOXCLI_OPTIONS=""
    else
        BOXCLI_OPTIONS=$(IFS="|";echo "${BOXCLI_OPTIONS[*]}")
        BOXCLI_OPTIONS="|${BOXCLI_OPTIONS}|"
    fi
}

