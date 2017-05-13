# funcs.sh

function toLowerCase {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

function findProjectFile {
    echo "$(box util find-project-file)"
}

function findProjectDir {
    echo "$(box util find-project-dir)"
}

function pushProjectDir {
    local project_dir="$(box util find-project-dir)"
    if ! hasProjectDir ; then 
        echo "${project_dir}"
        exit
    fi
    pushDir "${project_dir}"
}

function popProjectDir {
    local project_dir="$(box util find-project-dir)"
    popDir "${project_dir}"    
}

function hasProjectDir {
    if [[ "$(findProjectDir)" =~ "No project.json found" ]] ; then
        return 1
    fi
    return 0
}

function hasProjectFile {
    if [[ "$(findProjectFile)" =~ "No project.json found" ]] ; then
        return 1
    fi
    return 0
}

function noArgsPassed {
    if [ "0" == "${#BOXCLI_ARGS[@]}" ] ; then
        return 0
    fi
    return 1
}

function cmdExists {
    if [ "" == "$(command -v $1)" ] ; then
        return 1
    fi
    return 0
}

function stdOut {
    if ! isQuiet ; then
        echo -e "$1"
    fi
}

function stdErr {
    echo -e "$1"
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
    local dir
    if [ "$#" -eq 0 ] ; then
        dir="$(pwd)"
    else
        dir="$1"
    fi
    pushd "${dir}" >/dev/null
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
BOXCLI_IS_COMPOSER=""

function isComposer {
    _testBoolOption "BOXCLI_IS_COMPOSER" 'composer'
    return $?
}

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

