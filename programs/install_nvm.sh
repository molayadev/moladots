#!/usr/bin/env bash
# check if tput exists
if ! command -v tput &> /dev/null; then
    # tput could not be found
    BOLD=""
	RESET=""
	FG_SKYBLUE=""
	FG_AQUA=""
	BG_AQUA=""
	FG_BLACK=""
	FG_ORANGE=""
	UL=""
	RUL=""
else
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
	FG_SKYBLUE=$(tput setaf 106)
	FG_AQUA=$(tput setaf 45)
	BG_AQUA=$(tput setab 45)
	FG_BLACK=$(tput setaf 16)
	FG_ORANGE=$(tput setaf 202)
	UL=$(tput smul)
	RUL=$(tput rmul)
fi

goodbye() {
	printf "\a\n\n%s\n" "${BOLD}Thanks for using moladots 🖖.${RESET}"
	printf "%s\n" "${BOLD}Report Bugs 🐛 @ ${UL}https://github.com/molayadev/moladots/issues${RUL}${RESET}"
}

install_apt() {
  which $1 2>&1 &> /dev/null
  IS_INSTALLED=$?
  if [ IS_INSTALLED -ne 0 ]; then
    echo "** Installing: ${1}... 👇"
    sudo apt install -y $1
    echo  "** Successfully installed $1 👍 "
  else
    echo "** ¡Already Installed ${1}! 👌 "
  fi
}

install_nvm() {

  if [ -d "${HOME}/.nvm" ]; then
    printf "%s\n" "${BOLD}Already installed nvm${RESET}"
  else
    printf "%s\n" "${BOLD}${FG_SKYBLUE}Installing nvm${RESET}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    printf "%s\n" "${BOLD}Setting up env${RESET}"
    add_env
  fi
  nvm version
}

add_env() {
	#[[ "$NVM_DIR" ]] && return
	# export environment variables
	printf "\n%s\n" "${FG_AQUA}Exporting env variables NVM ... ${RESET}"
    NVM_DIR="${HOME}/.nvm"
	current_shell=$(basename "$SHELL")
	if [ $current_shell = "zsh" ]; then
		echo "export NVM_DIR=$([ -z ${XDG_CONFIG_HOME-} ] && printf %s '${HOME}/.nvm' || printf %s ${XDG_CONFIG_HOME}/nvm)" >> "$HOME"/.zshrc
		echo "[ -s '${NVM_DIR}/nvm.sh' ] && \. '${NVM_DIR}/nvm.sh' # This loads nvm" >> "$HOME"/.zshrc
	elif [ $current_shell = "bash" ]; then
		# assume we have a fallback to bash
		echo "export NVM_DIR=$([ -z ${XDG_CONFIG_HOME-} ] && printf %s '${HOME}/.nvm' || printf %s ${XDG_CONFIG_HOME}/nvm)" >> "$HOME"/.bashrc
		echo "[ -s '${NVM_DIR}/nvm.sh' ] && \. '${NVM_DIR}/nvm.sh' # This loads nvm" >> "$HOME"/.bashrc
	else
		echo "Couldn't export ${BOLD}NVM_DIR${RESET}"
		echo "Consider exporting them manually."
		exit 1
	fi
	source "${HOME}/.zshrc"
	source "${HOME}/.bashrc"
	printf "\n%s" "Configuration for SHELL: ${BOLD}$current_shell${RESET} has been updated."
}


node_apps() {
    printf "%s\t\n" "[X] ${FG_AQUA} Now, lets install node utils **** ${RESET}" 
    printf "\n\t%s" "[${BOLD}n/N${RESET}] Install Node Latest"
    printf "\n\t%s" "[${BOLD}a/A${RESET}] Install Angular/Cli Latest"
    printf "\n\t%s" "[${BOLD}i/I${RESET}] Install Ionic/Cli (Latest)"
    printf "\n\t%s\n" "[${BOLD}q/Q${RESET}] Later..."
    read -p "What do you want me to do ? [${BOLD}0${RESET}]: " -r USER_INPUT
    # Default choice is [1], See Parameter Expansion
    USER_INPUT=${USER_INPUT:0}
    case $USER_INPUT in
        [n/N]* ) install_node_latest;;
        [a/A]* ) install_angular;;
        [i/I]* ) install_ionic;;
        [q/Q]* ) goodbye 
                    exit;;
        * )     printf "\n%s\n\t" "[❌]Invalid Input 🙄, Try Again";;
    esac
    
}

install_ionic() {
    which npm &> /dev/null
    
    if [ $? -ne 0 ]; then
        install_node_latest
    fi
    which ng &> /dev/null
    if [ $? -ne 0 ]; then
        printf "%s\n" "Installing ${BOLD} Ionic/Cli (latest)${RESET} ****" 
        npm i -g @ionic/cli
    else
        printf "%s\n" "${FG_SKYBLUE}Already installed ${BOLD}Ionic/Cli${RESET}"
    fi
    printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Ionic/Cli${RESET}"
    ionic version
}

install_angular() {
    which npm &> /dev/null
    
    if [ $? -ne 0 ]; then
        install_node_latest
    fi
    which ng &> /dev/null
    if [ $? -ne 0 ]; then
        printf "%s\n" "Installing ${BOLD} Angular/Cli (latest)${RESET} ****" 
        npm i -g @angular/cli
    else
        printf "%s\n" "${FG_SKYBLUE}Already installed ${BOLD}Angular/Cli${RESET}"
    fi
    printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Angular/Cli${RESET}"
    ng version
}

install_node_latest() {
    which node &> /dev/null
    
     if [ $? -ne 0 ]; then
        printf "%s\n" "Installing ${BOLD} Node (latest)${RESET} ****" 
        nvm install stable
        printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Node${RESET}"
    else
        printf "%s\n" "${FG_SKYBLUE}Already installed ${BOLD}Node${RESET}"
    fi
}

install_nvm
printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] NVM${RESET}"

case $1 in
    [a/A]* ) install_angular;;
    [i/I]* ) install_ionic;;
    [n/N]* ) install_node_latest;;
    * ) node_apps;;
esac