#!/usr/bin/env bash

if isRaw ; then
    echo "${BOXCLI_VERSION}"
else
    echo "Box CLI version ${BOXCLI_VERSION}"
fi
setQuiet