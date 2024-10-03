# Ragnar Bringup

Ragnar is a server used as a NAS.

To make the bringup easier, ssh can be used, but requires a password.
This password doesn't need to be secure, it is just for the first few steps of the bringup.

```sh
sudo su
passwd
```

## Configuration

From the workstation, configure the host with

```sh
task host-configure ip=10.10.0.2 host=ragnar
```

Update `.sops.yaml` with the displayed sops-age key and then `task sops:re-encrypt`

Commit and push the changes from the workstation.

## Installation

From the workstation, install nix with

```sh
task host-install ip=10.10.0.2 host=ragnar
```

When complete, reboot the host and ensure the ISO image has been unmounted.

## Final Configuration

The final step is to bring the configuration locally and fetch secrets from 1Password.

ssh into ragnar and

```sh
git clone https://github.com/szinn/nix-config.git .local/nix-config
cd .local/nix-config
task finalize-install
```
