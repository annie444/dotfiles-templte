#!/usr/bin/env bash

set -euo pipefail

if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 <remote_host_name>"
  exit 1
fi

REMOTE_HOST="$1"

# ANSI color codes for output

BOLD_RED='\033[1;31m'
GREEN='\033[32m'
CYAN='\033[36m'
RESET='\033[0m'

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

echo -e "${CYAN}Setting up SSH keys...${RESET}"

# Copy over SSH config
scp "${HOME}/.ssh/config" "${REMOTE_HOST}":~/.ssh/config
# Copy over SSH keys
for key in $(find "${HOME}/.ssh" -maxdepth 1 -type f -name 'id_*' -not -name '*pub'); do
  check_file "${key}"
  scp "${key}" "${REMOTE_HOST}":~/.ssh/
done

echo -e "${GREEN}SSH keys copied successfully.${RESET}"

echo -e "${CYAN}Setting up GPG keys...${RESET}"

# Export GPG public keys
gpg -a --export >"${HOME}/pubkeys.asc"
# Export GPG private keys
gpg -a --export-secret-keys >"${HOME}/privatekeys.asc"
# Export GPG trustdb
gpg --export-ownertrust >"${HOME}/otrust.txt"

# Copy the GPG files to the new host
check_file "${HOME}/pubkeys.asc"
scp "${HOME}/pubkeys.asc" "${REMOTE_HOST}":~/pubkeys.asc
check_file "${HOME}/privatekeys.asc"
scp "${HOME}/privatekeys.asc" "${REMOTE_HOST}":~/privatekeys.asc
check_file "${HOME}/otrust.txt"
scp "${HOME}/otrust.txt" "${REMOTE_HOST}":~/otrust.txt

# Clean up
remove_files \
  "${HOME}/pubkeys.asc" \
  "${HOME}/privatekeys.asc" \
  "${HOME}/otrust.txt"

echo -e "${GREEN}GPG keys exported and copied successfully.${RESET}"
