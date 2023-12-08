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

Enable Remote Login for SSH access to the VM.

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

Afterwards, darwin-rebuild is required to run the updates.

```sh
darwin-rebuild switch --flake .#$(hostname -s)
```
