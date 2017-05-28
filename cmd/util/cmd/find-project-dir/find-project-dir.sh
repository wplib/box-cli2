#
# Command: box util find-project-dir
#


if ! isEmpty "${BOXCLI_PROJECT_DIR}" ; then
	echo "${BOXCLI_PROJECT_DIR}"
	return
fi

pushDir
while [ ! -f "$(pwd)/project.json" ] ; do
	if [ "$(pwd)" == "/" ] ; then
		popDir
		exit
	fi
	cd ..
done
if isEmpty "${BOXCLI_PROJECT_DIR}" ; then
	BOXCLI_PROJECT_DIR="$(pwd)"
fi
echo "${BOXCLI_PROJECT_DIR}"
popDir
exit

