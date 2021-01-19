#!/bin/bash


register_gpg_key() {
    if which curl >/dev/null 2>&1; then
        curl -sSfL -o- "${1}" | sudo apt-key add -
    elif which wget >/dev/null 2>&1; then
        wget -q -O- "${1}" | sudo apt-key add -
    else
        echo "curl or wget is required"
        exit 128
    fi
}

echo "Installing VirtualBox..."
echo "➜ Adding VirtualBox GPG key..."
register_gpg_key "https://www.virtualbox.org/download/oracle_vbox_2016.asc"

echo
echo "➜ Adding contrib repository..."
sudo add-apt-repository \
    "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian \
    $(lsb_release -cs) \
    contrib"

echo
echo "➜ Updating APT repositories..."
sudo apt -y update

echo
echo "➜ Installing VirtualBox..."
sudo apt install -y \
    virtualbox-6.1 \
    || { echo "Failed to install VirtualBox."; exit 128; }

echo
echo -n "➜ Adding user to vboxusers group... "
sudo usermod -aG vboxusers "$(whoami)"
echo "OK"

echo
echo "🎉 VirtualBox installation is complete!!"
echo
