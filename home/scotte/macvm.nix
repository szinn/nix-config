{ pkgs, inputs, outputs, config, lib, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
    ms-vscode-remote.remote-ssh
  ]);
in {
  imports = [
    {
      home = {
        username = "scotte";
        homeDirectory = "/Users/scotte";
        sessionPath = [ "$HOME/.local/bin" ];
      };
    }
    ./global

    (import ./features/vscode {
        configPath = "/Users/scotte/.local/nix-config/home/scotte/settings.json";
        extensions = extensions;
    })
    (import ./features/sops {
      ageFile = "${config.xdg.configHome}/age/keys.txt";
      sopsFile = ./secrets.sops.yaml;
      secrets = {
        abc = {
          path = "${config.xdg.configHome}/abc";
        };
      };
    })
    ./features/alacritty
    ./features/devops
    ./features/fish
    (import ./features/git {
      name = "Scotte Zinn";
      email = "scotte@zinn.ca";
    })
    ./features/gnupg
    ./features/ssh
    ./features/tmux
    ./features/utilities
    ./darwin/fish
    ./darwin/fonts
    ./darwin/git
  ];
}
