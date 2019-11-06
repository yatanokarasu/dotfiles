#!/bin/bash

if [ -d ~/.functions ]; then
    for a in $(ls -1 ~/.functions/* 2>/dev/null); do
        if [ -f ${a} ]; then
            . ${a}
        fi
    done
fi
