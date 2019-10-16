#!/bin/bash

if [ -d ~/.functions ]; then
    for a in $(ls -1 ~/.functions/*); do
        if [ -f ${a} ]; then
            . ${a}
        fi
    done
fi
