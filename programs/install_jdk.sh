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

goodbye() {
	printf "\a\n\n%s\n" "${BOLD}Thanks for using moladots 🖖.${RESET}"
	printf "%s\n" "${BOLD}Report Bugs 🐛 @ ${UL}https://github.com/molayadev/moladots/issues${RUL}${RESET}"
}

install_sdkman() {

  if [ -d "${HOME}/.sdkman" ]; then
    source "${HOME}/.sdkman/bin/sdkman-init.sh"
    printf "%s\n" "${BOLD}Already installed sdkman${RESET}"
  else
    bash "${MOLADOTS_DEST}/programs/install_sdkman.sh"
    source "${HOME}/.sdkman/bin/sdkman-init.sh"
  fi
}

java_version() {
    printf "%s\n" "Now, lets install JDK****" 
    printf "\n%s" "[${BOLD}0${RESET}] Install JDK 8"
    printf "\n%s" "[${BOLD}1${RESET}] Install JDK 11"
    printf "\n%s\n" "[${BOLD}q/Q${RESET}] Later..."
    read -p "What do you want me to do ? [${BOLD}0${RESET}]: " -r USER_INPUT
    # Default choice is [1], See Parameter Expansion
    USER_INPUT=${USER_INPUT:0}
    case $USER_INPUT in
        [0]* ) install_java8;;
        [1]* ) install_java11;;
        [q/Q]* ) goodbye 
                    exit;;
        * )     printf "\n%s\n" "[❌]Invalid Input 🙄, Try Again";;
    esac
    
}

install_java8() {
    JAVA_VERSION=$(sdk list java | awk ' /[8].*'open-adpt'/ {print $8}')
    
    if [[ $(sdk list java | awk ' /[8].*'open-adpt'/ {print $8}') == *"installed"* ]];  then
        printf "%s\n" "${FG_AQUA}* You already have ${BOLD} JDK 8 🖖 installed. ${RESET}"
    else
        printf "%s\n" "Java version ${BOLD} ${JAVA_VERSION}${RESET} ****" 
        sdk install java $JAVA_VERSION -Y
        printf "%s\n" "${BOLD}${FG_SKYBLUE}Successfully installed JDK 8${RESET}"
    fi
}

install_java11() {
    JAVA_VERSION=$(sdk list java | awk ' /[11].*'open-adpt'/ {print $8}')
    
    if [[ $JAVA_VERSION == *"installed"* ]];  then
        printf "%s\n" "${FG_AQUA}* You already have ${BOLD} JDK 11 🖖 installed. ${RESET}"
    else
        printf "%s\n" "Java version ${BOLD} ${JAVA_VERSION}${RESET} ****" 
        sdk install java $JAVA_VERSION -y
        printf "%s\n" "${BOLD}${FG_SKYBLUE}Successfully installed JDK 11${RESET}"
    fi
    
}
echo "Selected ${1}"
install_sdkman
case $1 in
    [8]* ) install_java8;;
    [11]* ) install_java11;;
    * ) java_version;;
esac

cowsay -f molayadev "${FG_SKYBLUE}To install another jdk version use: ${BOLD}sdk list java${RESET}"
printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] JDK${RESET}"