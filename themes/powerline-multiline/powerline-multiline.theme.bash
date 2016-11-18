#!/usr/bin/env bash

. "$BASH_IT/themes/powerline-multiline/powerline-multiline.base.bash"

PROMPT_CHAR=${POWERLINE_PROMPT_CHAR:="❯"}
POWERLINE_LEFT_SEPARATOR=${POWERLINE_LEFT_SEPARATOR:=""}
POWERLINE_LEFT_SEPARATOR_SOFT=${POWERLINE_LEFT_SEPARATOR_SOFT:=""}
POWERLINE_RIGHT_SEPARATOR=${POWERLINE_RIGHT_SEPARATOR:=""}
POWERLINE_RIGHT_SEPARATOR_SOFT=${POWERLINE_RIGHT_SEPARATOR_SOFT:=""}
POWERLINE_LEFT_END=${POWERLINE_LEFT_END:=""}
POWERLINE_RIGHT_END=${POWERLINE_RIGHT_END:=""}
POWERLINE_PADDING=${POWERLINE_PADDING:=2}

POWERLINE_COMPACT=${POWERLINE_COMPACT:=0}
POWERLINE_COMPACT_BEFORE_SEPARATOR=${POWERLINE_COMPACT_BEFORE_SEPARATOR:=${POWERLINE_COMPACT}}
POWERLINE_COMPACT_AFTER_SEPARATOR=${POWERLINE_COMPACT_AFTER_SEPARATOR:=${POWERLINE_COMPACT}}
POWERLINE_COMPACT_BEFOR_FIRST_SEGMENT=${POWERLINE_COMPACT_BEFORE_FIRST_SEGMENT:=${POWERLINE_COMPACT}}
POWERLINE_COMPACT_AFTER_LAST_SEGMENT=${POWERLINE_COMPACT_AFTER_LAST_SEGMENT:=${POWERLINE_COMPACT}}
POWERLINE_COMPACT_PROMPT=${POWERLINE_COMPACT_PROMPT:=${POWERLINE_COMPACT}}

USER_INFO_SSH_CHAR=${POWERLINE_USER_INFO_SSH_CHAR:=" "}

USER_INFO_THEME_PROMPT_COLOR=${POWERLINE_USER_INFO_COLOR:=32}
USER_INFO_THEME_PROMPT_COLOR_SUDO=${POWERLINE_USER_INFO_COLOR_SUDO:=202}

PYTHON_VENV_CHAR=${POWERLINE_PYTHON_VENV_CHAR:="❲p❳ "}
CONDA_PYTHON_VENV_CHAR=${POWERLINE_CONDA_PYTHON_VENV_CHAR:="❲c❳ "}
PYTHON_VENV_THEME_PROMPT_COLOR=${POWERLINE_PYTHON_VENV_COLOR:=35}

SCM_NONE_CHAR=""
SCM_GIT_CHAR=${POWERLINE_SCM_GIT_CHAR:=" "}
SCM_HG_CHAR=${POWERLINE_SCM_HG_CHAR:="☿ "}
SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_DIRTY=""
SCM_THEME_PROMPT_CLEAN_COLOR=${POWERLINE_SCM_CLEAN_COLOR:=25}
SCM_THEME_PROMPT_DIRTY_COLOR=${POWERLINE_SCM_DIRTY_COLOR:=88}
SCM_THEME_PROMPT_STAGED_COLOR=${POWERLINE_SCM_STAGED_COLOR:=30}
SCM_THEME_PROMPT_UNSTAGED_COLOR=${POWERLINE_SCM_UNSTAGED_COLOR:=92}
SCM_THEME_PROMPT_COLOR=${SCM_THEME_PROMPT_CLEAN_COLOR}

NVM_THEME_PROMPT_PREFIX=""
NVM_THEME_PROMPT_SUFFIX=""
NODE_CHAR=${POWERLINE_NODE_CHAR:="❲n❳ "}
NODE_THEME_PROMPT_COLOR=${POWERLINE_NODE_COLOR:=22}

