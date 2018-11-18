#!/usr/bin/env bats

load ../../lib/search

load ../test_helper
load ../../lib/helpers
load ../../lib/utilities
load ../../lib/search

cite _about _param _example _group _author _version

load ../../plugins/available/base.plugin
load ../../aliases/available/git.aliases
load ../../plugins/available/ruby.plugin
load ../../plugins/available/rails.plugin
load ../../completion/available/bundler.completion
load ../../completion/available/gem.completion
load ../../completion/available/rake.completion

load ../../lib/helpers

function local_setup {
  setup_test_fixture

  export OLD_PATH="$PATH"
  export PATH="/usr/bin:/bin:/usr/sbin"
}

function local_teardown {
  export PATH="$OLD_PATH"
  unset OLD_PATH
}

@test "search: plugin base" {
  export BASH_IT_SEARCH_USE_COLOR=false
  run _bash-it-search-component 'plugins' 'base'
  assert_line -n 0 '      plugins:  base  '
}

@test "search: git" {
  run _bash-it-search 'git' --no-color
  assert_line -n 0 '      aliases:  git   gitsvn  '
  assert_line -n 1 '      plugins:  autojump   git   git-subrepo   jgitflow   jump  '
  assert_line -n 2 '  completions:  git   git_flow   git_flow_avh  '
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
