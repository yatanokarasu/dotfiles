#!/bin/bash

readonly ASDF_REPO_URL=https://github.com/asdf-vm/asdf.git


install_prerequisite() {
    echo "➜ Installing necessary packages..."
    sudo apt update \
    sudo apt -y install \
        build-essential \
        automake \
        autoconf \
        libarchive-tools \
        libreadline-dev \
        libncurses-dev \
        libssl-dev \
        libyaml-dev \
        libxslt1-dev \
        libffi-dev \
        libtool \
        unixodbc-dev \
        unzip \
        jq \
        || { echo "Failed to install necessary packages."; exit 128; }
}


install_asdf() {
    git clone "${ASDF_REPO_URL}" "${HOME}/.asdf" || exit 255
    # shellcheck disable=SC2164
    pushd "${HOME}/.asdf" >/dev/null
    git checkout "$(git describe --abbrev=0 --tags)" >/dev/null 2>&1 || exit 255
    # shellcheck disable=SC2164
    popd >/dev/null
}


install_asdf_plugins() {
    # shellcheck disable=SC1090
    source "${HOME}/.asdf/asdf.sh"

    while IFS= read -r _line || [ -n "${_line}" ]; do
        # shellcheck disable=SC2034
        read -r _tool _ignored <<<"${_line}"

        echo -n "➜ Adding \"${_tool}\" plugin... "
        asdf plugin add "${_tool}" >/dev/null 2>&1 && echo  "OK"
    done <"${HOME}/.tool-versions"

    echo
    echo "Installing plugins specified by ${HOME}/.tool-version ..."
    asdf install
}


echo "Installing asdf-vm..."
install_prerequisite
install_asdf
install_asdf_plugins
echo
echo "🎉 asdf-vm installation is complete!!"
echo
