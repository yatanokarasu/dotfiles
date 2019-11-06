#!/bin/bash

CURRENT_DIR=$(cd $(dirname $0); pwd)

for _dotfile in $(ls -1A ${CURRENT_DIR}); do
    if [[ ! ${_dotfile} =~ ^\. || ${_dotfile} == .git ]]; then
        continue
    fi

    ln -snf ${CURRENT_DIR}/${_dotfile} ${HOME}/${_dotfile}
done

