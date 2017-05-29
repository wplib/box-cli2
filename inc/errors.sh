#!/usr/bin/env bash
#
# error.sh
#
# Useful for command substitution, .e.g "variable=$(command "${parameter}")"
#

#
# Use files: https://stackoverflow.com/a/26811936/102699
#
export BOXCLI_ERRORS_FILE="${BOXCLI_TEMP_DIR%/}/errors"

#
# Initialize Error handling system by creating a named pipe
#
function initErrorSystem {
    touch "${BOXCLI_ERRORS_FILE}"
}

#
# Delete the named error pipe for this
#
function pushError {
    if [ "" == "$1" ] ; then
        message="1"
    else
        message="$1"
    fi
    echo "${message}" | stripCrLf >> ${BOXCLI_ERRORS_FILE}
}

#
# Get most recent error and remove from stack.
#
function popError {
    error="$(getError "1")"
    if isEmpty "${error}" ; then
        #
        # Has no error, so 'popError()` returns false
        #
        return 0
    fi
    #
    # Output the error
    #
    echo "${error}"
    #
    # Has an error, so 'popError()` returns true
    #
    return 1
}

#
# Test to see if any errors occurred
#
function hasError {
    local errors="$(cat "${BOXCLI_ERRORS_FILE}")"
    if isEmpty "${errors}" ; then
        #
        # Has no error, so 'hasError()` returns false aka 1
        #
        return 1
    fi
    #
    # Has an error, so 'hasError()` returns true aka 0
    #
    return 0
}

#
# Get most recent error
#
#   $1 - removeError - Any non-empty value to remove the error from the error stack.
#
function getError {
    if ! [ -f "${BOXCLI_ERRORS_FILE}" ] ; then
        #
        # If no error file, there is no error. Return 'false' aka 1
        #
        return 1
    fi

    local removeError
    if (( 1 <= $# )) ; then
        removeError="$1"
    else
        removeError=""
    fi

    local errors
    local saveIFS="${IFS}"
    #
    # See: https://stackoverflow.com/a/35383375/102699
    #
    IFS=$'\n' read -rd '' -a errors <<<"$(cat "${BOXCLI_ERRORS_FILE}")"
    IFS="${saveIFS}"
    local count=${#errors[@]}
    (( 0 == $count )) && return 1
    local last=$(( $count - 1 ))
    local error="${errors[$last]}"
    if ! isEmpty "${removeError}" ; then
        unset errors[$last]
        #
        # See: https://stackoverflow.com/a/20243503/102699
        #
        printf "%s\n" "${errors[@]}" > ${BOXCLI_ERRORS_FILE}
    fi
    echo "${error}"
    #
    # If has error. Return 'true' aka 0
    #
    return 0
}

#
# Remove accumulated errors from the error system
#
function clearErrors {
    rm "${BOXCLI_ERRORS_FILE}"
}

#
# Initialize the named pipe used for the error system
#
initErrorSystem