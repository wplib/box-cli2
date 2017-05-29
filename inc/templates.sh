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
        [[ hasError ]] && exit 1
        both="$(parseTemplate "${left}${right}")"
        [[ hasError ]] && exit 1
        echo "${both}"
        return
    fi
    if [[ "${template}" =~ ^(.*){{(.*)$ ]] ; then
        left="${BASH_REMATCH[1]}"
        right="${BASH_REMATCH[2]}"
        right="$(parseTemplate "${right}")"
        [[ hasError ]] && exit 1
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
        [[ hasError ]] && exit 1
        if isEmpty "${result}" ; then
            result="${value}"
        fi
        echo "${result}"
        return
    fi
    if hasError ; then
        exit 1
    else
        echo -e "${template}"
    fi
}