RVM_THEME_PROMPT_PREFIX=""
RVM_THEME_PROMPT_SUFFIX=""
RBENV_THEME_PROMPT_PREFIX=""
RBENV_THEME_PROMPT_SUFFIX=""
RUBY_THEME_PROMPT_COLOR=${POWERLINE_RUBY_COLOR:=161}
RUBY_CHAR=${POWERLINE_RUBY_CHAR:="❲r❳ "}

TERRAFORM_THEME_PROMPT_COLOR=${POWERLINE_TERRAFORM_COLOR:=161}
TERRAFORM_CHAR=${POWERLINE_TERRAFORM_CHAR:="❲t❳ "}

KUBERNETES_CONTEXT_THEME_CHAR=${POWERLINE_KUBERNETES_CONTEXT_CHAR:="⎈ "}
KUBERNETES_CONTEXT_THEME_PROMPT_COLOR=${POWERLINE_KUBERNETES_CONTEXT_COLOR:=26}

AWS_PROFILE_CHAR=${POWERLINE_AWS_PROFILE_CHAR:="❲aws❳ "}
AWS_PROFILE_PROMPT_COLOR=${POWERLINE_AWS_PROFILE_COLOR:=208}

CWD_THEME_PROMPT_COLOR=${POWERLINE_CWD_COLOR:=240}

LAST_STATUS_THEME_PROMPT_COLOR=${POWERLINE_LAST_STATUS_COLOR:=196}

CLOCK_THEME_PROMPT_COLOR=${POWERLINE_CLOCK_COLOR:=240}

BATTERY_AC_CHAR=${BATTERY_AC_CHAR:="🔋 "}
BATTERY_STATUS_THEME_PROMPT_GOOD_COLOR=0
BATTERY_STATUS_THEME_PROMPT_LOW_COLOR=208
BATTERY_STATUS_THEME_PROMPT_CRITICAL_COLOR=160

THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:="%H:%M:%S"}

IN_VIM_THEME_PROMPT_COLOR=${POWERLINE_IN_VIM_COLOR:=245}
IN_VIM_THEME_PROMPT_TEXT=${POWERLINE_IN_VIM_TEXT:="vim"}

HOST_THEME_PROMPT_COLOR=${POWERLINE_HOST_COLOR:=0}

SHLVL_THEME_PROMPT_COLOR=${POWERLINE_SHLVL_COLOR:=${HOST_THEME_PROMPT_COLOR}}
SHLVL_THEME_PROMPT_CHAR=${POWERLINE_SHLVL_CHAR:="§"}

DIRSTACK_THEME_PROMPT_COLOR=${POWERLINE_DIRSTACK_COLOR:=${CWD_THEME_PROMPT_COLOR}}
DIRSTACK_THEME_PROMPT_CHAR=${POWERLINE_DIRSTACK_CHAR:="←"}

HISTORY_NUMBER_THEME_PROMPT_COLOR=${POWERLINE_HISTORY_NUMBER_COLOR:=0}
HISTORY_NUMBER_THEME_PROMPT_CHAR=${POWERLINE_HISTORY_NUMBER_CHAR:="#"}

COMMAND_NUMBER_THEME_PROMPT_COLOR=${POWERLINE_COMMAND_NUMBER_COLOR:=0}
COMMAND_NUMBER_THEME_PROMPT_CHAR=${POWERLINE_COMMAND_NUMBER_CHAR:="#"}

POWERLINE_LEFT_PROMPT=${POWERLINE_LEFT_PROMPT:="scm python_venv ruby node cwd"}
POWERLINE_RIGHT_PROMPT=${POWERLINE_RIGHT_PROMPT:="in_vim clock battery user_info"}

<<<<<<< HEAD
=======
function set_rgb_color {
  if [[ "${1}" != "-" ]]; then
    fg="38;5;${1}"
  fi
  if [[ "${2}" != "-" ]]; then
    bg="48;5;${2}"
    [[ -n "${fg}" ]] && bg=";${bg}"
  fi
  echo -e "\[\033[${fg}${bg}m\]"
}

