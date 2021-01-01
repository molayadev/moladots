#!/usr/bin/env bash
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

install_sdkman() {

  if [ -d "${HOME}/.sdkman" ]; then
    source "${HOME}/.sdkman/bin/sdkman-init.sh"
    printf "%s\n" "${BOLD}Already installed sdkman${RESET}"
  else
    bash "${MOLADOTS_DEST}/programs/install_sdkman.sh"
    source "${HOME}/.sdkman/bin/sdkman-init.sh"
  fi
}

install_mvn_latest() {
    which mvn &> /dev/null
    
     if [ $? -ne 0 ]; then
        printf "%s\n" "Installing ${BOLD} MAVEN (latest)${RESET} ****" 
        sdk install maven -y
        printf "%s\n" "${BOLD}${FG_SKYBLUE}Successfully Maven installed${RESET}" 
    else
        printf "%s\n" "${FG_AQUA}* You already have ${BOLD} MAVEN 🖖 installed. ${RESET}"
		    exit 0
    fi
}

install_sdkman
install_mvn_latest

cowsay -f molayadev "${FG_SKYBLUE}To install another mvn version use: ${BOLD}sdk list maven${RESET}"
printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Maven${RESET}"