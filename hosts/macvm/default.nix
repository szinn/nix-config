{ pkgs, config, inputs, outputs, lib, ... }:
{
  imports = [
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
    }
    ../common/global
    ../common/darwin
    ../common/users/scotte
  ];

  networking.hostName = "macvm";

  system.stateVersion = 4;
}
