# nix-config - My Nix Configuration

See the full documentation at [szinn.github.io/nix-config](https://szinn.github.io/nix-config).

I manage my personal machines using Nix and Home-Manager.

The machines consist of:

| Machine | System         | Purpose |
| ------- | -------------- | ------- |
| hera    | x86_64-linux   | Intel NUC for running NixOS bare metal |
| macvm   | aarch64-darwin | Nix-Darwin VM running in Parallels on MacBook |
| nixvm   | aarch64-linux  | NixOS VM running in Parallels on MacBook |
| odin    | aarch64-darwin | Main MacBook Pro laptop |
| ragnar  | x86_64-linux   | NAS server |

## Bootstrapping MacOS Machines

Darwin machines can be bootstrapped from the nix-config repository directly.

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

Afterwards, if the configuration is touched, darwin-rebuild is required to run the updates.

```sh
git add . ; darwin-rebuild switch --flake .#$(hostname -s)
```

I have MacOS aliases `dupb` (darwin update build) to do a build only and show what changes. `dup` (darwin update) does the build and an install.

## Bootstrapping NixOS Machines

The process for bootstrapping a NixOS machine is essentially following the [VM process](https://szinn.github.io/nix-config/vm-playgrounds.html#nixos)
