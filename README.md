# nix-config - My WIP Nix Configuration

## Parallels MacOS VM

A great test environment (if you have Parallels) is to create a MacVM to try things out in.
It lets you blow it away and start fresh as many times as you want to ensure you have a repeatable environment without destroying your current working environment,

For my network, this lets the VM pick up DHCP configuration in an appropriate VLAN.

```sh
prlctl set "macOS" --device-set net0 --type bridged
prlctl set "macOS" --device-set net0 --mac DECAFF200019
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
