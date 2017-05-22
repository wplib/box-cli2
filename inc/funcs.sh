# funcs.sh


source "${BOXCLI_INCLUDE_DIR}/params.sh"
source "${BOXCLI_INCLUDE_DIR}/templates.sh"

function getBoxCliRootDir {
    echo "${BOXCLI_ROOT_DIR}"
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

function strContains {
    if [[ "$1" == *"$2"* ]] ; then
        return 0
    fi
    return 1
}

function sanitizeIdentifier {
    echo "$1" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_]//g'
}

function sanitizePath {
    echo "$1" | sed 's/[^a-zA-Z0-9_/-]//g'
}

function sanitizeDomain {
    echo "$1" | sed 's/[^\.a-zA-Z0-9_-]//g'
}

#
# Uppercase first letter
# TODO: Split on spaces and uppercase ever word 
#
function toProperCase {
    first="${1:0:1}"
    rest="${1:1}"
    echo "$(toUpperCase $first)${rest}"
}

#
# Strip file extension
#
function stripExtension {
    echo "${1%.*}"
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
    echo "${1##*.}"
}

function toLowerCase {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

function toUpperCase {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

function getLocalDomain {
    echo "$(box util get-local-domain)"
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
    echo "$(box util get-project-dir)"
}

function getProjectFile {
    echo "$(box util get-project-file)"
}

function findProjectFile {
    echo "$(box util find-project-file)"
}

function findProjectDir {
    echo "$(box util find-project-dir)"
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
