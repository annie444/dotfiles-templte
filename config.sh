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
read -r -p "Enter your git name: " git_name
read -r -p "Enter your git GPG key fingerprint: " git_signingkey

echo -e "  email = \"${git_email}\"\n  name = \"${git_name}\"\n  signingkey = ${git_signingkey}" >>./git/.gitconfig

echo -e "${GREEN}Git configured successfully.${RESET}"
