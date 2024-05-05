{pkgs, ...}: {
  imports = [
    ./nfs
    ./samba
    ./zfs
  ];
}
