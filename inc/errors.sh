#!/usr/bin/env bash
#
# error.sh
#
# Useful for command substitution, .e.g "variable=$(command "${parameter}")"
#

#
# Array containing error messages for all runs of the box
# No errors means a single element of value 0 because
# accessing zero element arrays in bash is problematic.
#
export BOXCLI_ERRORS=( 0 )

#
# Initialize Error handling system by creating a named pipe
#
function initErrorSystem {
    #
    # Nothing needed
    #
    local x=0
}

#
# Delete the named error pipe for this
#
function cancelErrorSystem {
    if [ "1" == "${BOXCLI_NESTING_DEPTH}" ] ; then
        export BOXCLI_ERRORS=( 0 )
    fi
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
    # See: https://stackoverflow.com/a/1951523/102699
    #
    BOXCLI_ERRORS+=("${message}")
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
    local removeError
    if (( 1 <= $# )) ; then
        removeError="$1"
    else
        removeError=""
    fi

    local count=${#BOXCLI_ERRORS[@]}
    if (( 1 >= ${count} )) ; then
        #
        # Has no error, so 'getError()` returns false
        #
        return 1
    fi
    local last=$(( $count - 1 ))
    error="${BOXCLI_ERRORS[$last]}"
    if ! isEmpty "${removeError}" ; then
        unset BOXCLI_ERRORS[$last]
    fi
    echo "${error}"
    #
    # Has an error, so 'getError()` returns true
    #
    return 0
}

#
# Remove accumulated errors from the error system
#
function clearErrors {
    export BOXCLI_ERRORS=( 0 )
}

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
# Initialize the named pipe used for the error system
#
initErrorSystem