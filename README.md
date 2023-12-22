# nix-config - My WIP Nix Configuration

## Parallels MacOS VM

A great test environment (if you have Parallels) is to create a MacVM to try things out in.
It lets you blow it away and start fresh as many times as you want to ensure you have a repeatable environment without destroying your current working environment,

For my network, this lets the VM pick up DHCP configuration in an appropriate VLAN.

```sh
prlctl set macOS --device-set net0 --type bridged
prlctl set macOS --device-set net0 --mac DECAFF200019
prlctl set macOS --memsize 16384
prlctl set macOS --cpus 4
```

Once the VM is up and running with the correct DHCP configuration, install Parallels VMTools. This enables clipboard access with the VM and will require a reboot.

Enable Remote Login for SSH access to the VM. Give Terminal full disk access.

## Parallels NixOS VM

As with creating a MacVM in Parallels, a NixOS one can also be created. An UEFI machine
is created.

```sh
prlctl create nixvm -o other
prlctl set nixvm --device-set cdrom0 --image ~/Downloads/nixos-minimal-23.11.1697.781e2a9797ec-aarch64-linux.iso  --connect
prlctl set nixvm --device-set net0 --type bridged
prlctl set nixvm --device-set net0 --mac DECAFF20001A
prlctl set nixvm --memsize 16384
prlctl set nixvm --cpus 4
prlctl set nixvm --device-set hdd0 --size 128G
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
git clone https://github.com/szinn/nix-config.git
cd nix-config
nix develop
NIXPKGS_ALLOW_UNFREE=1 nix-shell -p _1password
op account add
eval $(op signin)
./scripts/fetch-secrets
sudo nixos-rebuild switch --flake .
```

### Login Secrets Management

The password for a user can be set by encrypting a specific password with the host key on the target machine.

Use `ssh-to-age` to convert /etc/ssh/ssh_host_ed25519_key.pub to an age public key and add to .sops.yaml.
Run task sops:re-encrypt to re-encrypt secrets with the appropriate keys.

## Bootstrapping

```sh
bash -c "$(curl -LsS https://raw.githubusercontent.com/szinn/nix-config/main/bootstrap.sh)"
```

At this point, NIX should be installed. Restart the shell.

To bootstrap the configuration now, run

```sh
nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake .#$(hostname -s)
```

There might be a few files in /etc that need renaming to complete the installation.

```sh
sudo mv /etc/nix/nix.conf /etc/nix.conf.before-nix-darwin
sudo mv /etc/shells /etc/shells.before-nix-darwin
sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
```

Afterwards, if the `hosts` tree is touched, darwin-rebuild is required to run the updates.

```sh
git add . ; darwin-rebuild switch --flake .#$(hostname -s)
```

If just the `home` tree is touched, then home-manager is sufficient to run the updates.

```sh
git add . ; home-manager switch --flake.#$(whoami)@(hostname -s)
```

## Secrets

I store secrets in 1Password and fetch them through the script [fetch_secrets](./scripts/fetch_secrets).

All secrets are stored as documents with the file as the document. Secrets that are for machine alpha are tagged with "alpha".
As well, there must be a path for the secret and an optional script.

Paths are specified in the 1Password item as additional info text fields. The label is one of:

* `alpha:path`
* `Darwin:path`
* `default:path`

alpha:path will specify the path on machine alpha. If alpha:path is missing, then a Darwin machine will look for Darwin:path and use that.
Similarly, Linux:path will be used on a Linux (or NixOS) machine. If both of those are missing, default:path will be used.

Optional scripts are named the same way with `:script` as the suffix. The script will be executed after the secret is fetched to the specified path.

The combination of path and script is useful for tasks such as loading GPG secret keys. Set the path to `.` and then for a secret file named `secret-keys.asc`
the script

```sh
gpg --import ./secret-keys.asc
rm ./secret-keys.asc
```

will load the secrets into GPG and then erase the armoured file afterwards.
