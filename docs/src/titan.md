# Titan Bringup

Change into root and set a password for now.

```sh
sudo su
passwd
```

## Configuration

From the workstation, configure the host with

```sh
task host-configure ip=10.0.0.7 host=titan
```

Update `.sops.yaml` with the displayed sops-age key and then `task sops:re-encrypt`

Commit and push the changes from the workstation.

## Installation

From the workstation, install nix with

```sh
task host-install ip=10.0.0.7 host=titan
```

When complete, reboot the host and ensure the ISO image has been unmounted.

## Final Configuration

The final step is to bring the configuration locally and fetch secrets from 1Password.

ssh into titan and

```sh
git clone https://github.com/szinn/nix-config.git .local/nix-config
cd .local/nix-config
task finalize-install
```
