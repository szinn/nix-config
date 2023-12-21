{ config, ... }:
{
  environment.etc."nfs.conf".source = ./nfs.conf;
}
