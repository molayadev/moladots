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



install_apt() {
  which $1 2>&1 &> /dev/null
  if [ $? -ne 0 ]; then
    echo "** Installing: ${1}... 👇"
    sudo apt install -y $1
    echo  "** Successfully installed $1 👍 "
  else
    echo "** ¡Already Installed ${1}! 👌 "
  fi
}

install_zsh() {

  if [ $(which zsh) -ne 0 ]; then
    install_apt zsh git-core
    printf "%s\n" "${BOLD}${FG_SKYBLUE}Installing zsh${RESET}"
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    chsh -s $(which zsh)
  else
    printf "%s\n" "${BOLD}Already installed zsh ${RESET} 👌👌"
  fi
  
}

install_zsh
printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Shell zsh${RESET}"
