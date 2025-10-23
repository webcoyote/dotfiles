#!/usr/bin/env bash
# Hackish way to 'fix' path mangling
# https://github.com/direnv/direnv/issues/343#issuecomment-398868227
PATH=$(
  /usr/bin/echo "$PATH"           |
  /usr/bin/sed -E 's/C:/\/c/g'    |
  /usr/bin/sed -E 's/\\/\//g'     |
  /usr/bin/sed -E 's/;/:/g'       |
  /usr/bin/sed -E 's!/c/c/!/c/!g'
)
export PATH
