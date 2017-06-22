#
# Command: box util purge-download-cache
#

stdOut "Purging Download Cache..."
rm -rf ${BOXCLI_DOWNLOADED_CACHE_DIR} 2>&1 >/dev/null
if hasError ; then
    stdErr "Cache could not be purged."
    exit 1
fi
