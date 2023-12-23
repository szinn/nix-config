{ pkgs, ... }:
{
  imports = [
    ./k3s
    ./minio
    ./nfs
    ./openssh
    ./samba
  ];
}
