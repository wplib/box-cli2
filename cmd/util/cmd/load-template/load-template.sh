#
# Command: box util load-template <template_file> 
#

template_file="${BOXCLI_TPL_DIR}/$1.template"

if [ ! -f "${template_file}" ] ; then
	stdErr "The template [${template_file}] does not exist."
	exit 1
else	
	template="$(cat "${template_file}")"
	template="$(parseTemplate "${template}")"

	stdOut "${template}"
fi

 