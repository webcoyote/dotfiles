#!/usr/bin/env bash
# Cribbed from:
# https://news.ycombinator.com/item?id=39568728
# https://github.com/theimpostor/templates/blob/main/bash%2Ftemplate.sh
# https://github.com/TritonDataCenter/sdc-headnode/blob/master/buildtools/lib/error_handler.sh
# https://johannes.truschnigg.info/writing/2021-12_colodebug/
set -Eeuo pipefail

function warn() {
    printf >&2 "%s\n" "$@"
}

function die() {
    local ec=$?; if (( ec == 0 )); then ec=1; fi
    warn "$@"
    warn "Backtrace:"
    local frame=0; while caller $frame; do ((++frame)); done
    exit $ec
}
trap die ERR

# GLOBALS
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
# FUNCTIONS
function usage() {
    cat <<EOF
Usage: $0 [options] [--] [args]
options:
    --help, -h
        Print this message
    --debug, -d
        Enable debug tracing
    --
        Stop parsing options
EOF
}

# MAIN
while (($#)); do
    case $1 in
        --help|-h) usage; exit 0
            ;;
        --debug|-d)
            PS4='+ ${BASH_SOURCE:-}:${FUNCNAME[0]:-}:L${LINENO:-}:   '
            set -o xtrace
            ;;
        --) shift; break
            ;;
        -*) warn "Unrecognized argument: $1"; exit 1
            ;;
        *) break
            ;;
    esac; shift
done

if [ -t 1 ] ; then
    echo Writing to terminal
else
    echo Writing to file
fi

if (return 0 2>/dev/null) ; then
    echo Script is sourced
else
    echo Script is executed
fi

# # redirect output to file
# exec > >(tee "${LOG}")
# # tie stderr to stdout
# exec 2>&1

echo SCRIPT_DIR: "$SCRIPT_DIR"
echo args: "$@"

# vim:ft=bash:sw=4:ts=4:expandtab

false
