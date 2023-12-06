{ pkgs, inputs, ... }: {
  imports = [
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
    }
    ../common/global
    ../common/darwin
    ../common/users/scotte/darwin.nix
  ];

  networking.hostName = "macvm";
}