function __powerline_user_info_prompt {
  local user_info=""
  local color=${USER_INFO_THEME_PROMPT_COLOR}

  if sudo -n uptime 2>&1 | grep -q "load"; then
    color=${USER_INFO_THEME_PROMPT_COLOR_SUDO}
  fi
  case "${POWERLINE_PROMPT_USER_INFO_MODE}" in
    "sudo")
      if [[ "${color}" == "${USER_INFO_THEME_PROMPT_COLOR_SUDO}" ]]; then
        user_info="!"
      fi
      ;;
    *)
      if [[ -n "${SSH_CLIENT}" ]]; then
        user_info="${USER_INFO_SSH_CHAR}${USER}@${HOSTNAME}"
      else
        user_info="${USER}@${HOSTNAME}"
      fi
      ;;
  esac
  [[ -n "${user_info}" ]] && echo "${user_info}|${color}"
}

function __powerline_ruby_prompt {
  local ruby_version=""

  if command_exists rvm; then
    ruby_version="$(rvm_version_prompt)"
  elif command_exists rbenv; then
    ruby_version=$(rbenv_version_prompt)
  fi

  [[ -n "${ruby_version}" ]] && echo "${RUBY_CHAR}${ruby_version}|${RUBY_THEME_PROMPT_COLOR}"
}

function __powerline_python_venv_prompt {
  local python_venv=""

  if [[ -n "${CONDA_DEFAULT_ENV}" ]]; then
    python_venv="${CONDA_DEFAULT_ENV}"
    PYTHON_VENV_CHAR=${CONDA_PYTHON_VENV_CHAR}
  elif [[ -n "${VIRTUAL_ENV}" ]]; then
    python_venv=$(basename "${VIRTUAL_ENV}")
  fi

  [[ -n "${python_venv}" ]] && echo "${PYTHON_VENV_CHAR}${python_venv}|${PYTHON_VENV_THEME_PROMPT_COLOR}"
}

function __powerline_scm_prompt {
  local color=""
  local scm_prompt=""

  scm_prompt_vars

  if [[ "${SCM_NONE_CHAR}" != "${SCM_CHAR}" ]]; then
    if [[ "${SCM_DIRTY}" -eq 3 ]]; then
      color=${SCM_THEME_PROMPT_STAGED_COLOR}
    elif [[ "${SCM_DIRTY}" -eq 2 ]]; then
      color=${SCM_THEME_PROMPT_UNSTAGED_COLOR}
    elif [[ "${SCM_DIRTY}" -eq 1 ]]; then
      color=${SCM_THEME_PROMPT_DIRTY_COLOR}
    else
      color=${SCM_THEME_PROMPT_CLEAN_COLOR}
    fi
    if [[ "${SCM_GIT_CHAR}" == "${SCM_CHAR}" ]]; then
      scm_prompt+="${SCM_CHAR}${SCM_BRANCH}${SCM_STATE}"
    fi
    echo "${scm_prompt}${scm}|${color}"
  fi
}

function __powerline_cwd_prompt {
  echo "$(pwd | sed "s|^${HOME}|~|")|${CWD_THEME_PROMPT_COLOR}"
}

function __powerline_clock_prompt {
  echo "$(date +"${THEME_PROMPT_CLOCK_FORMAT}")|${CLOCK_THEME_PROMPT_COLOR}"
}

function __powerline_battery_prompt {
  local color=""
  local battery_status="$(battery_percentage 2> /dev/null)"

  if [[ -z "${battery_status}" ]] || [[ "${battery_status}" = "-1" ]] || [[ "${battery_status}" = "no" ]]; then
    true
  else
    if [[ "$((10#${battery_status}))" -le 5 ]]; then
      color="${BATTERY_STATUS_THEME_PROMPT_CRITICAL_COLOR}"
    elif [[ "$((10#${battery_status}))" -le 25 ]]; then
      color="${BATTERY_STATUS_THEME_PROMPT_LOW_COLOR}"
    else
      color="${BATTERY_STATUS_THEME_PROMPT_GOOD_COLOR}"
    fi
    ac_adapter_connected && battery_status="${BATTERY_AC_CHAR}${battery_status}"
    echo "${battery_status}%|${color}"
  fi
}

