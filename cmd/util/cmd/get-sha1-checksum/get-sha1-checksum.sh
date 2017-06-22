#
# Command: box util get-sha1-checksum <filename>
#
# Returns just the sha1 checksum for a file
# (omits the filename, unlike shasum and sha1sum)
#

if (( 0 == "$#" )) ; then
    stdErr "No filename passed."
    return 1
fi

filename="$1"
if [ "${BOXCLI_PLATFORM}" = "macOS" ] ; then
    sha1="$(shasum "${filename}")"
else
    sha1="$(sha1sum "${filename}")"
fi
echo "${sha1%% *}"
hasError && exit 1
setQuiet
