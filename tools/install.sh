#!/bin/env sh

# Script for installing moladots
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/molayadev/moladots/master/tools/install.sh)"
# or wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/molayadev/moladots/master/tools/install.sh)"
# or httpie:
#   sh -c "$(http --download https://raw.githubusercontent.com/Bhupesh-v/moladots/master/tools/install.sh)"
# 
# As an alternative, you can first download the install script and run it afterwards:
#   wget https://raw.githubusercontent.com/molayadev/moladots/master/tools/install.sh
#   sh install.sh
#
# Respects the following environment variables:
#   MOLADOTS  - path to the moladots repository folder (default: $HOME/moladots)
#   REPO    - name of the GitHub repo to install from (default: molayadev/moladots)
#   BRANCH  - the main branch of upstream moladots repo (default: master)
#   REMOTE  - full remote URL of the git repo to install (default: GitHub via HTTPS)


MOLADOTS=${MOLADOTS:-$HOME/moladots}
REPO=${REPO:-molayadev/moladots}
BRANCH=${BRANCH:-master}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}

add_env() {
	[[ "$MOLADOTS_DEST" && "$MOLADOTS_REPO" ]] && return
	# export environment variables
	printf "\n%s\n" "Exporting env variables MOLADOTS_DEST & MOLADOTS_REPO ..."

	current_shell=$(basename "$SHELL")
	if [ $current_shell = "zsh" ]; then
		echo "export MOLADOTS_REPO=${1} MOLADOTS_DEST=${2}" >> "$HOME"/.zshrc
		
	elif [ $current_shell = "bash" ]; then
		# assume we have a fallback to bash
		echo "export MOLADOTS_REPO=${1} MOLADOTS_DEST=${2}" >> "$HOME"/.bashrc
	else
		echo "Couldn't export ${BOLD}MOLADOTS_REPO=$1${RESET} and ${BOLD}MOLADOTS_DEST=$2${RESET}"
		echo "Consider exporting them manually."
		exit 1
	fi
	source "${HOME}/.zshrc"
	source "${HOME}/.bashrc"
	printf "\n%s" "Configuration for SHELL: ${BOLD}$current_shell${RESET} has been updated."
}

## install apt dependencies
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

echo "** Adding tput command 🎨"
install_apt ncurses-bin

echo "** Adding cowsay command 🐄"
install_apt cowsay

git_safe() {
	# check if git exists
	install_apt git git-flow
} 

# Trying install git before use it.
git_safe
git --version 2>&1 >/dev/null # improvement by tripleee
GIT_IS_AVAILABLE=$?
# ...
if [ $GIT_IS_AVAILABLE -ne 0 ]; then
	printf "%s\n\n" "${BOLD}${FG_SKYBLUE} moladots ${RESET}"
	echo "Can't work without Git 😞"
	exit 1
fi

status_check() {
	if [ -d "$MOLADOTS" ]; then
		printf "\n\t%s\n" "You already have ${BOLD}moladots${RESET} 🖖 installed."
		printf "\n\t%s\n\n" "You'll need to remove '$MOLADOTS' if you want to reinstall."
		exit 0
	fi
}

clone_moladots() {
	if ! command -v git > /dev/null 2>&1; then
		printf "\n%s\n" "${BOLD}Can't work without Git 😞${RESET}"
		exit 1
	else
		# Clone repository to /home/username/moladots
		# git clone $REMOTE --branch $BRANCH --single-branch $HOME
		latest_tag=$(git ls-remote --ref -t --sort='-v:refname' "$REMOTE" | head -n 1)
		# ##*/ retains the part after last /
		git -C "$HOME" clone -b "${latest_tag##*/}" --branch "$BRANCH" --single-branch "$REMOTE"
		#git clone $REMOTE $MOLADOTS
		if [ -d "$MOLADOTS" ]; then
			echo "${BOLD}[✔️ ] Successfully cloned moladots${RESET}"
			# switch to stable version
			git -C "$MOLADOTS" checkout "$latest_tag" -b "$BRANCH"
			MOLADOTS_DEST=$MOLADOTS
			MOLADOTS_REPO=$REMOTE
			add_env "$MOLADOTS_REPO" "$MOLADOTS_DEST"
		else
			echo "${BOLD}[❌] Error cloning moladots${RESET}"
		fi
	fi
}

set_alias(){
	if alias moladots > /dev/null 2>&1; then
		printf "\n%s\n" "${BOLD}[✔️ ] moladots is already aliased${RESET}"
		return
	fi

	if [ -f "$HOME"/.bash_aliases ]; then
		echo "alias moladots='$HOME/moladots/moladots.sh'" >> "$HOME"/.bash_aliases
		source "$HOME"/.bash_aliases
	elif [ "$(basename $SHELL)" = "zsh" ]; then
		echo "alias moladots='$HOME/moladots/moladots.sh'" >> "$HOME"/.zshrc
		source "$HOME"/.zshrc
	elif [ "$(basename $SHELL)" = "bash" ]; then
		echo "alias moladots='$HOME/moladots/moladots.sh'" >> "$HOME"/.bashrc
		source "$HOME"/.bashrc
	else
		echo "Couldn't set alias for moladots: ${BOLD}$HOME/moladots/moladots.sh${RESET}"
		echo "Consider adding it manually".
		exit 1
	fi
	echo "${BOLD}[✔️ ] Set alias for moladots${RESET}"
}

main () {
	status_check
	clone_moladots
	set_alias
    sudo cp ${MOLADOTS}/assets/cows/* /usr/share/cowsay/cows/
	# print moladots logo
	cowsay -f molayadev "MOLADOTS is now installed"
	printf "\t\t\t%s\n" ".... is now installed"
	printf "\n%s" "Run \`moladots version\` to check latest version."
	printf "\n%s\n" "Run \`moladots\` to configure first time setup."

}

# check if tput exists
if ! command -v tput > /dev/null 2>&1; then
    # tput could not be found :(
    BOLD=""
	RESET=""
else
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
fi

main
