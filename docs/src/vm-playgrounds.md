# Virtual Machine Playgrounds

A great test environment (if you have [Parallels](https://www.parallels.com)) is to create a MacVM to try things out in.
It lets you blow it away and start fresh as many times as you want to ensure you have a repeatable environment without destroying your current working environment,

On my network, I configure the machines with specific MAC addresses to pick up DHCP configuration.

## Darwin

For a Darwin VM, create the Apple MacOS VM as you normally would.
Once the VM is created, shut it down, and run

```sh
prlctl set macOS --device-set net0 --type bridged
prlctl set macOS --device-set net0 --mac DECAFF200019
prlctl set macOS --memsize 16384
prlctl set macOS --cpus 4
```

Start the VM up again, install Prallel VMTools (which requires a reboot), enable remote login and ensure Terminal has full disk access.

## NixOS

For NixOS, download the minimal image and the CLI can be used to create/configure the VM.
Since I also want to use ZFS for experimentation, I create two additional disks.

```sh
prlctl create nixvm -o other
prlctl set nixvm --device-set cdrom0 --image ~/Downloads/nixos-minimal-23.11.1697.781e2a9797ec-aarch64-linux.iso  --connect
prlctl set nixvm --device-set net0 --type bridged
prlctl set nixvm --device-set net0 --mac DECAFF20001A
prlctl set nixvm --memsize 16384
prlctl set nixvm --cpus 4
prlctl set nixvm --device-set hdd0 --size 128G
prlctl set nixvm --device-add hdd --size 80G
prlctl set nixvm --device-add hdd --size 80G
prlctl start nixvm
```

Change into root and set a password for now.

```sh
sudo su
passwd
```

ssh is now available to log in as root for the remainder of the setup.

```sh
# Partitioning
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart root ext4 512MB -8GB
parted /dev/sda -- mkpart swap linux-swap -8GB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on

# Formatting
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

# Mounting disks for installation
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2

# Generating default configuration
nixos-generate-config --root /mnt
```

From this config copy the configuration and fetch the hardware configuration.

```sh
scp hosts/nixvm/configuration.nix root@nixvm:/mnt/etc/nixos/configuration.nix
scp root@nixvm:/mnt/etc/nixos/hardware-configuration.nix hosts/nixvm/hardware-configuration.nix
```

Then back to the VM

```sh
nixos-install
reboot
nixos-rebuild switch
```

Set the password for the user that was created.

```sh
passwd scotte
```

ssh in as the user

```sh
mkdir .local
cd .local
git clone https://github.com/szinn/nix-config.git
cd nix-config
nix develop
NIXPKGS_ALLOW_UNFREE=1 nix-shell -p _1password
op account add
eval $(op signin)
./scripts/fetch-secrets
```

An encrypted age key is required for secrets required during the rebuild.
Copy the output of the `ssh-to-age` execution to `.sops.yaml` in the appropriate entry.

```sh
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
```

Run `task sops:re-encrypt` which will re-encrypt the secrets for this VM.

Finally, apply the configuration.

```sh
sudo nixos-rebuild switch --flake .
```
