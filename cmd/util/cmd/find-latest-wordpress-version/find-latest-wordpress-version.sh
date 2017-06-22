#
# Command: box util find-latest-wordpress-version
#

versions="$(curl --fail --silent "${BOXCLI_WPORG_API_VERSION_CHECK_URL}")"
isEmpty "${versions}" && return
version="$(echo "${versions}" | jq -r ".offers[0].current")"
hasError && return
echo "${version}"
setQuiet