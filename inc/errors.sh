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
# Return true if the most recent action was an error
#
function isError {
    local error="$(getError)"
    if isEmpty "${error}" ; then
        return 1
    fi
    return 0
}

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
    #
    # See: https://unix.stackexchange.com/a/114245/144192
    #
    echo "${message}" | tr -ds "\n\r" " " >> ${BOXCLI_ERRORS_FILE}
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
    if getError ; then
        #
        # Has an error, so 'hasError()` returns true
        #
        return 0
    fi
    #
    # Has no error, so 'hasError()` returns false
    #
    return 1
}

#
# Get most recent error
#
#   $1 - removeError - Any non-empty value to remove the error from the error stack.
#
function getError {
    if ! [ -f "${BOXCLI_ERRORS_FILE}" ] ; then
        return 0
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
    return 1
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