#!/bin/bash
#
#   Copyright 2021 Yusuke TAKEI
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


current_filepath=$(dirname "$(readlink -f "$0")")
setup_tools=()

echo "Would you like to setup ..."
for _part in "${current_filepath}"/init.d/*.sh; do
    _filename="${_part##*/}"

    echo -n "  ${_filename%.sh}? (y/N): "
    read -r _input

    if [ -n "${_input}" ] && grep -qiE "y|yes" <<<"${_input,,}"; then
        setup_tools+=("${_filename}")
    fi
done


if [ "${#setup_tools[@]}" -eq 0 ]; then
    echo
    echo "Initilization does nothing"
    echo

    exit 1
fi


for _tool_installer in "${setup_tools[@]}"; do
    bash "${current_filepath}/init.d/${_tool_installer}"
done