function __powerline_in_vim_prompt {
  if [ -n "$VIMRUNTIME" ]; then
    echo "${IN_VIM_THEME_PROMPT_TEXT}|${IN_VIM_THEME_PROMPT_COLOR}"
  fi
}

function __powerline_last_status_prompt {
  [[ "$1" -ne 0 ]] && echo "$(set_rgb_color ${LAST_STATUS_THEME_PROMPT_COLOR} -) ${1} ${normal}"
}

function __powerline_left_segment {
  local OLD_IFS="${IFS}"; IFS="|"
  local params=( $1 )
  IFS="${OLD_IFS}"
  local separator_char=""
  local separator=""

  if [[ "${SEGMENTS_AT_LEFT}" -gt 0 ]]; then
    separator="$(set_rgb_color ${LAST_SEGMENT_COLOR} ${params[1]})${separator_char}${normal}${normal}"
  fi
  LEFT_PROMPT+="${separator}$(set_rgb_color - ${params[1]}) ${params[0]} ${normal}"
  LAST_SEGMENT_COLOR=${params[1]}
  (( SEGMENTS_AT_LEFT += 1 ))
}

function __powerline_right_segment {
  local OLD_IFS="${IFS}"; IFS="|"
  local params=( $1 )
  IFS="${OLD_IFS}"
  local separator_char=""
  local padding=2
  local separator_color=""

  if [[ "${SEGMENTS_AT_RIGHT}" -eq 0 ]]; then
    separator_color="$(set_rgb_color ${params[1]} -)"
  else
    separator_color="$(set_rgb_color ${params[1]} ${LAST_SEGMENT_COLOR})"
    (( padding += 1 ))
  fi
  RIGHT_PROMPT+="${separator_color}${separator_char}${normal}$(set_rgb_color - ${params[1]}) ${params[0]} ${normal}$(set_rgb_color - ${COLOR})${normal}"
  RIGHT_PROMPT_LENGTH=$(( ${#params[0]} + RIGHT_PROMPT_LENGTH + padding ))
  LAST_SEGMENT_COLOR="${params[1]}"
  (( SEGMENTS_AT_RIGHT += 1 ))
}

function __powerline_prompt_command {
  local last_status="$?" ## always the first
  local separator_char=""
  local move_cursor_rightmost='\033[500C'

  LEFT_PROMPT=""
  RIGHT_PROMPT=""
  RIGHT_PROMPT_LENGTH=0
  SEGMENTS_AT_LEFT=0
  SEGMENTS_AT_RIGHT=0
  LAST_SEGMENT_COLOR=""

  ## left prompt ##
  for segment in $POWERLINE_LEFT_PROMPT; do
    local info="$(__powerline_${segment}_prompt)"
    [[ -n "${info}" ]] && __powerline_left_segment "${info}"
  done
  [[ -n "${LEFT_PROMPT}" ]] && LEFT_PROMPT+="$(set_rgb_color ${LAST_SEGMENT_COLOR} -)${separator_char}${normal}"

  ## right prompt ##
  if [[ -n "${POWERLINE_RIGHT_PROMPT}" ]]; then
    LEFT_PROMPT+="${move_cursor_rightmost}"
    for segment in $POWERLINE_RIGHT_PROMPT; do
      local info="$(__powerline_${segment}_prompt)"
      [[ -n "${info}" ]] && __powerline_right_segment "${info}"
    done
    LEFT_PROMPT+="\033[${RIGHT_PROMPT_LENGTH}D"
  fi

  PS1="${LEFT_PROMPT}${RIGHT_PROMPT}\n$(__powerline_last_status_prompt ${last_status})${PROMPT_CHAR} "

  ## cleanup ##
  unset LAST_SEGMENT_COLOR \
        LEFT_PROMPT RIGHT_PROMPT RIGHT_PROMPT_LENGTH \
        SEGMENTS_AT_LEFT SEGMENTS_AT_RIGHT
}

>>>>>>> Printing hostname always
safe_append_prompt_command __powerline_prompt_command
