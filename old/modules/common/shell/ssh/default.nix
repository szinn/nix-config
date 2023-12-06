{ config, pkgs, lib, ... }:
let
  extraConfigDarwin = if pkgs.stdenv.isDarwin then
    ''
      AddKeysToAgent yes
      UseKeychain yes
    ''
  else
    "";
in {
  config = {
    home-manager.users.${config.user} = {
      programs.ssh = {
        enable = true;
        extraConfig = extraConfigDarwin;
        matchBlocks = {
          "gateway" = {
            port = 22;
            user = "vyos";
            identityFile = "~/.ssh/id_ed25519";
          };
          "zeus" = {
            port = 22;
            user = "root";
            identityFile = "~/.ssh/id_ed25519";
          };
          "github.com" = {
            host = "ssh.github.com";
            port = 443;
            user = "git";
            identityFile = "~/.ssh/id_ed25519";
          };
          "*.zinn.tech" = {
            port = 22;
            user = "scotte";
            identityFile = "~/.ssh/id_ed25519";
          };
        };
      };
    };
  };
}
