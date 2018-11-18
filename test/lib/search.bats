#!/usr/bin/env bats

load ../../lib/search

load ../test_helper
load ../../lib/helpers
load ../../lib/composure

cite _about _param _example _group _author _version

function local_setup {
  if [[ -z ${BASH_IT} ]]; then
    export BASH_IT_TEMP="$(mktemp)"
    export BASH_IT="$(dirname ${BASH_IT_TEMP})"
    mkdir -p "${BASH_IT}"
  fi

  lib_directory="$(cd "$(dirname "$0")" && pwd)"
  # Use rsync to copy Bash-it to the temp folder
  # rsync is faster than cp, since we can exclude the large ".git" folder
  rsync -qavrKL -d --delete-excluded --exclude=.git $lib_directory/../../.. "$BASH_IT"

  rm -rf "$BASH_IT"/enabled
  rm -rf "$BASH_IT"/aliases/enabled
  rm -rf "$BASH_IT"/completion/enabled
  rm -rf "$BASH_IT"/plugins/enabled
}

@test "search: ruby gem bundle rake rails" {
  # first disable them all, so that  the output does not appear with a checkbox
  # and we can compare the result
  NO_COLOR=true bash-it search ruby gem bundle rake rails --disable > /dev/null
  bash-it search ruby gem bundle rake rails 2>&1 | grep -q aliases
}

@test "search: ruby gem bundle -chruby rake rails" {
  NO_COLOR=true bash-it search ruby gem bundle -chruby rake rails --disable > /dev/null
  NO_COLOR=true bash-it search ruby gem bundle -chruby rake rails 2>&1| grep -q "aliases"
}

@test "search: plugin git" {
  NO_COLOR=true bash-it search git 2>&1 | grep -q git
  [[ $? == 1 ]]
}
