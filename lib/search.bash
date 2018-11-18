#!/usr/bin/env bash
#
# Search by Konstantin Gredeskoul «github.com/kigster»
#———————————————————————————————————————————————————————————————————————————————
# This function returns list of aliases, plugins and completions in bash-it,
# whose name or description matches one of the search terms provided as arguments.
#
# Usage:
#    ❯ bash-it search [-|@]term1 [-|@]term2 ... \
#       [ --enable  | -e ] \
#       [ --disable | -d ] \
#       [ --refresh | -r ]
#       [ --help    | -h ]
#
#    Single dash, as in "-chruby", indicates a negative search term.
#    Double dash indicates a command that is to be applied to the search result.
#    At the moment only --help, --enable and --disable are supported.
#    An '@' sign indicates an exact (not partial) match.
#
# Examples:
#    ❯ bash-it search ruby rbenv rvm gem rake
#          aliases:  bundler
#          plugins:  chruby chruby-auto ruby rbenv rvm ruby
#      completions:  rvm gem rake
#
#    ❯ bash-it search ruby rbenv rvm gem rake -chruby
#          aliases:  bundler
#          plugins:  ruby rbenv rvm ruby
#      completions:  rvm gem rake
#
# Examples of enabling or disabling results of the search:
#
#    ❯ bash-it search ruby
#          aliases:  bundler
#          plugins:  chruby chruby-auto ruby
#
#    ❯ bash-it search ruby -chruby --enable
#          aliases:  bundler
#          plugins:  ruby
#
# Examples of using exact match:

#    ❯ bash-it search @git @ruby
#          aliases:  git
#          plugins:  git ruby
#      completions:  git
#
export BASH_IT_GREP=${BASH_IT_GREP:-$(which egrep)}
declare -a BASH_IT_COMPONENTS=(aliases plugins completions)

_bash-it-search() {
  _about 'searches for given terms amongst bash-it plugins, aliases and completions'
  _param '1: term1'
  _param '2: [ term2 ]...'
  _example '$ _bash-it-search @git ruby -rvm rake bundler'

  local component

  yellow_underlined='\e[4;33m'
  bold_green='\e[1;32m'
  bold_red='\e[1;31m'
  bold_blue='\e[1;34m'
  bold_yellow='\e[1;33m'
  text_black='\e[0;30m'
  clr='\e[0m'

  if [[ -z "$*" ]] ; then
    _bash-it-search-help
    return 0
  fi

  local -a args=()
  for word in $@; do
    if [[ ${word} == "--help" || ${word} == "-h" ]]; then
      _bash-it-search-help
      return 0
    elif [[ ${word} == "--refresh" || ${word} == "-r" ]]; then
      _bash-it-cache-clean
    else
      args=(${args[@]} ${word})
    fi
  done

  for component in "${BASH_IT_COMPONENTS[@]}" ; do
    _bash-it-search-component "${component}" "${args[@]}"
  done

  return 0
}

_bash-it-search-help() {
  printf "${bold_yellow}
${yellow_underlined}USAGE${clr}

   bash-it search [-|@]term1 [-|@]term2 ... [ --enable | --disable | --help ]

${yellow_underlined}DESCRIPTION${clr}

   One of the most time-saving features of the Bash-It search is the ability
   to globally enable or disable all matches that the search returns. Instead
   of reading the complete help for each component, simply search for the
   keyword, and then re-run the search with '--enable' or '--disable' at the
   end. When used this way, it becomes critical to be able to exclude some
   search results, and/or be able to match not just a substring, but also
   force an exact match. All of this is supported by this functionality.

${yellow_underlined}EXAMPLES${clr}

   For example, ${bold_green}bash-it search git${clr} would match any alias,
   completion or plugin that has the word 'git' in either the module name or
   it's description. You should see something like this when you run this
   command:

         ${bold_green}❯ bash-it search git${bold_blue}
               aliases:  git gitsvn
               plugins:  autojump fasd git git-subrepo jgitflow jump
           completions:  git git_flow git_flow_avh${clr}

   You can exclude some terms by prefixing a term with a minus, eg:

         ${bold_green}❯ bash-it search git -flow -svn${bold_blue}
               aliases:  git
               plugins:  autojump fasd git git-subrepo jump
           completions:  git${clr}

   Finally, if you prefix a term with '@' symbol, that indicates an exact
   match. Note, that we also pass the '--enable' flag, which would ensure
   that all matches are automatically enabled. The example is below:

         ${bold_green}❯ bash-it search @git --enable${bold_blue}
               aliases:  git
               plugins:  git
           completions:  git${clr}

${yellow_underlined}SUMMARY${clr}

   Take advantage of the search functionality to discover what Bash-It can do
   for you. Try searching for partial term matches, mix and match with the
   negative terms, or specify an exact matches of any number of terms. Once
   you created the search command that returns ONLY the modules you need,
   simply append '--enable' or '--disable' at the end to activate/deactivate
   each module.

"
}

