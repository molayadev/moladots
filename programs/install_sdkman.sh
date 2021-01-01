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
	FG_ORANGE=$(tput setaf 178)
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
    printf "%s\n" "${BOLD}Already installed sdkman${RESET}"
    printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] SdkMan${RESET}"
  else
    printf "%s\n" "${BOLD}${FG_SKYBLUE}Installing sdkman${RESET}"
    curl -s "https://get.sdkman.io" | bash
    printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] SdkMan${RESET}"
  fi
  source "${HOME}/.sdkman/bin/sdkman-init.sh"
  sdk version
}

java_version() {
    printf "%s\n" "Now, lets install JDK****" 
    printf "\n%s" "[${BOLD}0${RESET}] Install Java JDK 8"
    printf "\n%s" "[${BOLD}1${RESET}] Install Java JDK 11"
    printf "\n%s" "[${BOLD}m/M${RESET}] Install Maven (Latest)"
    printf "\n%s\n" "[${BOLD}q/Q${RESET}] Later..."
    read -p "What do you want me to do ? [${BOLD}0${RESET}]: " -r USER_INPUT
    # Default choice is [1], See Parameter Expansion
    USER_INPUT=${USER_INPUT:0}
    case $USER_INPUT in
        [0]* ) install_java8;;
        [1]* ) install_java11;;
        [m/M]* ) install_mvn_latest;;
        [q/Q]* ) goodbye 
                    exit;;
        * )     printf "\n%s\n" "[❌]Invalid Input 🙄, Try Again";;
    esac
    
}

install_java8() {
    JAVA_VERSION=$(sdk list java | awk ' /[8].*'open-adpt'/ {print $8}')
    
    if [[ $(sdk list java | awk ' /[8].*'open-adpt'/ {print $8}') == *"installed"* ]];  then
        printf "%s\n" "${FG_SKYBLUE}Already installed ${BOLD}JDK 8${RESET}"
    else
        printf "%s\n" "Java version ${BOLD} ${JAVA_VERSION}${RESET} ****" 
        sdk install java $JAVA_VERSION -Y
    fi
    printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Java JDK 8${RESET}"

}

install_java11() {
    JAVA_VERSION=$(sdk list java | awk ' /[11].*'open-adpt'/ {print $8}')
    
    if [[ $JAVA_VERSION == *"installed"* ]];  then
        printf "%s\n" "${FG_SKYBLUE}Already installed ${BOLD}JDK 11${RESET}"
    else
        printf "%s\n" "Java version ${BOLD} ${JAVA_VERSION}${RESET} ****" 
        sdk install java $JAVA_VERSION -y
    fi
    printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Java JDK 11${RESET}"
}

install_mvn_latest() {
    which mvn &> /dev/null
    
     if [ $? -ne 0 ]; then
        printf "%s\n" "Installing ${BOLD} MAVEN (latest)${RESET} ****" 
        sdk install maven
        printf "%s\n" "${BOLD}${FG_SKYBLUE}[✔️ ] Maven${RESET}"
    else
        printf "%s\n" "${FG_SKYBLUE}Already installed ${BOLD}MAVEN${RESET}"
    fi
}

install_sdkman

case $1 in
    [8]* ) install_java8;;
    [11]* ) install_java11;;
    [m/M]* ) install_mvn_latest;;
    * ) exit 0;;
esac