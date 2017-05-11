#
# Installable Command: box install fuse
#
file_url="$1"

stdOut "Downloading ${file_url}..."
curl -O -L -S -# "${file_url}" >/dev/null
