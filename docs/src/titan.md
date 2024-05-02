# Titan Bringup

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
task get-titan-config
```

Then back to the VM

```sh
nixos-install
reboot
```

Followed by

```sh
nixos-rebuild switch
passwd scotte
```

ssh in as the user

```sh
mkdir .local
cd .local
git clone https://github.com/szinn/nix-config.git
cd nix-config
nix develop
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
sudo reboot
```



```sh
op account add
eval $(op signin)
./scripts/fetch-secrets
```
