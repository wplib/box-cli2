#
# Command: box project up
#

projectDir="$(getProjectDir)"
hasError && exit 1

if ! [ -f "${projectDir}/Vagrantfile" ] ; then
    stdErr "No file named [Vagrantfile] found in ${projectDir}/"
    exit 1
fi

cd "${projectDir}"
statusMsg "Activating project $(getProjectName)..."
vagrant up



