local ret_status="%{$fg_bold[green]%}➤ "
local hostname="%{$fg[red]%}[%{$fg[white]%}%M%{$fg[red]%}]"
local cwd

function node_prompt() {
    local node
    local current_dir=$(pwd)

    while [[ "${current_dir}" != "." && "${current_dir}" != "/" ]]
    do
        if [ -f ${current_dir}/package.json ]; then
            node="%{$fg_bold[blue]%}node:(%{$fg[red]%}$(node -v)%{$fg_bold[blue]%})%{$reset_color%} "
            break
        fi

        current_dir=`dirname -- "${current_dir}"`
    done

    echo "${node}"
}

function my_git_prompt() {
    tester=$(git rev-parse --git-dir 2> /dev/null) || return

    ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    INDEX=$(git status --porcelain 2> /dev/null)
    STATUS=""

    # is anything staged?
    if $(echo "$INDEX" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
        STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_STAGED}"
    fi

    # is anything unstaged?
    if $(echo "$INDEX" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
        STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_UNSTAGED}"
    fi

    # is anything untracked?
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
        STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_UNTRACKED}"
    fi

    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX=" ${STATUS}%{$fg_bold[blue]%})%{$reset_color%}"

    echo "$(git_prompt_info)"
}

if [ $UID -eq 0 ]; then
    cwd="%{$fg[red]%}%c%{$reset_color%}"
else
    cwd="%{$fg[cyan]%}%c%{$reset_color%}"
fi

PROMPT='${hostname} ${ret_status} ${cwd}$(my_git_prompt) $(node_prompt)'
