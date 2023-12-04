{ pkgs, inputs, config, ... }:
let
  default-vscode-settings = builtins.fromJSON (builtins.readFile ./vscode_settings.json);
in {
  time.timeZone = "America/Toronto";
  user = "scotte";
  fullName = "Scotte Zinn";
  gitName = "Scotte Zinn";
  gitEmail = "scotte@zinn.ca";

  modules.sops = {
    enable = true;
    defaultSopsFile = ./secrets.sops.yaml;
    secrets = {
      abc = {
        path = "${config.home-manager.users.${config.user}.xdg.configHome}/abc";
      };
    };
  };
  modules.devops.enable = true;
  modules.gnupg.enable = true;
  modules.vscode = {
    enable = true;
    package = pkgs.vscode;
    config = default-vscode-settings;
    extensions = (with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
    ]);
  };
}
