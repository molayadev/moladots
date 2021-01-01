#!/usr/bin/env bash

# (.dot)file (man)ager

IFS=$'\n'

VERSION="v0.1.0"



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
	FG_ORANGE=$(tput setaf 178)
	UL=$(tput smul)
	RUL=$(tput rmul)
fi


logo() {
	# print moladots logo
	printf "${BOLD}${FG_SKYBLUE}%s\n" ""
  	echo "███╗   ███╗ ██████╗ ██╗      █████╗ ██╗   ██╗ █████╗ ██████╗ ███████╗██╗   ██╗";
 	echo "████╗ ████║██╔═══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██║   ██║";
  	echo "██╔████╔██║██║   ██║██║     ███████║ ╚████╔╝ ███████║██║  ██║█████╗  ██║   ██║";
	echo "██║╚██╔╝██║██║   ██║██║     ██╔══██║  ╚██╔╝  ██╔══██║██║  ██║██╔══╝  ╚██╗ ██╔╝";
	echo "██║ ╚═╝ ██║╚██████╔╝███████╗██║  ██║   ██║   ██║  ██║██████╔╝███████╗ ╚████╔╝ ";
	echo "╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝  ╚═══╝  ";
	echo "                                                                              	";
	printf "${RESET}\n%s" ""
}

## install apt dependencies
install_apt() {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "** Installing: ${1}... 👇"
    sudo apt install -y $1
    echo  "** Successfully installed $1 👍 "
  else
    echo "** ¡Already Installed ${1}! 👌 "
  fi
}

git_safe() {
	# check if git exists
	install_apt git git-flow
	if ! command -v git &> /dev/null; then
		printf "%s\n\n" "${BOLD}${FG_SKYBLUE} dotfiles-mola ${RESET}"
		echo "Can't work without Git 😞"
		exit 1
	fi
} 


# function called by trap
catch_ctrl+c() {
    goodbye
    exit
}

trap 'catch_ctrl+c' SIGINT

repo_check(){
	# check if dotfile repo is present inside MOLADOTS_DEST

	MOLADOTS_REPO_NAME=$(basename "${MOLADOTS_REPO}")
	# all paths are relative to HOME
	if [[ -d ${MOLADOTS_DEST} ]]; then
	    printf "\n%s\n" "Found ${BOLD}${MOLADOTS_REPO_NAME}${RESET} as dotfile repo in ${BOLD}${MOLADOTS_DEST}/${RESET}"
	else
	    printf "\n\n%s\n" "[❌] ${BOLD}${MOLADOTS_REPO_NAME}${RESET} not present inside path ${BOLD}${MOLADOTS_DEST}${RESET}"
		read -p "Should I clone it ? [Y/n]: " -n 1 -r USER_INPUT
		USER_INPUT=${USER_INPUT:-y}
		case $USER_INPUT in
			[y/Y]* ) clone_dotrepo "$MOLADOTS_DEST" "$MOLADOTS_REPO" ;;
			[n/N]* ) printf "\n%s" "${BOLD}${MOLADOTS_REPO_NAME}${RESET} not found";;
			* )     printf "\n%s\n" "[❌] Invalid Input 🙄, Try Again";;
		esac
	fi
}

find_dotfiles() {
	printf "\n"
	# while read -r value; do
	#     dotfiles+=($value)
	# done < <( find "${HOME}" -maxdepth 1 -name ".*" -type f )
	readarray -t dotfiles < <( find "${MOLADOTS_DEST}/programs" -maxdepth 1 -name ".*" -type f )
	printf '%s\n' "${dotfiles[@]}"
}

