# params.sh

# Clause names
BOXCLI_CLAUSES=()
# Option names
BOXCLI_OPTIONS=()
# Option values
BOXCLI_OPTVALS=()
# Valid Options
BOXCLI_VALOPTS=()
# Valid Option Value Expected
BOXCLI_VALEXP=()
# Options surrounded/separated by '|'
BOXCLI_OPT_STR=""
# Valid Options surrounded/separated by '|'
BOXCLI_VO_STR="|"

BOXCLI_IS_QUIET=""
BOXCLI_IS_JSON=""
BOXCLI_IS_COMPOSER=""

function isComposer {
    _testBoolOption "BOXCLI_IS_COMPOSER" 'composer'
    return $?
}

function isJSON {
    _testBoolOption "BOXCLI_IS_JSON" 'json'
    return $?
}
function isQuiet {
    _testBoolOption "BOXCLI_IS_QUIET" 'q' 'quiet'
    return $?
}

function _testBoolOption {
    varName=$1
    shift
    if [ "" == "${!varName}" ] ; then
        if [ "" == "${BOXCLI_OPT_STR}" ] ; then
            #
            # "!" is a flag character to indicate option not set
            # See below for comparison to "!"
            #
            eval $varName='!'
            return 1
        fi
        for option in "$@" ; do
            if [[ "${BOXCLI_OPT_STR}" =~ "|${option}|" ]] ; then
                eval $varName="${option}"
                return 0
            fi
        done
        return 1
    fi

    if [ "!" == "${!varName}" ] ; then
        return 1
    fi
    return 0
}

function _box_process_params {
    local arg
    local opt
    local exp
    local val
    local i
    local cmd_path="${BOXCLI_ROOT_DIR}"
    local last_path=""
    for arg in "$@" ; do
        if [ "${cmd_path}" != "${last_path}" ] ; then
            last_path="${cmd_path}"
            for opt in "${cmd_path}"/opts/* ; do 
                # Collect valid options
                opt="$(basename "${opt}")"
                if [[ "--" != "${opt:0:2}" ]] ; then
                    continue
                fi
                opt="${opt:2}"
                if [[ "${opt}" == *"="* ]] ; then
                    # Is a value expected?
                    opt=${opt%=*}
                    exp=1
                else
                    exp=0
                fi
                BOXCLI_VALOPTS+=($opt)
                BOXCLI_VALEXP+=($exp)
                BOXCLI_VO_STR+="${opt}|"
            done
        fi
        if [[ $arg == -* ]] ; then
            local val=''
            if [[ "--" == "${arg:0:2}" ]] ; then
                arg=${arg:2}
                if [[ "${arg}" == *"="* ]] ; then
                    arg=${arg%=*}
                    val=${arg#*=}
                fi
                if ! [[ "${BOXCLI_VO_STR}" =~ "|${arg}|" ]] ; then
                    stdErr "Invalid option --${arg}"
                    exit 1
                fi
                local i=0
                for opt in "${BOXCLI_VALOPTS[@]}" ; do
                    exp="${BOXCLI_VALEXP[${i}]}"
                    i=$((i+1))
                    [ "${opt}" != "${arg}" ] && continue
                    if [[ "1" == "${exp}" && "" == "${val}" ]] ; then
                        stdErr "Option \"${arg}\" expects a value in the form:"
                        stdErr ""
                        stdErr "\t--${arg}=example" 
                        stdErr "Or:" 
                        stdErr "\t--${arg}=\"Foo Bar\"" 
                        stdErr ""
                        stdErr "Note: No spaces around the equal (\"=\") sign."
                        exit 1
                    fi 
                done

            else
                arg=${arg#"-"}
                if [[ 1 < ${#arg} ]] ; then
                    stdErr "Invalid option -${arg}. Did you mean --${arg}?"
                    exit 1
                fi
            fi
            BOXCLI_OPTIONS+=($arg)
            BOXCLI_OPTVALS+=($val)
        else
            BOXCLI_CLAUSES+=($arg)
            tst_path="${cmd_path}/cmd/${arg}"
            if [ -d "${tst_path}" ] ; then
                cmd_path="${tst_path}"
            fi
        fi
    done

    #
    # TODO: Need to validate options at some point
    #
    if (( 0 == "${#BOXCLI_OPTIONS[@]}" )) ; then
        BOXCLI_OPT_STR=""
    else
        BOXCLI_OPT_STR=$(IFS="|";echo "${BOXCLI_OPTIONS[*]}")
        BOXCLI_OPT_STR="|${BOXCLI_OPT_STR}|"
    fi
}

