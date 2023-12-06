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
  ];
}
