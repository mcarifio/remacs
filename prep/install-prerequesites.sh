#!/usr/bin/env bash

# Make it a little easier to install prerequisites to compilation. Currently ubuntu and fedora only.
# usage: bash $(git rev-parse --show-toplevel)/prep/install-prerequisites.sh

me=$(realpath ${BASH_SOURCE:-$0})
here=$(dirname ${me})




# Are we root yet?
if [[ 0 != $(id -u) ]] ; then
    # Rerun as root. Sudo password once and simplifies the code below.
    echo "rerun '${me}' as root"
    exec sudo ${me} "$*"
fi


# See if this box/container "has" some program such as apt or dnf. Sets $?.
function has {
    local _exec=${1:?'expecting a program'}
    local _version=${2:-'--version'}
    1>/dev/null 2>&1 ${_exec} ${_version}
}

# Exit with a message and status code 1.
function _error {
    local msg=${1:-'error'}
    echo ${msg} > /dev/stderr
    exit 1
}


cat ${here}/README.md

# Find the right package manager. Assumes they don't overlap.
if has apt ; then
    # Debian/Ubuntu variant.
    apt update
    apt upgrade -y
    apt autoremove -y
    apt install -y texinfo libjpeg-dev libtiff-dev  libgif-dev libxpm-dev libgtk-3-dev gnutls-dev libncurses5-dev libxml2-dev libxt-dev build-essential automake clang libclang-dev
    apt-mark auto texinfo libjpeg-dev libtiff-dev  libgif-dev libxpm-dev libgtk-3-dev gnutls-dev libncurses5-dev libxml2-dev libxt-dev build-essential automake clang libclang-dev
elif has dnf ; then
    # Fedoare Core variant.
    dnf upgrade --refresh
    dnf -y install texinfo libjpeg-turbo-devel libtiff-devel giflib-devel libXpm-devel gtk3-devel gnutls-devel ncurses-devel libxml2-devel libXt-devel @development-tools automake clang clang-devel
elif has brew ; then
    brew install gnutls texinfo autoconf
else
    # Arch and all the rest, not yet supported.
    _error "'$(lsb_release -sd 2>/dev/null || uname -a)' package manager? Stopping..."
fi


     