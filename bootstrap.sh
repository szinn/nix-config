#! /usr/bin/env bash
#
# Usage: bootstrap.sh
#

set -o errexit
set -o nounset
set -o pipefail

readonly yellow='\e[0;33m'
readonly green='\e[0;32m'
readonly red='\e[0;31m'
readonly reset='\e[0m'

log() {
  printf "${yellow}>> %s${reset}\n" "${*}"
}

success() {
  printf "${green} %s${reset}\n" "${*}"
}

error() {
  printf "${red}!!! %s${reset}\n" "${*}" 1>&2
}

cleanup() {
  result=$?
  rm -rf "${WORK_DIR}"
  exit ${result}
}

isDarwin() {
  [[ $(uname) == "Darwin" ]]
}

trap cleanup EXIT ERR
log "Welcome to the bootstrap script!"

WORK_DIR=$(mktemp -d)
log "Using work directory: ${WORK_DIR}"

if [[ isDarwin ]]; then
  if ! $(xcode-select --print-path &> /dev/null); then
    log "Installing XCode tools..."
    xcode-select --install &> /dev/null
    until $(xcode-select --print-path &> /dev/null); do
      sleep 5;
    done
  fi
  softwareupdate --install-rosetta --agree-to-license
fi

if [[ isDarwin ]]; then
  log "Checking if homebrew is installed..."
  if ! test -f /opt/homebrew/bin/brew; then
    log "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "eval $(/opt/homebrew/bin/brew shellenv)" >>~/.zprofile
  fi
fi

if [[ isDarwin ]]; then
  log "Checking if Nix is installed..."
  if ! command -v nix &>/dev/null; then
    log "Installing Nix..."
    curl -sL -o nix-installer https://install.determinate.systems/nix/nix-installer-aarch64-darwin
    chmod +x nix-installer

    ./nix-installer install macos \
      --logger pretty \
      --extra-conf "sandbox = false" \
      --extra-conf "experimental-features = nix-command flakes" \
      --extra-conf "trusted-users = scotte"
    log "Validating Nix installation..."
    ./nix-installer self-test --logger pretty
    rm ./nix-installer

    success "Nix installed successfully!"
  fi
fi

# if ! [ -d /nix/var/nix/profiles/per-user/root/channels ]; then
#     sudo mkdir -p /nix/var/nix/profiles/per-user/root/channels
# fi

# log "Checking if nix-index is installed..."
# if ! [ -f ~/.cache/nix-index/files ]; then
#     filename="index-$(uname -m | sed 's/^arm64$/aarch64/')-$(uname | tr A-Z a-z)"
#     mkdir -p ~/.cache/nix-index && cd ~/.cache/nix-index
#     # -N will only download a new version if there is an update.
#     wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
#     ln -f $filename files
# fi

log "Configuring environment..."
set +o nounset
# shellcheck disable=SC1091
if [[ isDarwin ]]; then
    source "/etc/bashrc"
fi
set -o nounset

log "Check if repo is cloned..."
if [[ ! -d ~/.local/nix-config ]]; then
  log "Cloning repo..."
  mkdir -p ~/.local
  git clone https://github.com/szinn/nix-config.git ~/.local/nix-config
fi

log "Activating configuration..."
for i in nix/nix.conf shells zshenv; do
  if [ -f /etc/$i ]; then
    sudo mv /etc/$i /etc/$i.before-nix-darwin
  fi
done

success "Done!"
