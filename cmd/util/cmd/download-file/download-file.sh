#
# Command: box util download-file <downloadUrl> [<filepath>]
#

if (( 0 == "$#" )) ; then
    stdErr "No file URL passed."
    return 1
fi
downloadUrl="$1"

if (( 1 == "$#" )) ; then
    filename="$(basename "${downloadUrl}")"
    filepath="${BOXCLI_TEMP_DIR}/${filename}"
    return 1
else
    filepath="$2"
fi

stdOut "Downloading ${downloadUrl}..."
curl -L -S -s -o "${filepath}" "${downloadUrl}" >/dev/null
hasError && exit 1
setQuiet