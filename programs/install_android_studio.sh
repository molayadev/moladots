#!/usr/bin/env bash
# Base script to install idea community latest version on linux
# check if tput exists

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
    which android-studio &> /dev/null

	if [ $? -ne 0 ]; then
        install_android_studio
    else
        printf "%s\n" "${FG_AQUA}* You already have ${BOLD} Android Studio 🖖 installed. ${RESET}"
		exit 0
	fi
}

install_android_studio() {
	which snap &> /dev/null

	if [ $? -ne 0 ]; then
		printf "%s\n" "${FG_AQUA}* So far we don't support install this without snap" 
	else
		printf "%s\n" "${BOLD}${FG_AQUA}Using snap to manage the installation"
		sudo snap install android-studio --classic
		echo "${RESET}"
	fi
}

printf "%s\n" "Preparing ${BOLD}Android Studio${RESET}"
status_check
printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Android Studio${RESET}"