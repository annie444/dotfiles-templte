#!/usr/bin/env bash

set -euo pipefail

# ANSI color codes for output

export GREEN='\033[32m'
export CYAN='\033[36m'
export RESET='\033[0m'

# Main script

## Setup git

echo -e "${CYAN}Configuring git...${RESET}"
echo "[user]" >>./git/.gitconfig

read -r -p "Enter your git email: " git_email
echo -e "  email = \"${git_email}\"" >>./git/.gitconfig

read -r -p "Enter your git name: " git_name
echo -e "  name = \"${git_name}\"" >>./git/.gitconfig

read -r -p "Enter your git GPG signing key fingerprint: " git_signingkey
echo -e "  signingkey = ${git_signingkey}" >>./git/.gitconfig

echo -e "${GREEN}Git configured successfully.${RESET}"
