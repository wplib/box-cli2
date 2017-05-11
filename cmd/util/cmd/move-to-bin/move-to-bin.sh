#
# Installable Command: box util install-in-path <source_file> <destination_file>
#
source_file="$1"
destination_file="$2"
destination_dir="/usr/local/bin"

destination="${destination_dir}/${destination_file}"

stdOut "Moving ${source_file} to ${destination}..."

#sudo rm -f "${destination}"

#sudo mv "${source_file}" "${destination}"

#sudo chmod +x "${destination}"

