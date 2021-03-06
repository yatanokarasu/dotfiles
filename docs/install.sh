#!/bin/bash
#
#  _____     ______     ______   ______   __     __         ______     ______
# /\  __-.  /\  __ \   /\__  _\ /\  ___\ /\ \   /\ \       /\  ___\   /\  ___\
# \ \ \/\ \ \ \ \/\ \  \/_/\ \/ \ \  __\ \ \ \  \ \ \____  \ \  __\   \ \___  \
#  \ \____-  \ \_____\    \ \_\  \ \_\    \ \_\  \ \_____\  \ \_____\  \/\_____\
#   \/____/   \/_____/     \/_/   \/_/     \/_/   \/_____/   \/_____/   \/_____/
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


# commands as canonical path
readonly CMD_MKDIR=$(which mkdir)
readonly CMD_READLINK=$(which readlink)
readonly CMD_TAR=$(which tar)

# constants
readonly DOTFILES_REPO_URL=https://github.com/yatanokarasu/dotfiles.git
readonly DOTFILES_DIR=$(${CMD_READLINK} -f "${DOT_DIR:-${HOME}/.dotfiles}")
readonly DOTFILES_ARCHIVE_URL=https://github.com/yatanokarasu/dotfiles/archive/master.tar.gz

# colors
declare -A COLORS=(
    [reset]="\e[0m"

    # normal
    [normal_red]="\e[0;31m"
    [normal_green]="\e[0;32m"
    [normal_yellow]="\e[0;33m"
    [normal_blue]="\e[0;34m"
    [normal_magenta]="\e[0;35m"
    [normal_cyan]="\e[0;36m"
    [normal_white]="\e[0;37m"

    # bold
    [bold_red]="\e[1;31m"
    [bold_green]="\e[1;32m"
    [bold_yellow]="\e[1;33m"
    [bold_blue]="\e[1;34m"
    [bold_magenta]="\e[1;35m"
    [bold_cyan]="\e[1;36m"
    [bold_white]="\e[1;37m"
)


print_logo() {
    echo ''
    echo ' _____     ______     ______   ______   __     __         ______     ______     '
    echo '/\  __-.  /\  __ \   /\__  _\ /\  ___\ /\ \   /\ \       /\  ___\   /\  ___\    '
    echo '\ \ \/\ \ \ \ \/\ \  \/_/\ \/ \ \  __\ \ \ \  \ \ \____  \ \  __\   \ \___  \   '
    echo ' \ \____-  \ \_____\    \ \_\  \ \_\    \ \_\  \ \_____\  \ \_____\  \/\_____\  '
    echo '  \/____/   \/_____/     \/_/   \/_/     \/_/   \/_____/   \/_____/   \/_____/  '
    echo ''
}


color() {
    local _color=${1}
    local _msg=${2}
    local _style=${3:-normal}

    printf "${COLORS[${_style}_${_color}]}%s${COLORS[reset]}" "${_msg}"
}


white() {
    color "${FUNCNAME[0]}" "${1}" "${2}"
}


green() {
    color "${FUNCNAME[0]}" "${1}" "${2}"
}


yellow() {
    color "${FUNCNAME[0]}" "${1}" "${2}"
}


blue() {
    color "${FUNCNAME[0]}" "${1}" "${2}"
}


magenta() {
    color "${FUNCNAME[0]}" "${1}" "${2}"
}


cyan() {
    color "${FUNCNAME[0]}" "${1}" "${2}"
}


red() {
    color "${FUNCNAME[0]}" "${1}" "${2}"
}


log_header() {
    white "${1}" bold; echo
}


log_info() {
    white "${1}"; echo
}


log_error() {
    red "${1}"; echo
}


check_ok() {
    green "??? OK"
}


check_ng() {
    red "??? NG"
}


die() {
    log_error "${1}" 1>&2
    exit "${2:-1}"
}


can_use() {
    fetch_command=${fetch_command:-$(which "${1}" 2>/dev/null)}

    return $?
}


look_for() {
    white " ??? ${1}..."

    if can_use "${1}"; then
        check_ok
    else
        check_ng
    fi

    echo
}


check_prerequisite() {
    log_header "Looking for commands..."

    look_for git
    look_for curl
    look_for wget

    if [ -z "${fetch_command}" ]; then
        die "Either git, curl or wget is required."
    fi

    green "Use ${fetch_command} "; white "(Priority: git > curl > wget)"; echo; echo
}


fetch_via_git() {
    log_header "Downloading dotfiles..."

    if [ -d "${DOTFILES_DIR}" ]; then
        (
            cd "${DOTFILES_DIR}"  || die "Unexpected errors occured."
            ${fetch_command} pull || die "Please fix error and try again."
        )
    else
        ${fetch_command} clone "${DOTFILES_REPO_URL}" "${DOTFILES_DIR}" || die "Please fix error and try again."
    fi

    echo
}


fetch_dotfiles() {
    case "${fetch_command##*/}" in
    "git")
        fetch_via_git
        return 0;;
    "curl")
        fetch_command="${fetch_command} -k#SfL ${HTTP_PROXY:+-x "${HTTP_PROXY}" }-o-";;
    "wget")
        fetch_command="${fetch_command} -qO-";;
    esac

    ${CMD_MKDIR} -p "${DOTFILES_DIR}"
    ${fetch_command} "${DOTFILES_ARCHIVE_URL}" \
        | ${CMD_TAR} zxf - -C "${DOTFILES_DIR}" --strip-components 1 2>/dev/null \
            || die "Failed to fetch dotfiles."
}


celebration() {
    red     "????" bold
    magenta "????" bold
    yellow  "????" bold
    white "  ALL DONE!!!  " bold
    green   "????" bold
    cyan    "????" bold
    blue    "????" bold
    echo
    echo
}


last_notice() {
    echo "Please open a new terminal, or run the following in the existing one:"
    echo
    echo "    exec bash"
    echo
    white "Enjoy!!!" bold; echo
}


initlization() {
    if [ -f "${DOTFILES_DIR}/.initialized" ]; then
        return
    fi

    if grep -qsi "Ubuntu" /etc/issue; then
        bash "${DOTFILES_DIR}/bin/init.sh" && touch "${DOTFILES_DIR}/.initialized"
    else
        echo "Initialization can execute on Ubuntu only."
    fi
}


deploy_dotfiles() {
    # shellcheck disable=SC1090
    source "${DOTFILES_DIR}/docs/deploy.sh"

    # deploy as current user
    exec_deployment || die "Failed to deploy dotfiles..."

    # deploy as root user if you want
    yellow "Do you want to deploy for root user as well? (y/N): " bold
    local _input
    read -r _input </dev/tty

    if [ -n "${_input}" ] && grep -qiE "y|yes" <<<"${_input,,}"; then
        sudo \
            -H \
            --preserve-env=DOTFILES_DIR \
            bash -c "
                export DOTFILES_DIR=\"${DOTFILES_DIR}\"
                source \"${DOTFILES_DIR}/docs/deploy.sh\"
                exec_deployment
            " || die "Failed to deploy dotfiles..."
    else
        echo
    fi
}


dotfiles_install() {
    print_logo

    # Download .dotfiles
    check_prerequisite &&
    fetch_dotfiles &&

    # Deploy .dotfiles
    deploy_dotfiles
    celebration

    # Initialization (optionally)
    initlization

    last_notice
}

dotfiles_install
