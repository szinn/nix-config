{ pkgs, config, inputs, lib, ... }:
{
  config = {
    networking.hostName = "macvm";

    modules.users.scotte = {
      enable = true;
      username = "scotte";
      homeDirectory = "/Users/scotte";
    };

    homebrew = {
      taps = [
      ];
      brews = [
      ];
      casks = [
        "1password"
        "alacritty"
        "visual-studio-code"
      ];
      masApps = { };
    };

    system.activationScripts.postUserActivation.text = ''
      # Applications
      __clear_dock
      __add_app_to_dock /Applications/1Password.app
      __add_app_to_dock /Applications/Safari.app
      __add_app_to_dock /Applications/Visual\ Studio\ Code.app
      __add_app_to_dock /Applications/Alacritty.app
      __add_app_to_dock /System/Applications/App\ Store.app
      __add_app_to_dock /System/Applications/System\ Settings.app

      # Folders
      __add_folder_to_dock /Users/scotte/Documents/ 1 1 0
      __add_folder_to_dock /Users/scotte/Downloads/ 1 1 0
    '';
  };
}