add_env() {
	[[ "$MOLADOTS_DEST" && "$MOLADOTS_REPO" ]] && return
	# export environment variables
	printf "\n%s\n" "Exporting env variables MOLADOTS_DEST & MOLADOTS_REPO ..."

	current_shell=$(basename "$SHELL")
	if [[ $current_shell == "zsh" ]]; then
		echo "export MOLADOTS_REPO=$1 MOLADOTS_DEST=$2" >> "$HOME"/.zshrc
	elif [[ $current_shell == "bash" ]]; then
		# assume we have a fallback to bash
		echo "export MOLADOTS_REPO=$1 MOLADOTS_DEST=$2" >> "$HOME"/.bashrc
	else
		echo "Couldn't export ${BOLD}MOLADOTS_REPO=$1${RESET} and ${BOLD}MOLADOTS_DEST=$2${RESET}"
		echo "Consider exporting them manually."
		exit 1
	fi
	printf "\n%s" "Configuration for SHELL: ${BOLD}$current_shell${RESET} has been updated."
}

goodbye() {
	#printf "\a\n\n%s\n" "${BOLD}Thanks for using moladots 🖖.${RESET}"
	printf "%s\n" "for more updates.${RESET}"
	printf "%s\n" "${BOLD}Report Bugs 🐛 @ ${UL}https://github.com/molayadev/moladots/issues${RUL}${RESET}"
	cowsay -f molayadev "${FG_AQUA} Thanks for using moladots 🖖. ${RESET}"
}

dot_pull() {
	# pull changes (if any) from the remote repo
	printf "\n%s\n" "${BOLD}Pulling dotfiles ...${RESET}"
	dot_repo="${MOLADOTS_DEST}"
	printf "\n%s\n" "Pulling changes in $dot_repo"
	GET_BRANCH=$(git remote show origin | awk '/HEAD/ {print $3}')
	printf "\n%s\n" "Pulling from ${BOLD}${GET_BRANCH}" 
	git -C "$dot_repo" pull origin "${GET_BRANCH}"
	exit 0;
}

