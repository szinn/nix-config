#!/usr/bin/env bash

set -euo pipefail

DISK=sda
SWAPSIZE="8G"

export ZFS_POOL="rpool"
export ZFS_LOCAL="${ZFS_POOL}/local"
export ZFS_DS_ROOT="${ZFS_LOCAL}/root"
export ZFS_DS_NIX="${ZFS_LOCAL}/nix"

export ZFS_SAFE="${ZFS_POOL}/safe"
export ZFS_DS_HOME="${ZFS_SAFE}/home"
export ZFS_DS_PERSIST="${ZFS_SAFE}/persist"

################################################################################

export COLOR_RESET="\033[0m"
export RED_BG="\033[41m"
export BLUE_BG="\033[44m"
export YELLOW_BG="\033[43m"


function err {
    echo -e "${RED_BG}$1${COLOR_RESET}"
}

function info {
    echo -e "${BLUE_BG}$1${COLOR_RESET}"
}

function warning {
    echo -e "${YELLOW_BG}$1${COLOR_RESET}"
}

function prompt_danger {
    echo -e "⚠️ ⚠${YELLOW_BG}$1${COLOR_RESET} ⚠️⚠"
    read -p "Are you sure? (Type 'yes' in captial letters): " -r
    echo
    echo
    if ! [[ ${REPLY} == "YES" ]];
    then
        err "Aborting"
        exit 1
    fi
}

################################################################################

if [[ "${DISK}" == "changeme" ]]; then
    err "You haven't configured the script. Please edit the script and set the variables."
    exit 1
fi

export DISK_PATH="/dev/${DISK}"

if ! [[ -b "${DISK_PATH}" ]]; then
    err "Invalid argument: DISK='${DISK_PATH}' is not a block special file"
    exit 1
fi

if [[ "${EUID}" -gt 0 ]]; then
    err "Must run as root"
    exit 1
fi

prompt_danger "This will destroy all partitions and data on the root disk ${DISK_PATH} irrevoably."

info "Running the UEFI (GPT) partitioning for the root disk"

blkdiscard -f "${DISK_PATH}"
sgdisk --zap-all "${DISK_PATH}"
sgdisk --clear  --mbrtogpt "${DISK_PATH}"

# Partitioning
parted "${DISK_PATH}" -s -- mklabel gpt
parted "${DISK_PATH}" -- mkpart root ext4 512MB "-${SWAPSIZE}"        # p1 for NixOS
parted "${DISK_PATH}" -- mkpart swap linux-swap "-${SWAPSIZE}" 100%   # p2 for swap space
parted "${DISK_PATH}" -- mkpart ESP fat32 1MB 512MB                   # p3 for boot
parted "${DISK_PATH}" -- set 3 esp on

export ROOT="${DISK_PATH}1"
export SWAP="${DISK_PATH}2"
export BOOT="${DISK_PATH}3"

info "Formatting boot partition ${BOOT}..."
mkfs.fat -F 32 -n BOOT "${BOOT}"

info "Creating swap partition ${SWAP}..."
mkswap -L SWAP "${SWAP}"
swapon "${SWAP}"

info "Formatting root partition"
mkfs.ext4 -L NIXOS "${ROOT}"

info "Mounting ${ROOT} to /mnt..."
mount -t ext4 "${ROOT}" /mnt

info "Mounting ${BOOT} to /mnt/boot..."
mkdir -p /mnt/boot
mount "${BOOT}" /mnt/boot

info "Creating ssh keys"
mkdir -p /mnt/etc/ssh
ssh-keygen -b 4096 -t rsa -N "" -f /mnt/etc/ssh/ssh_host_rsa_key
ssh-keygen -t ed25519 -N "" -f /mnt/etc/ssh/ssh_host_ed25519_key

# info "Creating ${ZFS_POOL} ZFS pool for ${ROOT}..."
# zpool create -O mountpoint=none "${ZFS_POOL}" "${ROOT}" -f

# info "Creating ${ZFS_DS_ROOT} dataset..."
# zfs create -p -o mountpoint=legacy "${ZFS_DS_ROOT}"

# info "Creating ${ZFS_DS_ROOT}@blank ZFS snapshot..."
# zfs snapshot "${ZFS_DS_ROOT}@blank"

# info "Mounting ${ZFS_DS_ROOT} to /mnt..."
# mount -t zfs "${ZFS_DS_ROOT}" /mnt

# info "Creating ${ZFS_DS_NIX} ZFS dataset..."
# zfs create -p -o mountpoint=legacy "${ZFS_DS_NIX}"

# info "Mounting ${ZFS_DS_NIX} to /mnt/nix..."
# mkdir -p /mnt/nix
# mount -t zfs "${ZFS_DS_NIX}" /mnt/nix

# info "Creating ${ZFS_DS_HOME} ZFS dataset..."
# zfs create -p -o mountpoint=legacy "${ZFS_DS_HOME}"

# info "Mounting ${ZFS_DS_HOME} to /mnt/home..."
# mkdir -p /mnt/home
# mount -t zfs "${ZFS_DS_HOME}" /mnt/home

# info "Creating ${ZFS_DS_PERSIST} ZFS dataset..."
# zfs create -p -o mountpoint=legacy "${ZFS_DS_PERSIST}"

# info "Mounting ${ZFS_DS_PERSIST} to /mnt/persist..."
# mkdir -p /mnt/persist
# mount -t zfs "${ZFS_DS_PERSIST}" /mnt/persist

# info "Creating required directories in ${ZFS_DS_PERSIST}"
# mkdir -p /mnt/persist/etc/NetworkManager/system-connections
# mkdir -p /mnt/persist/var/lib/bluetooth

# info "Creating ssh keys"
# mkdir -p /mnt/persist/etc/ssh
# ssh-keygen -b 4096 -t rsa -N "" -f /mnt/persist/etc/ssh/ssh_host_rsa_key
# ssh-keygen -t ed25519 -N "" -f /mnt/persist/etc/ssh/ssh_host_ed25519_key
