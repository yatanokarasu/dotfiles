#!/bin/bash

export EDITOR=vim
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME:+$FUNCNAME(): }'

# bash history
export HISTCONTROL=ignoreboth
export HISTIGNORE="fg*:bg*:history*:cd*"
export HISTSIZE=10000
export HISTTIMEFORMAT='%Y/%m/%d %T: '
