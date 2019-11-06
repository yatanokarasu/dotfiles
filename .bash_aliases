#!/bin/bash

if [ -d ~/.aliases ]; then
    for a in $(ls -1 ~/.aliases/* 2>/dev/null); do
        if [ -f ${a} ]; then
            . ${a}
        fi
    done
fi
