#
# Command: box util find-latest-wordpress-version
#

data_url="https://api.wordpress.org/core/version-check/1.7/"
versions="$(curl --fail --silent "${data_url}")"
isEmpty "${versions}" && return
version="$(echo "${versions}" | jq -r ".offers[0].current")"
hasError && return
echo "${version}"
setQuiet