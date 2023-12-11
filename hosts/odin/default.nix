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

  networking.hostName = "odin";

  homebrew = {
    taps = [
      "epk/epk" # font-sf-mono-nerd-font
    ];
    brews = [
      "prettier"
    ];
    casks = [
      "1password"
      "adobe-acrobat-reader"
      "adobe-creative-cloud"
      "alfred"
      "arq"
      "bartender"
      "bettertouchtool"
      "caldigit-docking-utility"
      "calibre"
      "devonthink"
      "discord"
      "espanso"
      "font-sf-mono-nerd-font"
      "google-chrome"
      "google-drive"
      "hazel"
      "jetbrains-toolbox"
      "lens"
      "parallels"
      "private-internet-access"
      "rectangle-pro"
      "switchresx"
      "yubico-authenticator"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Amphetamine" = 937984704;
      "AutoMounter" = 1160435653;
      "Drafts" = 1435957248;
      "FLAC MP3 Converter" = 982124349;
      "forScore" = 363738376;
      "GarageBand" = 682658836;
      "iMovie" = 408981434;
      "KeyMapp" = 6472865291;
      "Keynote" = 409183694;
      "LogicPro" = 634148309;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "OmniFocus 3" = 1346203938;
      "Save to Reader" = 1640236961;
      "Slack" = 803453959;
      "Spark Desktop" = 6445813049;
      "WhatsApp" = 1147396723;
      "Wireguard" = 1451685025;
      "XCode" = 497799835;
    };
  };

  system.activationScripts.postUserActivation.text = ''
    # Applications
    __clear_dock
    __add_app_to_dock /Applications/1Password.app
    __add_app_to_dock /Applications/Safari.app
    __add_app_to_dock /Applications/Spark\ Desktop.app
    __add_app_to_dock /Applications/DEVONthink\ 3.app
    __add_app_to_dock /Applications/OmniFocus.app
    __add_app_to_dock /Applications/Drafts.app
    __add_app_to_dock ${pkgs.vscode}/Applications/Visual\ Studio\ Code.app
    __add_app_to_dock ${pkgs.alacritty}/Applications/Alacritty.app
    __add_app_to_dock ${pkgs.wezterm}/Applications/WezTerm.app
    __add_app_to_dock /Applications/Discord.app
    __add_app_to_dock /Applications/Slack.app
    __add_app_to_dock /System/Applications/Messages.app
    __add_app_to_dock /System/Applications/App\ Store.app
    __add_app_to_dock /System/Applications/System\ Settings.app

    # Folders
    __add_folder_to_dock /Users/scotte/Documents/ 1 1 0
    __add_folder_to_dock /Users/scotte/Downloads/ 1 1 0
  '';

  system.stateVersion = 4;
}
