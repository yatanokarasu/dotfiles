#!/bin/bash


echo "Installing x-set-keys for emacs key-binding..."

echo "➜ Updating APT repositories..."
sudo apt -y update

echo
echo "➜ Installing necessary packages..."
sudo apt -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    || { echo "Failed to install necessary packages."; exit 128; }

echo
echo "➜ Adding Docker’s official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo
echo "➜ Adding stable repository..."
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

echo
echo "➜ Updating APT repositories again..."
sudo apt -y update

echo
echo "➜ Installing docker-ce..."
sudo apt -y install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    || { echo "Failed to install docker-ce."; exit 128; }

echo
echo -n "➜ Adding user to docker group... "
sudo usermod -aG docker "$(whoami)"
echo "OK"

echo
echo "🎉 docker-ce installation is complete!!"
echo