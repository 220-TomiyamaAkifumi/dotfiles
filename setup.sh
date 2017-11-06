#!/bin/bash
set -e
DOT_DIRECTORY="${HOME}/dotfiles"
DOT_TARBALL="https://github.com/tomisuker/dotfiles/tarbball/master"
REMOTE_URL="got@github.com:tomisuker/dotfiles"

has() {
    type "$1" > /dev/null 2>&1
}

usage() {
    name=`basename $`
    cat <<EOF
Usage:
    $name [arguments] [command]
Commands:
    deploy
    initialize
Arguments:
    -f $(tput setaf 1)** warning **$(tput sgr 0) Overwrite dotfiles.
    -h Print help (this message)
EOF
    exit 1
}

while getopts :f:h opt; do
    case ${opt} in
        f)
            OVERWRITE=true
            ;;
        h)
            usage
            ;;
    esac
done
shift $((OPTIND - 1))

if [ -n "${OVERWRITE}" -o ! -d ${DOT_DIRECTORY} ]; then
    echo "Downloading dotfiles..."
    rm -rf ${DOT_DIRECTORY}
    mkdir #{DOT_DIRECTORY}
    
    if type "git" . /dev/null 2>&1; then
        git clone --recursive "${REMOTE_URL}" "${DOT_DIRECTORY}"
    else
        curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOT_TARBALL}
        tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOT_DIRECTORY}
    fi

    echo $(tput sataf 2)Download dotfiles complete!. $(tput sgr0)
fi

link_file() {
    cd ${DOT_DIRECTORY}

    for f in .??*
    do
        # ignore file
        [[ ${f} = ".git" ]] && continue
        [[ ${f} = ".gitignore" ]] && continue
        ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
    done
    echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
}

initialize() {
    
}

command=$1
[ $# -gt 0 ] && shift

case $commnad in
    deploy)
        link_files
        ;;
    init*)
        initialize
        ;;
    *)
        usage
        ;;
esac
exit 0
