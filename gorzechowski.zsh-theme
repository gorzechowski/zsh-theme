RESET="%{$reset_color%}"
WHITE="${RESET}%{$fg[white]%}"
WHITE_BOLD="${RESET}%{$fg_bold[white]%}"
BLUE="${RESET}%{$fg[blue]%}"
BLUE_BOLD="${RESET}%{$fg_bold[blue]%}"
RED="${RESET}%{$fg[red]%}"
RED_BOLD="${RESET}%{$fg_bold[red]%}"
GREEN="${RESET}%{$fg[green]%}"
GREEN_BOLD="${RESET}%{$fg_bold[green]%}"
CYAN="${RESET}%{$fg[cyan]%}"
CYAN_BOLD="${RESET}%{$fg_bold[cyan]%}"

function defined() {
    local varname="$1"

    typeset -p "$varname" > /dev/null 2>&1
}

function uptree_file_exists() {
    local file_name="$1"
    local current_dir=$(pwd)

    while [[ "${current_dir}" != "." && "${current_dir}" != "/" ]]; do
        if [[ -f ${current_dir}/${file_name} ]]; then
            return 0 # true
        fi

        current_dir=$(dirname -- "${current_dir}")
    done

    return 1 # false
}

function files_exists() {
    local files_mask="$1"
    local max_depth="$2"
    local current_dir=$(pwd)

    if [[ -n $(find "${current_dir}" -type f -name "${files_mask}" -maxdepth "${max_depth}") ]]; then
        return 0 # true
    fi

    return 1 # false
}

defined GORZECHOWSKI_THEME_VAGRANT_MACHINE_PROMPT || GORZECHOWSKI_THEME_VAGRANT_MACHINE_PROMPT=false
defined GORZECHOWSKI_THEME_NODE_VERSION_PROMPT || GORZECHOWSKI_THEME_NODE_VERSION_PROMPT=true
defined GORZECHOWSKI_THEME_GIT_PROMPT || GORZECHOWSKI_THEME_GIT_PROMPT=true
defined GORZECHOWSKI_THEME_GIT_STATUS_PROMPT || GORZECHOWSKI_THEME_GIT_STATUS_PROMPT=true
defined GORZECHOWSKI_THEME_HOSTNAME_LOCAL_PROMPT || GORZECHOWSKI_THEME_HOSTNAME_LOCAL_PROMPT=true
defined GORZECHOWSKI_THEME_HOSTNAME_SSH_PROMPT || GORZECHOWSKI_THEME_HOSTNAME_SSH_PROMPT=true
defined GORZECHOWSKI_THEME_PHP_VERSION_PROMPT || GORZECHOWSKI_THEME_PHP_VERSION_PROMPT=true

local segment_prompt
local cwd="${CYAN_BOLD}%c${RESET}"

if [[ $UID -eq 0 ]]; then
    segment_prompt="${RED_BOLD}➤ "
else
    segment_prompt="${GREEN_BOLD}➤ "
fi

function vagrant_machine_prompt() {
    if [[ ${GORZECHOWSKI_THEME_VAGRANT_MACHINE_PROMPT} == false ]]; then
        return;
    fi

    local prompt

    uptree_file_exists "Vagrantfile" && {
        IFS="," local index=($(vagrant status --machine-readable | grep "state-human-short"))
        machine=${index[2]}
        state=${index[4]}

        prompt="${BLUE_BOLD}vagrant:(${RED_BOLD}${machine}${WHITE} ➜ ${RED_BOLD}${state}${BLUE_BOLD})"
    }

    if [[ -n ${prompt} ]]; then
        echo "${prompt} "
    fi
}

function node_version_prompt() {
    if [[ ${GORZECHOWSKI_THEME_NODE_VERSION_PROMPT} == false ]]; then
        return;
    fi

    local prompt

    uptree_file_exists "package.json" && {
        prompt="${BLUE_BOLD}node:(${RED_BOLD}$(node -v)${BLUE_BOLD})"
    }

    if [[ -n ${prompt} ]]; then
        echo "${prompt} "
    fi
}

function php_version_prompt() {
    if [[ ${GORZECHOWSKI_THEME_PHP_VERSION_PROMPT} == false ]]; then
        return;
    fi

    local prompt

    (uptree_file_exists "composer.json" || files_exists "*.php" 2) && {
        IFS=" " version=($(php -v 2>&1 | grep -oe "^PHP\s[0-9.]*\s"))

        prompt="${BLUE_BOLD}php:(${RED_BOLD}${version[2]}${BLUE_BOLD})"
    }

    if [[ -n ${prompt} ]]; then
        echo "${prompt} "
    fi
}

function git_prompt() {
    if [[ ${GORZECHOWSKI_THEME_GIT_PROMPT} == false ]]; then
        return;
    fi

    tester=$(git rev-parse --git-dir 2> /dev/null) || return

    ZSH_THEME_GIT_PROMPT_STAGED="${GREEN_BOLD}●"
    ZSH_THEME_GIT_PROMPT_UNSTAGED="${RED_BOLD}●"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="${WHITE_BOLD}●"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    local prompt=""

    if [[ ${GORZECHOWSKI_THEME_GIT_STATUS_PROMPT} != false ]]; then
        local index=$(git status --porcelain 2> /dev/null)

        # is anything staged?
        if $(echo "$index" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
            prompt="${prompt}${ZSH_THEME_GIT_PROMPT_STAGED}"
        fi

        # is anything unstaged?
        if $(echo "$index" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
            prompt="${prompt}${ZSH_THEME_GIT_PROMPT_UNSTAGED}"
        fi

        # is anything untracked?
        if $(echo "$index" | grep '^?? ' &> /dev/null); then
            prompt="${prompt}${ZSH_THEME_GIT_PROMPT_UNTRACKED}"
        fi

        if [[ -n ${prompt} ]]; then
            prompt=" ${prompt}"
        fi
    fi

    ZSH_THEME_GIT_PROMPT_PREFIX="${BLUE_BOLD}git:(${RED_BOLD}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="${prompt}${BLUE_BOLD}) "

    echo "$(git_prompt_info)"
}

function hostname_prompt() {
    local prompt

    if [[ $GORZECHOWSKI_THEME_HOSTNAME_SSH_PROMPT == true && -n $SSH_CONNECTION ]]; then
        prompt="${RED}ssh:[${WHITE}$(whoami)${WHITE_BOLD}@${WHITE}%M${RED}]"
    elif [[ $GORZECHOWSKI_THEME_HOSTNAME_LOCAL_PROMPT == true ]]; then
        prompt="${RED}[${WHITE}%M${RED}]"
    else
        return
    fi

    echo "${prompt} "
}

PROMPT='$(hostname_prompt)${segment_prompt} ${cwd} $(git_prompt)$(vagrant_machine_prompt)$(node_version_prompt)$(php_version_prompt)${RESET}'
