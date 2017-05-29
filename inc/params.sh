# params.sh

#
# Todo:
# Figure out how to handle these which should be for the current run
# but are named like export variables.
# Also need to figure out which of them should be accessible by subshells.
#

# Clause names
BOXCLI_CLAUSES=()
# Switch names
BOXCLI_SWITCHES=()
# Switch values
BOXCLI_SWITCH_VALUES=()
# Valid Switchs
BOXCLI_VALID_SWITCHES=()
# Valid Switch Value Expected
BOXCLI_BOOLEAN_SWITCHES=()
# Switchs surrounded/separated by '|'
BOXCLI_SWITCHES_STR=""
# Valid Switchs surrounded/separated by '|'
BOXCLI_VALID_SWITCHES_STR="|"

export BOXCLI_IS_QUIET="*"
export BOXCLI_IS_JSON="*"
export BOXCLI_IS_COMPOSER="*"
export BOXCLI_IS_DRY_RUN="*"
export BOXCLI_IS_NO_PROMPT="*"

boxcliSavedGlobalSwitches=()

function saveGlobalSwitches {
    boxcliSavedGlobalSwitches=()
    boxcliSavedGlobalSwitches+=("${BOXCLI_IS_QUIET}")
    boxcliSavedGlobalSwitches+=("${BOXCLI_IS_JSON}")
    boxcliSavedGlobalSwitches+=("${BOXCLI_IS_COMPOSER}")
    boxcliSavedGlobalSwitches+=("${BOXCLI_IS_DRY_RUN}")
    boxcliSavedGlobalSwitches+=("${BOXCLI_IS_NO_PROMPT}")
}

