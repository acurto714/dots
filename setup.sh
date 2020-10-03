#!/bin/bash

############################################## UTILS ##############################################
setup_colors() {
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

log_tool_installation() {
    echo "   ${BOLD} * Installing $1 ${RESET}"
}

log_main_step() {
    echo "${BLUE}$1 ...${RESET}"
}

log_success(){
    echo "${GREEN}$1!${RESET}"
}
###################################################################################################

########################################## INSTALL TOOLS ##########################################
install_cross_os_tools() {
    log_tool_installation "oh-my-zsh"
    echo "n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    log_tool_installation "oh-my-zsh plugins"
    # install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

    # install zsh-syntax highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

    # install alias-tips
    git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips
    echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips/alias-tips.plugin.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

    # acurto zsh theme
    # ./${COMMONS}/install_ohmyzsh_acurto_theme.sh
}

install_macos() {
    echo "TBD"
    # brew
    # tmux htop vim python golang
}

install_linux() {
    LINUX_TOOLS="zsh vim htop tmux tig"

    # update aptitude
    apt-get -y update

    # install simple linux tools
    for tool in ${LINUX_TOOLS}; do
        log_tool_installation ${tool}
        apt-get -y install ${tool}
    done

    # apt-get -y install
    # python golang

    apt-get -y update
}

install_os_tools() {
    if [ "$OSTYPE" = "linux-gnu"* ]; then
        install_linux
    elif [ "$OSTYPE" = "darwin"* ]; then
        install_macos
    fi
}
###################################################################################################

############################################## SETUP ##############################################
setup_aliases() {
    git config --global alias.co checkout
    git config --global alias.br branch

    alias master="git checkout master"
    alias develop="git checkout develop"
    alias co="git checkout"
}
###################################################################################################

main() {
    setup_colors

    log_main_step "Installing cross operation system tools"
    install_cross_os_tools

    log_main_step "Installing ${OSTYPE} tools"
    install_os_tools

    log_main_step "Setting up last configs"
    setup_aliases

    log_success "Your dots were succesfully installed"
    zsh
}

main "$@"