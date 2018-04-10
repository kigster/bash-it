#!/usr/bin/env bash

# based off of n0qorg
# looks like, if you're in a git repo:
# ± ~/path/to (branch ✓) $
# in glorious red / blue / yellow color scheme


RBENV_THEME_PROMPT_PREFIX=' '
RBENV_THEME_PROMPT_SUFFIX=' '

move-right() {
  by=${1:-1000}
  printf "\e[${by}C"
}

move-left() {
  by=${1:-1000}
  printf "\e[${by}D"
}

time_prompt() {
  move-right
  move-left 12
  printf "${blue} ⏰  $(clock_prompt)"
}

prompt_setter() {
  code=$?
  if [[ ${code} -eq 0 ]]; then
    status="${green}✔︎"
  else
    status="${red}˟ [ code=${code} ]"
  fi
  # Save history
  history -a
  history -c
  history -r

  PS1="${red}$(scm_char) ${green}\u @ ${orange}\h${blue}$(scm_prompt_info)${yellow}$(ruby_version_prompt) ${status} $(time_prompt)\n${black}${background_yellow}  ↪   \w    ${clr}${yellow}${clr} "
  PS2='❯ '
  PS4='→ '
}

safe_append_prompt_command prompt_setter

SCM_SHOW_GIT_USER=true
SCM_SHOW_GIT_DEAILS=true
SCM_NONE_CHAR='·'
SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${green}✓"
SCM_THEME_PROMPT_PREFIX=" ("
SCM_THEME_PROMPT_SUFFIX="${yellow})"
RVM_THEME_PROMPT_PREFIX=" ("
RVM_THEME_PROMPT_SUFFIX=")"
