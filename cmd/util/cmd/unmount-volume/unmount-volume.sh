#
# Command: box util unmount-volume <volume_name>
#

# TODO: Fix what happens when more than one of these is mounted
volume_name="$1"

device="$(hdiutil info | grep "/Volumes/${volume_name}")"
device="$(echo "${device:0:11}" | tr -d '[:space:]')"
stdOut "Unmounting /Volumes/$1 [${device}]..."
output="$(sudo hdiutil detach "${device}")"


