#!/usr/bin/env bash
# ~/.gitconfig
# [gpg]
#   program = "/usr/bin/gpg2"
#
# ~/.gnupg/gpg-agent.conf
# pinentry-program /usr/bin/pinentry-curses

set -euo pipefail

# ANSI color codes for output

export BOLD_RED='\033[1;31m'
export GREEN='\033[32m'
export CYAN='\033[36m'
export RESET='\033[0m'

# Utility functions

check_file() {
  local file="$1"
  if [[ ! -f "${file}" ]]; then
    echo -e "${BOLD_RED}File ${file} does not exist. Please check the path.${RESET}"
    exit 1
  fi
}

remove_files() {
  local files=("$@")
  for file in "${files[@]}"; do
    if [[ -f "${file}" ]]; then
      rm -f "${file}"
    fi
  done
}

# Main script

## Setup GPG environment

echo -e "${CYAN}Importing GPG keys...${RESET}"

check_file "${HOME}/privatekeys.asc"
gpg --import "${HOME}/privatekeys.asc"
check_file "${HOME}/pubkeys.asc"
gpg --import "${HOME}/pubkeys.asc"
gpg -K
gpg -k
check_file "${HOME}/otrust.txt"
gpg --import-ownertrust "${HOME}/otrust.txt"

remove_files \
  "${HOME}/privatekeys.asc" \
  "${HOME}/pubkeys.asc" \
  "${HOME}/otrust.txt"

echo -e "${GREEN}GPG keys imported successfully.${RESET}"

## Setup SSH environment

echo -e "${CYAN}Adding SSH keys...${RESET}"

check_file "${HOME}/.ssh/github_id_ed25519"
check_file "${HOME}/.ssh/github_id_ed25519.pub"

ssh-add "${HOME}/.ssh/github_id_ed25519"

echo -e "${GREEN}SSH keys added successfully.${RESET}"

## Configure paths

echo -e "${CYAN}Configuring GPG...${RESET}"

mkdir -p "${HOME}/dotfiles/gpg/.gnupg"
echo "pinentry-program $(which pinentry-curses)" >>"${HOME}/dotfiles/gpg/.gnupg/gpg-agent.conf"

echo -e "${GREEN}GPG configured successfully.${RESET}"

## Stow dotfiles

echo -e "${CYAN}Applying dotfiles...${RESET}"

cd "${HOME}/dotfiles" || {
  echo -e "${BOLD_RED}Failed to change directory to ~/dotfiles. Please check the path.${RESET}"
  exit 1
}
stow git
stow gpg
stow ssh

echo -e "${GREEN}Dotfiles applied successfully.${RESET}"

echo -e "${GREEN}Setup completed successfully!${RESET}"