diff_check() {

	[[ -z $1 ]] && local file_arr

	# dotfiles in repository
	readarray -t dotfiles_repo < <( find "${MOLADOTS_DEST}" -maxdepth 1 -name ".*" -type f )

	# check length here ?
	for i in "diff_check${!dotfiles_repo[@]}"
	do
		dotfile_name=$(basename "${dotfiles_repo[$i]}")
		# compare the HOME version of dotfile to that of repo
		diff=$(diff -u --suppress-common-lines --color=always "${dotfiles_repo[$i]}" "${MOLADOTS_DEST}/programs")
		if [[ $diff != "" ]]; then
			if [[ $1 == "show" ]]; then
				printf "\n\n%s" "Running diff between ${BOLD} ${FG_ORANGE}${MOLADOTS_DEST}${RESET} and "
				printf "%s\n" "${BOLD}${FG_ORANGE}${dotfiles_repo[$i]}${RESET}"
				printf "%s\n\n" "$diff"
			fi
			file_arr+=("${dotfile_name}")
		fi
	done

	[ ${#file_arr} == 0 ] && printf "\n%s\n" "${BOLD}No Changes in dotfiles.${RESET}";return
}

show_diff_check() {
	diff_check "show"
}

dot_push() {
	diff_check
	if [[ ${#file_arr} != 0 ]]; then
		printf "\n%s\n" "${BOLD}Following dotfiles changed${RESET}"
		for file in "${file_arr[@]}"; do
			echo "$file"
			cp "${HOME}/$file" "${MOLADOTS_DEST}"
		done

		dot_repo="${MOLADOTS_DEST})"
		git -C "$dot_repo" add -A

		echo "${BOLD}Enter Commit Message (Ctrl + d to save): ${RESET}"
		commit=$(</dev/stdin)
		printf "\n"
		git -C "$dot_repo" commit -m "$commit"

		# Run Git Push
		git -C "$dot_repo" push
	else
		return
	fi
}

clone_dotrepo (){
	# clone the repo in the destination directory
	MOLADOTS_DEST=$1
	MOLADOTS_REPO=$2
	
	if git -C "${MOLADOTS_DEST}" clone "${MOLADOTS_REPO}"; then
		if [[ $MOLADOTS_REPO && $MOLADOTS_DEST ]]; then
			add_env "$MOLADOTS_REPO" "$MOLADOTS_DEST"
		fi
		printf "\n%s" "[✔️ ] moladots successfully configured"
	else
		# invalid arguments to exit, Repository Not Found
		printf "\n%s" "[❌] $MOLADOTS_REPO Unavailable. Exiting !"
		exit 1
	fi
}

initial_setup() {
	printf "\n\n%s\n" "First time use 🔥, Set Up ${BOLD}moladots${RESET}"
	printf "%s\n" "...................................."
	read -p "➤ Enter dotfiles repository URL : " -r MOLADOTS_REPO
	read -p "➤ Where should I clone ${BOLD}$(basename "${MOLADOTS_REPO}")${RESET} (${HOME}/..): " -r MOLADOTS_DEST
	MOLADOTS_DEST=${MOLADOTS_DEST:-$HOME}

	if [[ -d "$MOLADOTS_DEST" ]]; then
		printf "\n%s\r\n" "${BOLD}Calling 📞 Git ... ${RESET}"
		clone_dotrepo "$MOLADOTS_DEST" "$MOLADOTS_REPO"
		printf "\n%s\n" "Open a new terminal or source your shell config"
	else
		printf "\n%s" "[❌]${BOLD}$MOLADOTS_DEST${RESET} Not a Valid directory"
		exit 1
	fi
}

manage() {
	while :
	do
	    printf "\n%s" "[${BOLD}0${RESET}] Install Development Tools"
		printf "\n%s" "[${BOLD}1${RESET}] Show diff"
		printf "\n%s" "[${BOLD}2${RESET}] Push changed dotfiles"
		printf "\n%s" "[${BOLD}3${RESET}] Pull latest changes"
		printf "\n%s" "[${BOLD}4${RESET}] List all dotfiles"
		printf "\n%s\n" "[${BOLD}q/Q${RESET}] Quit Session"
		read -p "What do you want me to do ? [${BOLD}0${RESET}]: " -r USER_INPUT
		# Default choice is [1], See Parameter Expansion
		USER_INPUT=${USER_INPUT:0}
		case $USER_INPUT in
			[0]* ) devtools_menu;;
			[1]* ) show_diff_check;;
			[2]* ) dot_push;;
			[3]* ) dot_pull;;
			[4]* ) find_dotfiles;;
			[q/Q]* ) goodbye 
					 exit;;
			* )     printf "\n%s\n" "[❌]Invalid Input 🙄, Try Again";;
		esac
	done
}

