# Hera Bringup

Hera is an experimentation platform running NixOS with impermanence
(see [Erase your darlings](https://grahamc.com/blog/erase-your-darlings/)).

To make the bringup easier, ssh can be used, but requires a password.
This password doesn't need to be secure, it is just for the first few steps of the bringup.

```sh
sudo su
passwd
```

Now you can ssh into hera for the remainder of the bringup with `ssh hera -l root`.

## Disk partitioning and formatting

The disk will get partitioned into boot, NixOS, and an 8Gb swap space.

```sh
# Partitioning
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart root ext4 512MB -8GB        # /dev/nvme0n1p1 for NixOS
parted /dev/nvme0n1 -- mkpart swap linux-swap -8GB 100%   # /dev/nvme0n1p2 for swap space
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB         # /dev/nvme0n1p3 for boot
parted /dev/nvme0n1 -- set 3 esp on

# Enabling Swap
mkswap -L swap /dev/nvme0n1p2

# Format Boot Drive
mkfs.fat -F 32 -n boot /dev/nvme0n1p3
```

## Prepping For Impermanence

When Hera reboots, it will always come online with the same root filesystem, and all temporary data reset.

### Grab the machine identifier

The machine identifier needs to be grabbed and must be unique across all machines on the network.

Run `head -c 8 /etc/machine-id` and copy into networking.hostId to ensure ZFS doesnt get borked on reboot.

### Create the root drive with an empty snapshot

```sh
zpool create -O mountpoint=none rpool /dev/nvme0n1p1 -f
zfs create -p -o mountpoint=legacy rpool/local/root
zfs snapshot rpool/local/root@blank
mount -t zfs rpool/local/root /mnt

### Create the various partitions

# Boot partition
mkdir /mnt/boot
mount /dev/nvme0n1p3 /mnt/boot

# /nix partition
zfs create -p -o mountpoint=legacy rpool/local/nix
mkdir /mnt/nix
mount -t zfs rpool/local/nix /mnt/nix

# /home partition
zfs create -p -o mountpoint=legacy rpool/safe/home
mkdir /mnt/home
mount -t zfs rpool/safe/home /mnt/home

# /persist partition
zfs create -p -o mountpoint=legacy rpool/safe/persist
mkdir /mnt/persist
mount -t zfs rpool/safe/persist /mnt/persist

# Required directories
mkdir -p /mnt/persist/etc/NetworkManager/system-connections
mkdir -p /mnt/persist/var/lib/bluetooth
mkdir -p /mnt/persist/etc/users
```

The hashed password for each user should go in `/mnt/persist/etc/users/<user>`.

### Prepare ssh keys

```sh
mkdir -p /mnt/persist/etc/ssh
ssh-keygen -b 4096 -t rsa -f /mnt/persist/etc/ssh/ssh_host_rsa_key
ssh-keygen -t ed25519 -f /mnt/persist/etc/ssh/ssh_host_ed25519_key
```

Now run

```sh
task get-hera-key
```

to fetch the ssh key that will be used for sops encryption.

Update `.sops.yaml` and then `task sops:re-encrypt`

Commit and push the changes.

### Config Generation

Generate the configuration with:

```sh
nixos-generate-config --root /mnt
```

followed by

```sh
task get-hera-config
```

from the host machine.

Finally, install via

```sh
nixos-install --no-root-passwd
```
