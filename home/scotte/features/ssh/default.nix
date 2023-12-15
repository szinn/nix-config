{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.ssh;

  extraConfigDarwin =
    if pkgs.stdenv.isDarwin then
      ''
        AddKeysToAgent yes
        UseKeychain yes
      ''
    else
      "";
in
{
  options.features.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf (cfg.enable) {
    programs.ssh = {
      enable = true;
      extraConfig = extraConfigDarwin;
      matchBlocks = {
        gateway = {
          host = "gateway.zinn.tech";
          port = 22;
          user = "vyos";
          identityFile = "~/.ssh/id_ed25519";
        };
        ragnar = {
          host = "ragnar.zinn.tech";
          port = 22;
          user = "scotte";
          identityFile = "~/.ssh/id_ed25519";
        };
        octo = {
          host = "octo.zinn.tech";
          port = 22;
          user = "pi";
          identityFile = "~/.ssh/id_ed25519";
        };
        pione = {
          host = "pione.zinn.tech";
          port = 22;
          user = "pi";
          identityFile = "~/.ssh/id_ed25519";
        };
        zeus = {
          host = "zeus.zinn.tech";
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
        "github-magized" = {
          host = "ssh.github.com";
          port = 443;
          user = "git";
          identityFile = "~/.ssh/id_magized";
        };
        pikvm = {
          host = "pikvm.zinn.tech";
          port = 22;
          user = "root";
          identityFile = "~/.ssh/id_ed25519";
        };
        ares = {
          host = "ares.zinn.tech";
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
}
