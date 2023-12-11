{ pkgs, inputs, outputs, config, lib, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
    ms-vscode-remote.remote-ssh
  ]);
in
{
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
      configPath = "${config.home.homeDirectory}/.local/nix-config/home/scotte/settings.json";
      extensions = extensions;
    })
    # Uncomment if using sops secrets
    # (import ./features/sops {
    #   ageFile = "${config.xdg.configHome}/age/keys.txt";
    #   sopsFile = ./secrets.sops.yaml;
    #   secrets = {
    #     abc = {
    #       path = "${config.xdg.configHome}/abc";
    #     };
    #   };
    # })
    ./features/_1password
    ./features/devops
    ./features/fish
    (import ./features/git {
      name = "Scotte Zinn";
      email = "scotte@zinn.ca";
    })
    ./features/gnupg
    ./features/rust
    ./features/ssh
    ./features/tmux
    ./features/utilities
    ./features/wezterm

    # Can't do this since it needs to install in /Applications  
    # ./darwin/_1password
    ./darwin/fish
    ./darwin/fonts
    ./darwin/gnupg
    ./darwin/git
  ];
}
