#!/usr/bin/env bash
# encoding: UTF-8

export txtblk='\e[0;30m' # Black - Regular
export txtred='\e[0;31m' # Red
export txtgrn='\e[0;32m' # Green
export txtylw='\e[0;33m' # Yellow
export txtblu='\e[0;34m' # Blue
export txtpur='\e[0;35m' # Purple
export txtcyn='\e[0;36m' # Cyan
export txtwht='\e[0;37m' # White
export bldblk='\e[1;30m' # Black - Bold
export bldred='\e[1;31m' # Red
export bldgrn='\e[1;32m' # Green
export bldylw='\e[1;33m' # Yellow
export bldblu='\e[1;34m' # Blue
export bldpur='\e[1;35m' # Purple
export bldcyn='\e[1;36m' # Cyan
export bldwht='\e[1;37m' # White
export unkblk='\e[4;30m' # Black - Underline
export undred='\e[4;31m' # Red
export undgrn='\e[4;32m' # Green
export undylw='\e[4;33m' # Yellow
export undblu='\e[4;34m' # Blue
export undpur='\e[4;35m' # Purple
export undcyn='\e[4;36m' # Cyan
export undwht='\e[4;37m' # White
export bakblk='\e[40m'   # Black - Background
export bakred='\e[41m'   # Red
export bakgrn='\e[42m'   # Green
export bakylw='\e[43m'   # Yellow
export bakblu='\e[44m'   # Blue
export bakpur='\e[45m'   # Purple
export bakcyn='\e[46m'   # Cyan
export bakwht='\e[47m'   # White
export txtrst='\e[0m'    # Text Reset

SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${green}✓"
SCM_THEME_PROMPT_PREFIX=" ${yellow}|${reset_color}"
SCM_THEME_PROMPT_SUFFIX="${yellow}|"

RVM_THEME_PROMPT_PREFIX="|"
RVM_THEME_PROMPT_SUFFIX="|"

function prompt_command() {
    PS1="\n|${green}${red}${reset_color}\h ${orange}in ${reset_color}\w\n${yellow}$(scm_char)$(scm_prompt_info) ${yellow}→${white} "
}

VIRTUALENV_THEME_PROMPT_PREFIX='|'
VIRTUALENV_THEME_PROMPT_SUFFIX='|'

function ruby_version_prompt {
  echo -e "[$(ruby --version 2>&1 | sed -E 's/ruby ([^ ]+).*/\1/g')]"
}
function python_version_prompt {
  echo -e "[$(python --version 2>&1 | sed 's/[^.0-9]//g')]"
}
function docker_status_prompt {
  echo -e "[$(docker-machine status default 2>/dev/null | tr '[A-Z]' '[a-z]')]"
}
function environment {
  # TODO: make this dynamic!
  echo -e "${red}X${reset_color}"
}
function where {
  echo -e "${green}[${blue}${USER}@${yellow}reinvent.one${green}]${reset_color}"
}
function prompt_char {
  if [ "${USER}" == "" -o "${USER}" == "root" ]; then
    printf "${bldwht}${bakred} ROOT ${txtrst}${bldred} ${txtrst} "
  else
    printf "${yellow}→${reset_color} "
  fi
}

PROMPT_COMMAND=prompt_command;