devtools_menu() {
	while :
	do
		printf "\n\t%s" "[X] ******* ${FG_AQUA}Development Tools${RESET} ******"
	    #printf "\n\t%s" "[${BOLD}b/B${RESET}] [All ${FG_ORANGE}BACK${RESET}] Install Backend Dev Tools"
		#printf "\n\t%s" "[${BOLD}f/F${RESET}] [All ${FG_SKYBLUE}FRONT${RESET}] Install Frontend Dev Tools"
		#printf "\n\t%s" "[${BOLD}d/D${RESET}] [All ${FG_AQUA}DEV${RESET}] Install Common Dev Tools"
		printf "\n\t%s" "[${BOLD}s/S${RESET}] [${FG_ORANGE}BACK${RESET}] Install SDKMAN"
		printf "\n\t%s" "[${BOLD}j/J${RESET}] [${FG_ORANGE}BACK${RESET}] Install Java JDK"
		printf "\n\t%s" "[${BOLD}i/I${RESET}] [${FG_ORANGE}BACK${RESET}] Install IntelliJ Community"
	    printf "\n\t%s" "[${BOLD}m/M${RESET}] [${FG_ORANGE}BACK${RESET}] Install Maven"
		printf "\n\t%s" "[${BOLD}a/A${RESET}] [${FG_ORANGE}BACK${RESET}] Install Android Studio"
		printf "\n\t%s" "[${BOLD}v/V${RESET}] [${FG_SKYBLUE}FRONT${RESET}] Install VsCode"
		printf "\n\t%s" "[${BOLD}n/N${RESET}] [${FG_SKYBLUE}FRONT${RESET}] Install NVM (Stable Node)"
		#printf "\n\t%s" "[${BOLD}e/E${RESET}] [${FG_AQUA}DEV${RESET}] Install STS Eclipse"
		printf "\n\t%s" "[${BOLD}z/Z${RESET}] [${FG_AQUA}DEV${RESET}] Install Shell Zsh"
		printf "\n\t%s" "[${BOLD}p/P${RESET}] [${FG_AQUA}DEV${RESET}] Install Postman"
		printf "\n\t%s" "[${BOLD}0${RESET}] [${FG_SKYBLUE}FRONT${RESET}] Install Angular CLI (*NVM)"
		printf "\n\t%s" "[${BOLD}1${RESET}] [${FG_SKYBLUE}FRONT${RESET}] Install Ionic CLI (*NVM)"
		printf "\n%s\n" "[${BOLD}q/Q${RESET}] Quit Session"
		read -p "What do you want me to install ? [${BOLD}0${RESET}]: " -r USER_INPUT
		# Default choice is [1], See Parameter Expansion
		USER_INPUT=${USER_INPUT:b}
		case $USER_INPUT in
			[b/B]* ) ;;
			[f/F]* ) ;;
			[d/D]* ) ;;
			[s/S]* ) bash "${MOLADOTS_DEST}/programs/install_sdkman.sh";;
			[j/J]* ) bash "${MOLADOTS_DEST}/programs/install_jdk.sh";;
			[i/I]* ) bash "${MOLADOTS_DEST}/programs/install_ideacom.sh";;
			[m/M]* ) bash "${MOLADOTS_DEST}/programs/install_maven.sh";;
			[a/A]* ) bash "${MOLADOTS_DEST}/programs/install_android_studio.sh";;
			[v/V]* ) bash "${MOLADOTS_DEST}/programs/install_code.sh";;
			[n/N]* ) bash "${MOLADOTS_DEST}/programs/install_nvm.sh" n;;
			[z/Z]* ) bash "${MOLADOTS_DEST}/programs/install_zsh.sh";;
			[p/P]* ) bash "${MOLADOTS_DEST}/programs/install_postman.sh";;
			[0]* ) bash "${MOLADOTS_DEST}/programs/install_nvm.sh" a;;
			[1]* ) bash "${MOLADOTS_DEST}/programs/install_nvm.sh" i;;
			[q/Q]* ) goodbye 
					 exit;;
			* )     printf "\n%s\n" "[❌]Invalid Input 🙄, Try Again";;
		esac
	done
}


intro() {
	BOSS_NAME=$LOGNAME
	printf "\n\a%s" "Hi ${BOLD}${FG_ORANGE}$BOSS_NAME${RESET} 👋"
	logo
}

init_check() {
	# Check wether its a first time use or not
	if [[ -z ${MOLADOTS_REPO} && -z ${MOLADOTS_DEST} ]]; then
	    sudo apt update
		echo "** Adding tput command 🎨"
		install_apt ncurses-bin

		echo "** Adding cowsay command 🐄"
		install_apt cowsay
		sudo cp ${MOLADOTS_DEST}/assets/cows/* /usr/share/cowsay/cows/

		# Trying install git before use it.
		git_safe
		initial_setup
		goodbye
	else
		repo_check
	    manage
	fi
}


if [[ $1 == "version" || $1 == "--version" || $1 == "-v" ]]; then
	if [[ -d "$HOME/moladots" ]]; then
		latest_tag=$(git -C "$HOME/moladots" describe --tags --abbrev=0)
		latest_tag_push=$(git -C "$HOME/moladots" log -1 --format=%ai "${latest_tag}")
		echo "${BOLD}moladots ${latest_tag} ${RESET}"
		echo "Released on: ${BOLD}${latest_tag_push}${RESET}"
	else
		echo "${BOLD}moladots ${VERSION}${RESET}"
	fi
	exit
fi

intro
init_check
