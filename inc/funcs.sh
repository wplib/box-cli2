# funcs.sh

source "${BOXCLI_INCLUDE_DIR}/params.sh"
source "${BOXCLI_INCLUDE_DIR}/templates.sh"

function realPath() {
    local realpath
    local saveIFS
    local index
    local previous
    if [[ $1 = /* ]] ; then
        realpath="$1"
    else
        realpath="$(pwd)/${1#./}"
    fi
    saveIFS="${IFS}"
    IFS='/'
    read -r -a segments <<<"$realpath"
    index="${#segments[@]}"
    while [ $index -gt 0 ] ; do
        ((index--))
        if [ "." == "${segments[$index]}" ] ; then
            segments[$index]=""
            continue
        fi
        if [ ".." == "${segments[$index]}" ] ; then
            segments[$index]=""
            ((index--))
            segments[$index]=""
            continue
        fi
    done
    echo "${segments[*]}" | sed -e 's#///#/#g'
    IFS="${saveIFS}"
}

function ensureDir {
    (( 0 == $# )) && return 1
    dir="$1"
    mkdir -p "${dir}"
}

function changeAbsDir {
    (( 0 == $# )) && return 1
    abs_dir="$1"
    if ! [ -d "${abs_dir}" ] ; then
        mkdir -p "${abs_dir}"
    fi
    if ! [ -d "${abs_dir}" ] ; then
        return 1
    fi
    cd "${abs_dir}"
}

function removeDir {
    (( 0 == $# )) && return 1
    dir="$1"
    rm -rf "${dir}"
}

function moveFiles {
    (( 0 == $# )) && return 1
    from_file="$1"
    (( 1 == $# )) && to_file="."
    to_file="${to_file:=$2}"

    #from_path="${from_file:${#BOXCLI_TEMP_DIR}}"
    #statusMsg "Moving [${from_path}] to [${to_file}]..."

    from_dir="$(dirname "${from_file}")"

    # Do this so globs like 'wp-*.php' will work.
    from_base="${from_file:${#from_dir}}"

    set +o errexit
    mv "${from_dir}"$from_base "${to_file}" >/dev/null  2>&1
    set -o errexit
}

function getLatestWordPressVersion {
    local wp_version="$(box util get-latest-wordpress-version)"
    hasError && exit 1
    echo "${wp_version}"
}

function findLatestWordPressVersion {
    local wp_version="$(box util find-latest-wordpress-version)"
    hasError && exit 1
    echo "${wp_version}"
}

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
# Strip Carriage Returns and Line Feeds
# See: https://unix.stackexchange.com/a/114245/144192
#
function stripCrLf {
   (( 0 == $# )) && return
   echo "$1" | tr "\n\r" " "
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
    local local_domain="$(box util get-local-domain)"
    hasError && exit 1
    echo "${local_domain}"
}

function getHostname {
    local hostname="$(box util get-hostname)"
    hasError && exit 1
    echo "${hostname}"
}

function readJsonValue {
    if (( 1 < $# )) ; then
        json="$1"
        query="$2"
        local result="$(box util read-json-value "${json}" "${query}")"
        hasError && exit 1
        echo -e "${result}"
    fi
}

function readProjectFileValue {
    if (( 0 < $# )) ; then
        local result="$(box util read-project-file-value "$1")"
        hasError && exit 1
        echo -e "${result}"
    fi
}

function getContentDir {
    local content_dir="$(box util get-content-dir)"
    hasError && exit 1
    echo "${content_dir}"
}

function getCorePath {
    local core_path="$(box util get-core-path)"
    hasError && exit 1
    echo "${core_path}"
}

function getContentPath {
    local content_path="$(box util get-content-path)"
    hasError && exit 1
    echo "${content_path}"
}

function getWebrootDir {
    local webroot_dir="$(box util get-webroot-dir)"
    hasError && exit 1
    echo "${webroot_dir}"
}

function getWebrootPath {
    local webroot_path="$(box util get-webroot-path)"
    hasError && exit 1
    echo "${webroot_path}"
}

function getProjectDir {
    local project_dir="$(box util get-project-dir)"
    hasError && exit 1
    echo "${project_dir}"
}

function getProjectFilePath {
    local project_filepath="$(box util get-project-filepath)"
    hasError && exit 1
    echo "${project_filepath}"
}

function findProjectFilePath {
    echo "$(box util find-project-filepath)"
}

function findProjectDir {
    echo "$(box util find-project-dir)"
}

function pushProjectDir {
    export BOXCLI_PROJECT_DIR="$(getProjectDir)"
    if hasError ; then
        exit 1
    fi
    pushDir "${BOXCLI_PROJECT_DIR}"
    echo "${BOXCLI_PROJECT_DIR}"
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
