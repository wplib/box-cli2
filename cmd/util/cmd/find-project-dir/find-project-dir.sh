#
# Command: box util find-project-dir
#
pushDir 
while [ ! -f "$(pwd)/project.json" ] ; do
	if [ "$(pwd)" == "/" ] ; then
		popDir
		stdErr "No project.json found in $(pwd) or in parent directories."
		exit
	fi
	cd ..
done
echo "$(pwd)" 
popDir
exit

