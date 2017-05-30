#
# Command: box util get-box-version
#

box_version="$(box util get-project-info ".box.version")"
hasError && exit 1
echo -e "${box_version}"


