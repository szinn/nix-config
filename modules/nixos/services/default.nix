{ pkgs, ... }:
{
  imports = [
    ./k3s
    ./minio
    ./nfs
    ./openssh
    ./rclone-backup
    ./samba
    ./sops
  ];
}
