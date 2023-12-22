{ pkgs, ... }:
{
  imports = [
    ./minio
    ./nfs
    ./openssh
  ];
}
