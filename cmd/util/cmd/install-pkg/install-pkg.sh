#
# Command: box util install-pkg <package_name>
#

package_filepath="$1"
if [ ! -f "${package_filepath}" ] ; then
	stdErr "Package ${package_filepath} does not exist."
else 
	package_name="$(basename "${package_filepath}")"
	stdOut "Installing package ${package_name}..."
	output="$(sudo installer -package "${package_filepath}" -target /)"
fi	

