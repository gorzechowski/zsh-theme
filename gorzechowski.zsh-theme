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

local status_prompt
local cwd="${CYAN_BOLD}%c${RESET}"

if [[ $UID -eq 0 ]]; then
    status_prompt="${RED_BOLD}➤ "
else
    status_prompt="${GREEN_BOLD}➤ "
fi

function node_prompt() {
    local prompt
    local current_dir=$(pwd)

    while [[ "${current_dir}" != "." && "${current_dir}" != "/" ]]; do
        if [[ -f ${current_dir}/package.json ]]; then
            prompt="${BLUE_BOLD}node:(${RED_BOLD}$(node -v)${BLUE_BOLD}) "
            break
        fi

        current_dir=$(dirname -- "${current_dir}")
    done

    echo "${prompt}"
}

function git_prompt() {
    tester=$(git rev-parse --git-dir 2> /dev/null) || return

    ZSH_THEME_GIT_PROMPT_STAGED="${GREEN_BOLD}●"
    ZSH_THEME_GIT_PROMPT_UNSTAGED="${RED_BOLD}●"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="${WHITE_BOLD}●"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    local index=$(git status --porcelain 2> /dev/null)
    local prompt=""

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

    ZSH_THEME_GIT_PROMPT_PREFIX=" ${BLUE_BOLD}git:(${RED_BOLD}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="${prompt}${BLUE_BOLD})"

    echo "$(git_prompt_info)"
}

function hostname_prompt() {
    local prompt

    if [[ -n $SSH_CONNECTION ]]; then
        prompt="${RED}ssh:[${WHITE}$(whoami)${WHITE_BOLD}@${WHITE}%M${RED}]"
    else
        prompt="${RED}[${WHITE}%M${RED}]"
    fi

    echo ${prompt}
}

PROMPT='$(hostname_prompt) ${status_prompt} ${cwd}$(git_prompt) $(node_prompt)${RESET}'
