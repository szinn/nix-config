# nix-config - My WIP Nix Configuration

## Parallels MacOS VM

A great test environment (if you have Parallels) is to create a MacVM to try things out in.
It lets you blow it away and start fresh as many times as you want to ensure you have a repeatable environment without destroying your current working environment,

For my network, this lets the VM pick up DHCP configuration in an appropraite VLAN.

```sh
prlctl set "macOS" --device-set net0 --type bridged
prlctl set "macOS" --device-set net0 --mac DECAFF20001C
prlctl set "macOS" --memsize 16384
prlctl set "macOS" --cpus 4
```

Once the VM is up and running with the correct DHCP configuration, install Parallels VMTools. This enables clipboard access with the VM and will require a reboot.

Enable Remote Login for SSH access to the VM. Install XCode tools.

```sh
mkdir ~/.ssh
xcode-select --install
```

Copy SSH keys and configuration as required.

```sh
 scp ~/.ssh/authorized_keys scotte@macvm:/Users/scotte/.ssh/authorized_keys
 scp ~/.ssh/id_ed25519 scotte@macvm:/Users/scotte/.ssh/id_ed25519
 scp ~/.ssh/id_ed25519.pub scotte@macvm:/Users/scotte/.ssh/id_ed25519.pub
```

## Bootstrapping

```sh
mkdir ~/.local
cd ~/.local
git clone git@github.com:szinn/nix-config.git
cd nix-config
./bootstrap.sh
```

At this point, NIX should be installed. Restart the shell.

To bootstrap the configuration now, run

```sh
nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake .#$(hostname -s)
```

There might be a few files in /etc that need renaming to complete the installation.

Afterwards, darwin-rebuild is required to run the updates.

```sh
darwin-rebuild switch --flake .#$(hostname -s)
```