function restoreGlobalSwitches {
    if (( 5 == ${#boxcliSavedGlobalSwitches[@]} )) ; then
        BOXCLI_IS_QUIET="${boxcliSavedGlobalSwitches[0]}"
        BOXCLI_IS_JSON="${boxcliSavedGlobalSwitches[1]}"
        BOXCLI_IS_COMPOSER="${boxcliSavedGlobalSwitches[2]}"
        BOXCLI_IS_DRY_RUN="${boxcliSavedGlobalSwitches[3]}"
        BOXCLI_IS_NO_PROMPT="${boxcliSavedGlobalSwitches[4]}"
    fi
    boxcliSavedGlobalSwitches=()
}

function setQuiet {
    export BOXCLI_IS_QUIET="yes"
}

function hasSwitchValue {
    value="$(getSwitchValue "$1")"
    if [ "" != "${value}" ] ; then
        return 0
    fi
    return 1
}

function getSwitchValue {
    local switch="$(echo "$1" | sed 's/_/-/g')"
    local i=0
    local value=""
    local default="$(if [ $# -ge 2 ] ; then echo "$2" ; fi)"
    if (( 0 < "${#BOXCLI_SWITCHES[@]}" )) ; then
        for test_switch in "${BOXCLI_SWITCHES[@]}" ; do
            temp="${BOXCLI_SWITCH_VALUES[${i}]}"
            i=$((i+1))
            [ "${switch}" != "${test_switch}" ] && continue
            value="${temp}"
            break
        done
    fi
    if [ "" == "${value}" ] ; then
        value="$default"
    fi
    echo "${value}"
}

function testYesNoSwitch {
    local varName="$1"
    local switch="$2"
    if [ "*" != "${!varName}" ] ; then
        if [ "yes" == "${!varName}" ] ; then
            eval $varName='yes'
            return 0
        fi
        eval $varName='no'
        return 1
    else
        if [ "" == "${BOXCLI_SWITCHES_STR}" ] ; then
            #
            # "!" is a flag character to indicate switch not set
            # See below for comparison to "!"
            #
            eval $varName='no'
            return 1
        else
            if [[ "${BOXCLI_SWITCHES_STR}" =~ "|${switch}|" ]] ; then
                eval $varName='yes'
                return 0
            fi
            eval $varName='no'
            return 1
        fi
    fi

}

function __boxProcessCmdLine {
    local __arg
    local __switch
    local __is_bool
    local __val
    local __i
    local __cmdPath="$(getBoxCliRootDir)"
    local __lastPath=""
    local __tst_path
    for __arg in "$@" ; do
        if [ "${__cmdPath}" != "${__lastPath}" ] ; then
            __lastPath="${__cmdPath}"
            for __switch in "${__cmdPath}"/switches/* ; do
                # Collect valid switches
                __switch="$(basename "${__switch}")"
                if [[ "*" == "${__switch}" ]] ; then
                    continue
                fi
                if [[ "--" != "${__switch:0:2}" ]] ; then
                    continue
                fi
                # Remove leading "--"
                __switch="${__switch:2}"
                if [[ "${__switch}" == *"="* ]] ; then
                    # Is a value expected?
                    __switch=${__switch%=*}
                    __is_bool="no"
                else
                    __is_bool="yes"
                fi
                BOXCLI_VALID_SWITCHES+=("${__switch}")
                BOXCLI_BOOLEAN_SWITCHES+=("${__is_bool}")
                BOXCLI_VALID_SWITCHES_STR+="${__switch}|"
            done
        fi
        if [[ $__arg == -* ]] ; then
            __val=''
            if [[ "--" == "${__arg:0:2}" ]] ; then
                __arg=${__arg:2}
                if [[ "${__arg}" == *"="* ]] ; then
                    __val="${__arg#*=}"
                    __arg="${__arg%=*}"
                fi
                if ! [[ "${BOXCLI_VALID_SWITCHES_STR}" =~ "|${__arg}|" ]] ; then
                    stdErr "Invalid switch --${__arg}"
                    exit 1
                fi
                local __i=0
                for __switch in "${BOXCLI_VALID_SWITCHES[@]}" ; do
                    __is_bool="${BOXCLI_BOOLEAN_SWITCHES[${__i}]}"
                    __i=$((__i+1))
                    [ "${__switch}" != "${__arg}" ] && continue
                    if [[ "no" == "${__is_bool}" && "" == "${__val}" ]] ; then
                        stdErr "Switch \"${__arg}\" expects a value in the form:"
                        stdErr ""
                        stdErr "\t--${__arg}=example"
                        stdErr "Or:" 
                        stdErr "\t--${__arg}=\"Foo Bar\""
                        stdErr ""
                        stdErr "Note: No spaces around the equal (\"=\") sign."
                        exit 1
                    fi 
                done

            else
                __arg=${__arg#"-"}
                if [[ 1 < ${#__arg} ]] ; then
                    stdErr "Invalid switch -${__arg}. Did you mean --${__arg}?"
                    exit 1
                fi
            fi
            # echo "Arg: $arg"
            # echo "Val: $val"
            # echo "---"
            BOXCLI_SWITCHES+=("${__arg}")
            BOXCLI_SWITCH_VALUES+=("${__val}")
        else
            BOXCLI_CLAUSES+=($__arg)
            __tst_path="${__cmdPath}/cmd/${__arg}"
            if [ -d "${__tst_path}" ] ; then
                __cmdPath="${__tst_path}"
            fi
        fi
    done

    #
    # TODO: Need to validate args at some point
    #
    if (( 0 == "${#BOXCLI_SWITCHES[@]}" )) ; then
        BOXCLI_SWITCHES_STR=""
    else
        BOXCLI_SWITCHES_STR="|$(IFS="|";echo "${BOXCLI_SWITCHES[*]}")|"
    fi
}

function isNoPrompt {
    testYesNoSwitch "BOXCLI_IS_NO_PROMPT" 'no-prompt'
    return $?
}

function isDryRun {
    testYesNoSwitch "BOXCLI_IS_DRY_RUN" 'dry-run'
    return $?
}

function isComposer {
    testYesNoSwitch "BOXCLI_IS_COMPOSER" 'composer'
    return $?
}

function isJSON {
    testYesNoSwitch "BOXCLI_IS_JSON" 'json'
    return $?
}
function isQuiet {
    testYesNoSwitch "BOXCLI_IS_QUIET" 'quiet'
    return $?
}
