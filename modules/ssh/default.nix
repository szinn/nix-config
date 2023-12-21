{ username }: { config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.${username}.ssh;

  extraConfigDarwin =
    if pkgs.stdenv.isDarwin then
      ''
        UseKeychain yes
        AddKeysToAgent yes
      ''
    else
      "";
in
{
  options.modules.${username}.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.ssh = {
        enable = true;
        extraConfig = extraConfigDarwin;
        # addKeysToAgent = "yes";
        matchBlocks = {
          gateway = {
            hostname = "gateway.zinn.tech";
            port = 22;
            user = "vyos";
            identityFile = "~/.ssh/id_ed25519";
          };
          ragnar = {
            hostname = "ragnar.zinn.tech";
            port = 22;
            user = "scotte";
            identityFile = "~/.ssh/id_ed25519";
          };
          octo = {
            hostname = "octo.zinn.tech";
            port = 22;
            user = "pi";
            identityFile = "~/.ssh/id_ed25519";
          };
          pione = {
            hostname = "pione.zinn.tech";
            port = 22;
            user = "pi";
            identityFile = "~/.ssh/id_ed25519";
          };
          zeus = {
            hostname = "zeus.zinn.tech";
            port = 22;
            user = "root";
            identityFile = "~/.ssh/id_ed25519";
          };
          "github.com" = {
            hostname = "ssh.github.com";
            port = 443;
            user = "git";
            identityFile = "~/.ssh/id_ed25519";
          };
          "github-magized" = {
            hostname = "ssh.github.com";
            port = 443;
            user = "git";
            identityFile = "~/.ssh/id_magized";
          };
          pikvm = {
            hostname = "pikvm.zinn.tech";
            port = 22;
            user = "root";
            identityFile = "~/.ssh/id_ed25519";
          };
          ares = {
            hostname = "ares.zinn.tech";
            port = 22;
            user = "root";
            identityFile = "~/.ssh/id_ed25519";
          };
          "magized.com" = {
            port = 22;
            user = "mailu";
            identityFile = "~/.ssh/id_ed25519";
          };
        };
      };

      # Macs need authorized_keys to be a real, non-symlinked file
      # home.file.".ssh/authorized_keys".source = ./authorized_keys;
    };
  };
}
