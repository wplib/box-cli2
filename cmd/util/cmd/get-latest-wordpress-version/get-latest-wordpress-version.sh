#
# Command: box util get-latest-wordpress-version
#

version="$(findLatestWordPressVersion)"
if isEmpty "${version}" ; then
    stdErr "Cannot get WordPress' latest version from ${BOXCLI_WPORG_API_VERSION_CHECK_URL}. Check your internet connection?"
    exit 1
fi
echo "${version}"
setQuiet