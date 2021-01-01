#!/usr/bin/env bash
# Base script to install idea community latest version on linux
# check if tput exists

IDEACOM_HOME=${IDEACOM_HOME:-/opt/ideacom}
IDEACOM_ALIAS=$IDEACOM_HOME/bin/idea.sh
if ! command -v tput &> /dev/null; then
    # tput could not be found
    BOLD=""
	RESET=""
	FG_SKYBLUE=""
	FG_ORANGE=""
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

status_check() {
	if [ -d "${IDEACOM_HOME}" ]; then
		printf "%s\n" "${FG_AQUA}* You already have ${BOLD} ideacom 🖖 installed. ${RESET}"
		printf "%s\n" "${FG_AQUA}* You'll need to remove ${BOLD}'${IDEACOM_HOME}' if you want to reinstall.${RESET}"
        set_alias
		exit 0
    else
        install_ideacom
	fi
}

install_ideacom() {
	which snap &> /dev/null

	if [ $? -ne 0 ]; then
		printf "\n\t%s\n" "You'll install in '$IDEACOM_HOME'"
		sudo mkdir $IDEACOM_HOME
		printf "%s\n" "Installing ${BOLD}IntelliJ Community${RESET}" 
		sudo curl -L "https://download.jetbrains.com/product?code=IC&latest&distribution=linux" | sudo tar xvz -C /opt/ideacom --strip 1 
	else
		printf "%s\n" "${BOLD}${FG_AQUA}Using snap to manage the installation"
		sudo snap install intellij-idea-community --classic
		echo "${RESET}"
		IDEACOM_HOME=/snap
		IDEACOM_ALIAS=/snap/bin/intellij-idea-community
	fi
}

set_alias(){
	if alias idea > /dev/null 2>&1; then
		printf "\n%s\n" "${FG_AQUA}${BOLD}[✔️ ] idea is already aliased${RESET}"
		return
	fi

	if [ -f "$HOME"/.bash_aliases ]; then
		echo "alias idea='${IDEACOM_ALIAS}'" >> "$HOME"/.bash_aliases
		source "$HOME"/.bash_aliases
	elif [ "$(basename $SHELL)" = "zsh" ]; then
		echo "alias idea='${IDEACOM_ALIAS}'" >> "$HOME"/.zshrc
		source "$HOME"/.zshrc
	elif [ "$(basename $SHELL)" = "bash" ]; then
		echo "alias idea='${IDEACOM_ALIAS}'" >> "$HOME"/.bashrc
		source "$HOME"/.bashrc
	else
		echo "Couldn't set alias for moladots: ${BOLD}${IDEACOM_HOME}/bin/idea.s${RESET}"
		echo "Consider adding it manually".
		exit 1
	fi
	echo "${FG_SKYBLUE}${BOLD}[✔️ ] Set alias for idea${RESET}"
}i

printf "%s\n" "Preparing ${BOLD}IntelliJ Community${RESET}"
status_check
set_alias
printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Installed IntelliJ Community${RESET}"