_bash-it-cache-file() {
  local component="${1}"
  local file="/tmp/bash_it/${component}.status"
  mkdir -p $(dirname ${file})
  printf ${file}
}

_bash-it-cache-clean() {
  local component="$1"
  if [[ -z ${component} ]] ; then
    for component in "${BASH_IT_COMPONENTS[@]}" ; do
      _bash-it-cache-clean "${component}"
    done
  else
    rm -f $(_bash-it-cache-file ${component})
  fi
}

#———————————————————————————————————————————————————————————————————————————————
# array=("something to search for" "a string" "test2000")
# _bash-it-array-contains-element "a string" "${array[@]}"
# ( prints "true" or "false" )
_bash-it-array-contains-element () {
  local e
  local r=false
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && r=true; done
  echo -n $r
}

_bash-it-grep() {
  if [[ -z "${BASH_IT_GREP}" ]] ; then
    export BASH_IT_GREP="$(which egrep || which grep || '/usr/bin/grep')"
  fi
  printf "%s " "${BASH_IT_GREP}"
}

_bash-it-is-partial-match() {
  local component="$1"
  local term="$2"
  _bash-it-component-help "${component}" | $(_bash-it-grep) -E -i -q -- "${term}"
}

_bash-it-component-term-matches-negation() {
  local match="$1"; shift
  local negative
  for negative in "$@"; do
    [[ "${match}" =~ "${negative}" ]] && return 0
  done

  return 1
}

_bash-it-component-help() {
  local component="$1"
  local file=$(_bash-it-cache-file ${component})
  if [[ ! -s "${file}" || -z $(find "${file}" -mmin -2) ]] ; then
    rm -f "${file}" 2>/dev/null
    local func="_bash-it-${component}"
    ${func} | $(_bash-it-grep) -E '   \[' | cat > ${file}
  fi
  cat "${file}"
}

_bash-it-component-list() {
  local component="$1"
  _bash-it-component-help "${component}" | awk '{print $1}' | uniq | sort | tr '\n' ' '
}

_bash-it-component-list-matching() {
  local component="$1"; shift
  local term="$1"
  _bash-it-component-help "${component}" | $(_bash-it-grep) -E -- "${term}" | awk '{print $1}' | sort | uniq
}

_bash-it-component-list-enabled() {
  local component="$1"
  _bash-it-component-help "${component}" | $(_bash-it-grep) -E  '\[x\]' | awk '{print $1}' | uniq | sort | tr '\n' ' '
}

_bash-it-component-list-disabled() {
  local component="$1"
  _bash-it-component-help "${component}" | $(_bash-it-grep) -E -v '\[x\]' | awk '{print $1}' | uniq | sort | tr '\n' ' '
}

_bash-it-component-item-is-enabled() {
  local component="$1"
  local item="$2"
  _bash-it-component-help "${component}" | $(_bash-it-grep) -E '\[x\]' |  $(_bash-it-grep) -E -q -- "^${item}\s"
}

_bash-it-component-item-is-disabled() {
  local component="$1"
  local item="$2"
  _bash-it-component-help "${component}" | $(_bash-it-grep) -E -v '\[x\]' |  $(_bash-it-grep) -E -q -- "^${item}\s"
}


