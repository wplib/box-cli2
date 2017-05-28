# templates.sh

#
# Parses templates that contain {{.jq.queries}} into project.json
# Queries can be nested but nest should have default value, e.g. {{foo.{{.abc=bar}}.baz}}.
# But there is no looping at this point and no supplied values (yet)
#
function parseTemplate {
    local left
    local right
    local both
    local query
    local value
    local template="$1"
    local depth=${depth:=0}
    depth=$(( depth + 1 ))
    if [[ "${template}" =~ ^(.*)}}(.*)$ ]] ; then
        left="${BASH_REMATCH[1]}"
        right="${BASH_REMATCH[2]}"
        left="$(parseTemplate "${left}")"
        (( $? != 0 )) && exit 1
        both="$(parseTemplate "${left}${right}")"
        (( $? != 0 )) && exit 1
        echo "${both}"
        return
    fi
    if [[ "${template}" =~ ^(.*){{(.*)$ ]] ; then
        left="${BASH_REMATCH[1]}"
        right="${BASH_REMATCH[2]}"
        right="$(parseTemplate "${right}")"
        (( $? != 0 )) && exit 1
        echo -e "${left}${right}"
        return
    fi
    if [[ "${template}" =~ ^(\.[\.a-z_=]+)$ ]] ; then
        if [[ "${template}" == *"="* ]] ; then 
            query="${template%=*}"
            value="${template#*=}"
        else 
            query="${template}"
            value=""
        fi
        result="$(readProjectValue "${query}")"
        if isError "${result}" ; then
            # No need to echo $BOXCLI_ERROR_VALUE because
            # this is a recursive function that is not
            # creating a subshell.
            exit 1
        fi
        if isEmpty "${result}" ; then
            result="${value}"
        fi
        echo "${result}"
        return
    fi
    echo -e "${template}"
    if [ ${depth} -eq 1 ] ; then
        throwError
        exit 1
    fi
}