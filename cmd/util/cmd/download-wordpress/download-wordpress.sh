#
# Command: box util download-wordpress [<version>]
#

if (( 0 == "$#" )) ; then
    version="$(box util get-latest-wordpress-version)"
    hasError && exit 1
else
    version="$1"
fi

cd "${BOXCLI_TEMP_DIR}"
coreCacheDir="${BOXCLI_DOWNLOADED_CACHE_DIR}/wp-core"
if ! [ -d "${coreCacheDir}" ] ; then
    mkdir -p "${coreCacheDir}"
fi

downloadedFile="${BOXCLI_WP_DOWNLOADED_FILE_TEMPLATE//\{\{version\}\}/$version}"
checksumFile="${downloadedFile}.sha1"

downloadUrl="https://wordpress.org/${downloadedFile}"
checksumUrl="${downloadUrl}.sha1"

mustDownload=false

downloadedFilepath="${coreCacheDir}/${downloadedFile}"
if ! [ -f "${downloadedFilepath}" ] ; then
    mustDownload=true
fi

checksumFilepath="${coreCacheDir}/${checksumFile}"
if ! [ -f "${checksumFilepath}" ] ; then
    mustDownload=true
fi


if [ "${mustDownload}" = true ] ; then

    box util download-file "${downloadUrl}" "${downloadedFilepath}" 2>&1 >/dev/null
    hasError && exit 1

    if ! [ -f "${downloadedFilepath}" ] ; then
        stdErr "WordPress failed to download: ${downloadUrl}"
        exit 1
    fi

    box util download-file "${checksumUrl}" "${checksumFilepath}" 2>&1 >/dev/null
    hasError && exit 1

    if ! [ -f "${checksumFilepath}" ] ; then
        stdErr "WordPress checksum failed to download: ${checksumUrl}"
        exit 1
    fi

fi

calculatedChecksum="$(box util get-sha1-checksum "${downloadedFilepath}")"
hasError && exit 1

downloadedChecksum="$(cat "${checksumFilepath}")"
hasError && exit 1

if [ "${calculatedChecksum}" != "${downloadedChecksum}" ] ; then
    stdErr "WordPress failed checksum. Run 'box util purge-download-cache' and try again."
    exit 1
fi

echo "${downloadedFilepath}"

setQuiet