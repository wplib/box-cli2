#
# Command: box util get-hostname
#

hostname="$(box util get-project-info ".box.hostname" "wplib.box")"
hasError && exit 1
echo -e "${hostname}"
setQuiet

