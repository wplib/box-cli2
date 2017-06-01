#
# Command: box util get-latest-wordpress-version
#

version="$(findLatestWordPressVersion)"
if isEmpty "${version}" ; then
    stdErr "Cannot get WordPress' latest version from ${data_url}. Check your internet connection?"
    exit 1
fi
echo "${version}"
setQuiet