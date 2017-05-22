#
# Command: box util recognize-file <filepath>
#

testfile="$(pwd)/$1"

if fileExists "${testfile}" ; then
	filepath="${testfile}"
else
	filepath="$1"
	if ! fileExists "${filepath}" ; then
		stdErr "The file [${filepath}] does not exist."
		exit 1
	fi
fi

for recognizer in "${BOXCLI_RECOGNIZER_DIR}"/* ; do
	result="$(source "${recognizer}" "${filepath}")"
	if ! isEmpty "${result}" ; then
		echo -e "${result}"
		exit
	fi
done
