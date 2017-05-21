#
# Command: box util load-template <template_file> 
#
# Alternate: https://github.com/lavoiesl/bash-templater/blob/master/templater.sh
# Alternate: https://github.com/napsternxg/bash-template-engine
# Alternate: https://github.com/johanhaleby/bash-templater/blob/master/templater.sh
# Alternate: http://pempek.net/articles/2013/07/08/bash-sh-as-template-engine/
# Atternate: https://github.com/tests-always-included/mo/blob/master/mo
#

template_file="${BOXCLI_TEMPLATE_DIR}/$1.template"

if [ ! -f "${template_file}" ] ; then
	stdErr "The template [${template_file}] does not exist."
	exit 1
else	
	stdOut "$(parseTemplate "$(cat "${template_file}")")"
fi

 