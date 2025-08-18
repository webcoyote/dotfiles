#!/usr/bin/env bash
# Bash utility functions
# by Patrick Wyatt

# Exit this script without killing the shell
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit || return

# Standard shell script startup
set -euo pipefail
trap 'echo "$0: line $LINENO: $BASH_COMMAND: exitcode $?"' ERR
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Time scripts
START_TIME=$(date +%s.%N)
# ... work
END_TIME=$(date +%s.%N)
ELAPSED_TIME=$(echo "$END_TIME - $START_TIME" | bc --mathlib | xargs printf "%.2f\n")
echo "✅ Build completed in $ELAPSED_TIME seconds!"


# Print with colors
log () {
  [[ ${VERBOSE:0} -lt 1 ]] || echo >&2 "$@"
}
info () {
  echo >&2 -e "\033[36m$*\033[0m"
}
warn () {
  echo >&2 -e "\033[33m$*\033[0m"
}
error () {
  echo >&2 -e "\033[31m$*\033[0m"
}
abort () {
  error "$@"
  exit 1
}


# Defining HEREDOCS "almost just like" Ruby
# http://ss64.com/bash/read.html
# http://stackoverflow.com/questions/1167746/how-to-assign-a-heredoc-value-to-a-variable-in-bash
# Example:
# heredoc MESSAGE << EOF
#    your favorite text here
# EOF
heredoc(){ IFS=$'\n' read -r -d '' "${1}" || true; }


run_quietly () {
  # Show command if verbose
  [[ ${VERBOSE:0} -lt 1 ]] || echo >&2 "+ $@"

  # Run command and show output if it fails
  OUTPUT=$("$@") || (
    EXITCODE=$?
    error Command failed: $(basename $0) "$@"
    echo >&2 $OUTPUT
    exit $EXITCODE
  )

  # Show output of command if very verbose
  [[ ${VERBOSE:0} -lt 3 ]] || echo >&2 $OUTPUT
}


# Check whether a command exists - returns 0 if it does, 1 if it does not
exists() {
  if command -v "$1" &>/dev/null ; then
    return 0
  else
    return 1
  fi
}

require_root () {
  if [ $(id -u) -ne 0 ]; then
    abort 'ERROR: You need to run this script with sudo or as root.'
  fi
}

# A debugger for bash: https://blog.jez.io/bash-debugger/
debugger() {
  echo "Stopped in REPL. Press ^D to resume, or ^C to abort."
  local line
  while read -r -p "> " line; do
    eval "$line"
  done
  echo
}

is_sourced() {
  if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    return 0
  else
    return 1
  fi
}

# Detect if running inside WSL1 ("Microsoft") or WSL2 ("microsoft")
is_wsl() {
  if [[ $(uname -r) =~ icrosoft ]]; then
    return 0
  else
    return 1
  fi
}

# Trap errors in debugger if requested
if [[ -n "${BASHFUL_DEBUG:-}" ]]; then
	trap 'debugger' ERR
fi

# Set XARGS variable to handle lack of '-r' option on OSX; then use `"${XARGS[@]}" ...`
if ! command -v gxargs &>/dev/null ; then
    XARGS=("gxargs" "--no-run-if-empty")
elif args --version 2>&1 |grep -s GNU &>/dev/null ; then
    XARGS=("xargs" "--no-run-if-empty")
else
    XARGS=("xargs")
fi


title_case() { set ${*,,} ; echo ${*^} ; }
lower_case() { set ${*,,} ; echo ${*} ; }
