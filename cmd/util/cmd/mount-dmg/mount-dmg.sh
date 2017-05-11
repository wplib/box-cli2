#
# Command: box util mount-dmg <dmg_filepath>
#

dmg_file="$1"
stdOut "Mounting ${dmg_file}..."
output="$(hdiutil attach "${dmg_file}")"



