#!/bin/bash

echo
echo "➜ Installing necessary packages..."
sudo apt -y install \
    unzip \
    jq \
    curl \
    || { echo "Failed to install necessary packages."; exit 128; }

echo
echo "➜ Downloading Cica font..."
font_dir="${HOME}/.local/share/fonts/Cica"
mkdir -p "${font_dir}"

latest_version=$(\
    curl -sSfL \
        -H 'Accept: application/vnd.github.v3+json' \
        https://api.github.com/repos/miiton/Cica/releases \
        | jq -r '.[0].tag_name'
)
zip_file="Cica_${latest_version}_with_emoji.zip"
curl -#SfL \
    "https://github.com/miiton/Cica/releases/download/${latest_version}/${zip_file}" \
    -o "/tmp/${zip_file}"
unzip -qqo -d "${font_dir}" "/tmp/${zip_file}"
rm -f "/tmp/${zip_file}"

echo
echo "➜ Building font cache..."
fc-cache -fv >/dev/null

echo
echo "🎉 Cica font installation is complete!!"
echo
