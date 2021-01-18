#!/bin/bash

# shellcheck disable=SC1090
if [ -d "${HOME}/.asdf" ]; then
    source "$HOME/.asdf/asdf.sh"
    source "$HOME/.asdf/completions/asdf.bash"
fi
