# templates.sh

#
# Parses templates that contain {{.jq.queries}} into project.json
# Queries can be nested but nest should have default value, e.g. {{foo.{{.abc=bar}}.baz}}.
# But there is no looping at this point and no supplied values (yet)
#
function parseTemplate {
    local left
    local right
    local query
    local value
    local template="$1"
    if [[ "${template}" =~ ^(.*)}}(.*)$ ]] ; then
        left="${BASH_REMATCH[1]}"
        right="${BASH_REMATCH[2]}"
        left="$(parseTemplate "${left}")"
        echo -e "$(parseTemplate "${left}${right}")"
        return
    fi
    if [[ "${template}" =~ ^(.*){{(.*)$ ]] ; then
        left="${BASH_REMATCH[1]}"
        right="${BASH_REMATCH[2]}"
        right="$(parseTemplate "${right}")"
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
        result="$(box util read-project-file "${query}")"
        if isEmpty "${result}" ; then
            result="${value}"
        fi
        echo "${result}"
        return
    fi
    echo -e "${template}"
}