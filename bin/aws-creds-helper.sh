#!/usr/bin/env bash
#
# Instead of storing impersonation token credentials in ~/.aws/credentials
# you can use this script to generate & cache them on demand.
#
# How to configure your ~/.aws/config file:
#
#   [profile omg]
#   region = us-west-2
#   output = json
#   credential_process = "aws-creds-helper.sh" "arn:aws:iam::123456789000:role/Role-Name-Here" "omg"
#
# NOTE: if this script is not in the path you'll need to specify the full
# path, without variable expansions (e.g. "$HOME"), in 'credential_process'.
#
# How to call AWS functions:
#
#   $ aws --profile omg sts get-caller-identity
#   {
#       "UserId": "AAAAAAAAAAAAAAAAAAAAA:omg",
#       "Account": "123456789000",
#       "Arn": "arn:aws:sts::123456789000:assumed-role/Role-Name-Here/omg"
#   }
#
set -Eeuo pipefail

if [[ $# != 2 ]]; then
    echo >&2 "USAGE: $(basename ${BASH_SOURCE[0]}) ARN PROFILE"
    exit 1
fi
readonly ARN="$1"
readonly PROFILE="$2"

mkdir -p "$HOME/.aws"
readonly TEMP_CREDS="$HOME/.aws/$PROFILE.tmp"
if [[ -f "$TEMP_CREDS" ]]; then
    EXPIRE_DATE=$(jq <"$TEMP_CREDS" -r '.Expiration')
    EXPIRE_EPOCH=$(date --date="$EXPIRE_DATE" "+%s")
    NOW_EPOCH=$(date "+%s")

    if (( $EXPIRE_EPOCH > $NOW_EPOCH )); then
        cat "$TEMP_CREDS"
        exit 0
    fi
fi

cleanup() {
    EXIT=$?
    if [[ $EXIT != 0 ]]; then
        rm "$TEMP_CREDS"
        exit $EXIT
    fi
    exit 0
}
trap cleanup EXIT

aws sts assume-role --role-arn "$1" --role-session-name "$2" | jq '.Credentials + {Version: 1}' | tee "$TEMP_CREDS"