_bash-it-search-component() {
  local component="$1"
  shift

  _about 'searches for given terms amongst a given component'
  _param '1: component type, one of: [ aliases | plugins | completions ]'
  _param '2: term1 term2 @term3'
  _param '3: [-]term4 [-]term5 ...'
  _example '$ _bash-it-search-component aliases @git rake bundler -chruby'

  # if one of the search terms is --enable or --disable, we will apply
  # this action to the matches further  ` down.
  local component_singular action action_func
  local -a search_commands=(enable disable)
  for search_command in "${search_commands[@]}"; do
    if [[ $(_bash-it-array-contains-element "--${search_command}" "$@") == "true" ]]; then
      component_singular=${component}
      component_singular=${component_singular/es/}  # aliases -> alias
      component_singular=${component_singular/ns/n} # plugins -> plugin

      action="${search_command}"
      action_func="_${action}-${component_singular}"
      break
    fi
  done

  local -a terms=($@)           # passed on the command line

  unset exact_terms
  unset partial_terms
  unset negative_terms

  local -a exact_terms=()       # terms that should be included only if they match exactly
  local -a partial_terms=()     # terms that should be included if they match partially
  local -a negative_terms=()    # negated partial terms that should be excluded

  unset component_list
  local -a component_list=( $(_bash-it-component-list "${component}") )
  local term

  for term in "${terms[@]}"; do
    local search_term="${term:1}"
    if [[ "${term:0:2}" == "--" ]] ; then
      continue
    elif [[ "${term:0:1}" == "-"  ]] ; then
      negative_terms=(${negative_terms[@]} "${search_term}")
    elif [[ "${term:0:1}" == "@"  ]] ; then
      if [[ $(_bash-it-array-contains-element "${search_term}" "${component_list[@]}") == "true" ]]; then
        exact_terms=(${exact_terms[@]} "${search_term}")
      fi
    else
      partial_terms=(${partial_terms[@]} $(_bash-it-component-list-matching "${component}" "${term}") )
    fi
  done

  local -a total_matches=(${exact_terms[@]} ${partial_terms[@]})

  unset matches
  declare -a matches=()
  for match in ${total_matches[@]}; do
    local include_match=true
    if  [[ ${#negative_terms[@]} -gt 0 ]]; then
      ( _bash-it-component-term-matches-negation "${match}" "${negative_terms[@]}" ) && include_match=false
    fi
    ( ${include_match} ) && matches=(${matches[@]} "${match}")
  done
  _bash-it-search-result "${component}" "${action}" "${action_func}" "${matches[@]}"
  unset matches final_matches terms
}

_bash-it-search-result() {
  local component="$1"; shift
  local action="$1"; shift
  local action_func="$1"; shift
  local -a matches=($@)

  local color_component color_enable color_disable color_off

  [[ -z "${NO_COLOR}" ]] && {
    color_component='\e[1;34m'
    color_enable='\e[1;32m'
    color_disable='\e[0;0m'
    color_off='\e[0;0m'
    color_sep=':'
  }

  [[ -n "${NO_COLOR}" ]] && {
    color_component=''
    color_sep='  => '
    color_enable='✓'
    color_disable=''
    color_off=''
  }

  local match
  local modified=0

  if [[ "${#matches[@]}" -gt 0 ]] ; then
    printf "${color_component}%13s${color_sep} ${color_off}" "${component}"

    for match in "${matches[@]}"; do
      local enabled=0
      ( _bash-it-component-item-is-enabled "${component}" "${match}" ) && enabled=1

      local match_color compatible_action

      (( ${enabled} )) && {
        match_color=${color_enable}
        compatible_action="disable"
      }

      (( ${enabled} )) || {
        match_color=${color_disable}
        compatible_action="enable"
      }

      len=${#match}
      if [[ -n ${NO_COLOR} ]]; then
        local m="${match_color}${match}"
        len=${#m}
      fi

      printf " ${match_color}${match}"  # print current state
      if [[ "${action}" == "${compatible_action}" ]]; then

        if [[ ${action} == "enable" ]]; then
          _bash-it-flash-term ${len} ${match}
        else
          _bash-it-erase-term ${len}
        fi
        modified=1
        result=$(${action_func} ${match})
        local temp="color_${compatible_action}"
        match_color=${!temp}
        _bash-it-rewind ${len}
        printf "${match_color}${match}"
      fi

      printf "${color_off}"
    done

    [[ ${modified} -gt 0 ]] && _bash-it-cache-clean ${component}
    printf "\n"
  fi
}

_bash-it-rewind() {
  local len="$1"
  printf "\033[${len}D"
}

_bash-it-flash-term() {
  local len="$1"
  local match="$2"
  local delay=0.1
  local color

  for color in ${text_black} ${bold_blue} ${bold_yellow} ${bold_red} ${bold_green} ; do
    sleep ${delay}
    _bash-it-rewind "${len}"
    printf "${color}${match}"
  done
}

_bash-it-erase-term() {
  local len="$1"
  _bash-it-rewind ${len}
  for a in {0..30}; do
    [[ ${a} -gt ${len} ]] && break
    printf "%.*s" $a "."
    sleep 0.05
  done
}
