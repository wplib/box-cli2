# funcs.sh

#
# Parses templates that contain {{.jq.queries}} into project.json
# Queries can be nested but nest should have default value, e.g. {{foo.{{.abc=bar}}.baz}}.
# But there is no looping at this point and no supplied values (yet)
#
function parseTemplate {
    local template="$1"
    local left
    local right
    local query
    local value
    if [[ "${template}" =~ ^(.*)}}(.*)$ ]] ; then
        left="${BASH_REMATCH[1]}"
        right="${BASH_REMATCH[2]}"
        left="$(parseTemplate "${left}")"
        stdOut "$(parseTemplate "${left}${right}")"
        return
    fi
    if [[ "${template}" =~ ^(.*){{(.*)$ ]] ; then
        left="${BASH_REMATCH[1]}"
        right="${BASH_REMATCH[2]}"
        right="$(parseTemplate "${right}")"
        stdOut "${left}${right}"
        return
    fi
    if [[ "${template}" =~ ^(\.[\.a-z_=]+)$ ]] ; then
        if [[ "${template}" == *"="* ]] ; then 
            query="${template%=*}"
            value="${template#*=}"
        else 
            query="${template}"
            value=""
        fi
        result="$(box util read-project-file "${query}")"
        if isEmpty "${result}" ; then
            result="${value}"
        fi
        stdOut "${result}"
        return
    fi
    stdOut "${template}"
}

function isNull {
    if [ "zip" == "$(getFileExtension "$1")" ] ; then
        return 0
    fi
    return 1
}

function isZipFile {
    if [ "zip" == "$(getFileExtension "$1")" ] ; then
        return 0
    fi
    return 1
}

function fileExists {
    if [ -f "$1" ] ; then
        return 0
    fi
    return 1
}

function isEmpty {
    if [ "" == "$1" ] ; then
        return 0
    fi
    return 1
}

#
# Return file extension, converting to lowercase for easy comparison
#
function getFileExtension {
    stdOut "$(toLowerCase "$(getFileExtensionRaw "${1}")")"
}

#
# Return raw file extension (RAW = Do not convert to lowercase)
#
function getFileExtensionRaw {
    stdOut "${1##*.}"
}

function toLowerCase {
    stdOut "$1" | tr '[:upper:]' '[:lower:]'
}

function getLocalDomain {
    stdOut "$(box util get-local-domain)"
}

function getContentDir {
    stdOut "$(box util get-content-dir)"
}

function getContentPath {
    stdOut "$(box util get-content-path)"
}

function getWebrootDir {
    stdOut "$(box util get-webroot-dir)"
}

function getWebrootPath {
    stdOut "$(box util get-webroot-path)"
}

function getProjectDir {
    stdOut "$(box util get-project-dir)"
}

function getProjectFile {
    stdOut "$(box util get-project-file)"
}

function findProjectFile {
    stdOut "$(box util find-project-file)"
}

function findProjectDir {
    stdOut "$(box util find-project-dir)"
}

function pushProjectDir {
    local project_dir="$(box util get-project-dir)"
    pushDir "${project_dir}"
}

function popProjectDir {
    popDir "$(box util find-project-dir)"
}

function hasProjectDir {
    if [[ "" == "$(findProjectDir)" ]] ; then
        return 1
    fi
    return 0
}

function hasProjectFile {
    if [[ "" == "$(findProjectFile)" ]] ; then
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

function statusMsg {
    stdOut "$1"
}

function stdOut {
    if ! isQuiet ; then
        echo -e "$1"
    fi
}

function stdErr {
    echo -e "$1" 1>&2
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
    read -p "$* [yN]? " yesno
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

