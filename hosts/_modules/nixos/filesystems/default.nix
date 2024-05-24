{pkgs, ...}: {
  imports = [
    ./nfs.nix
    ./samba.nix
    ./zfs.nix
  ];
}
