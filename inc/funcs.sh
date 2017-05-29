# funcs.sh

source "${BOXCLI_INCLUDE_DIR}/params.sh"
source "${BOXCLI_INCLUDE_DIR}/templates.sh"

function getBoxCliRootDir {
    echo "${BOXCLI_ROOT_DIR}"
}

function isZipFile {
    (( 0 == $# )) && return 1
    if [ "zip" == "$(getFileExtension "$1")" ] ; then
        return 0
    fi
    return 1
}

function fileExists {
    (( 0 == $# )) && return 1
    if [ -f "$1" ] ; then
        return 0
    fi
    return 1
}

function isEmpty {
    (( 0 == $# )) && return 0
    if [ "" == "$1" ] ; then
        return 0
    fi
    return 1
}

function strContains {
    (( $# < 2 )) && return 1
    if [[ "$1" == *"$2"* ]] ; then
        return 0
    fi
    return 1
}

function sanitizeIdentifier {
    (( 0 < $# )) && echo "$1" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_]//g'
}

function sanitizePath {
    (( 0 < $# )) && echo "$1" | sed 's/[^a-zA-Z0-9_/-]//g'
}

function sanitizeDomain {
    (( 0 < $# )) && echo "$1" | sed 's/[^\.a-zA-Z0-9_-]//g'
}

#
# Uppercase first letter
# TODO: Split on spaces and uppercase ever word 
#
function toProperCase {
    (( 0 == $# )) && return
    first="${1:0:1}"
    rest="${1:1}"
    echo "$(toUpperCase "${first}")${rest}"
}

#
# Strip file extension
#
function stripExtension {
    (( 0 < $# )) && echo "${1%.*}"
}

#
# Return file extension, converting to lowercase for easy comparison
#
function getFileExtension {
    echo "$(toLowerCase "$(getFileExtensionRaw "${1}")")"
}

#
# Return raw file extension (RAW = Do not convert to lowercase)
#
function getFileExtensionRaw {
    (( 0 < $# )) && echo "${1##*.}"
}

function toLowerCase {
    (( 0 < $# )) && echo "$1" | tr '[:upper:]' '[:lower:]'
}

function toUpperCase {
    (( 0 < $# )) && echo "$1" | tr '[:lower:]' '[:upper:]'
}

function getLocalDomain {
    echo "$(box util get-local-domain)"
}

function readProjectValue {
    if (( 0 < $# )) ; then
        local result="$(box util read-project-value "$1")"
        if isError ; then
            exit 1
        fi
        echo -e "${result}"
    fi
}

function getContentDir {
    echo "$(box util get-content-dir)"
}

function getContentPath {
    echo "$(box util get-content-path)"
}

function getWebrootDir {
    echo "$(box util get-webroot-dir)"
}

function getWebrootPath {
    echo "$(box util get-webroot-path)"
}

function getProjectDir {
    local project_dir="$(box util get-project-dir)"
    if isError ; then
        exit 1
    fi
    echo "${project_dir}"
}

function getProjectFilePath {
    echo "$(box util get-project-filepath)"
}

function findProjectFilePath {
    echo "$(box util find-project-filepath)"
}

function findProjectDir {
    echo "$(box util find-project-dir)"
}

function pushProjectDir {
    export BOXCLI_PROJECT_DIR="$(getProjectDir)"
    if isError ; then
        exit 1
    fi
    pushDir "${BOXCLI_PROJECT_DIR}"
}

function popProjectDir {
    popDir "$(findProjectDir)"
}

function hasProjectDir {
    export BOXCLI_PROJECT_DIR="$(findProjectDir)"
    if popError ; then
        return 1
    fi
    return 0
}

function hasProjectFile {
    export BOXCLI_PROJECT_FILEPATH="$(findProjectFilePath)"
    if popError ; then
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
    (( 0 == $# )) && return 1
    if [ "" == "$(command -v $1)" ] ; then
        return 1
    fi
    return 0
}

function statusMsg {
    (( 0 < $# )) && stdOut "$1"
}

#
# Output to file 1 (standard output)
#
function stdOut {
    (( 0 == $# )) && return
    if ! isQuiet ; then
        echo -e "$1"
    fi
}

#
# Output to file 2 (error output)  AND push error onto error stack
#
function stdErr {
    if (( 0 == $# )) ; then
        addErr "Unspecified error"
    else
        pushError "$1"
        addErr "$1"
    fi
}

#
# Output to stdErr but without adding error to error stack
#
function addErr {
    if (( 0 == $# )) ; then
        error="Unspecified error"
    else
        error="$1"
    fi
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
