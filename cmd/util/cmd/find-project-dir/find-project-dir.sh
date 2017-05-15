#
# Command: box util find-project-dir
#

if ! isEmpty "${BOXCLI_PROJECT_DIR}" ; then
	stdOut "${BOXCLI_PROJECT_DIR}" 
	return
fi

pushDir 
while [ ! -f "$(pwd)/project.json" ] ; do
	if [ "$(pwd)" == "/" ] ; then
		popDir
		stdErr "No project.json found in $(pwd) or in parent directories."
		exit
	fi
	cd ..
done
if isEmpty "${BOXCLI_PROJECT_DIR}" ; then
	BOXCLI_PROJECT_DIR="$(pwd)" 
fi
stdOut "${BOXCLI_PROJECT_DIR}" 
popDir
exit

