main() {
    ZSH_THEMES=~/.oh-my-zsh/themes

    if [ ! -d "$ZSH_THEMES" ]; then
        echo "You do not have Oh My Zsh installed"
        exit
    fi

    umask g-w,o-w

    hash wget >/dev/null 2>&1 || {
        echo "Error: wget is not installed"
        exit 1
    }

    echo "Installing theme"

    wget https://raw.githubusercontent.com/gorzechowski/zsh-theme/master/gorzechowski.zsh-theme -O $ZSH_THEMES/gorzechowski.zsh-theme || {
        echo "Error: download of gorzechowski theme file failed"
        exit 1
    }

    echo 'gorzechowski theme installed!'
}

main
