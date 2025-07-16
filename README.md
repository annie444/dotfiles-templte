# dotfiles-templte

Basic template repository for managing your dotfiles with GNU Stow

## Getting started

This is a template repostitory, so you can easily use this repo to make your own dotfiles repo. If you do use this template, there's some healpers to aid in getting started.

1. **Configure git**: Use the `./config.sh` script to set your _name_, _email_, and _gpg key_ for use with git.
2. **Setting up SSH**: The SSH config at `./ssh/.ssh/config` is very minimal. You're expected to add hosts on your own.
3. **Generating a GitHub SSH key**: This repo expects there to be an SSH key at `~/.ssh/github_id_ed25519` used for git authentication.

## Setting up a new host

The `./bootstrap.sh` script is used for copying the SSH keys an GPG keys to a remote host. You'll want to use this script first before continuing to setup a new host.

The `./install.sh` script is used to install the dotfiles on a new host. This script mainly ensures all the expected files are present and sets the paths to executables that are different from host to host.
