{...}: {
  config = {
    networking.hostName = "odin";

    modules.users.scotte = {
      enable = true;
      username = "scotte";
      homeDirectory = "/Users/scotte";
    };

    homebrew = {
      taps = [
        "epk/epk" # font-sf-mono-nerd-font
        "siderolabs/talos"
      ];
      brews = [
        "postgresql@16"
        "prettier"
        "talhelper"
        "talosctl"
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
        "font-sf-mono-nerd-font"
        "google-chrome"
        "google-drive"
        "hazel"
        "iina"
        "jetbrains-toolbox"
        "lens"
        "logi-options-plus"
        "navigraph-charts"
        "navigraph-simlink"
        "obsidian"
        "parallels"
        "plex"
        "private-internet-access"
        "rectangle-pro"
        "raspberry-pi-imager"
        "sonos"
        "spotify"
        "switchresx"
        "ultimaker-cura"
        "visual-studio-code"
        "vnc-viewer"
        "wezterm"
        "yubico-authenticator"
        "zoom"
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
        "OmniFocus 4" = 1542143627;
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
      __add_app_to_dock /Applications/OmniFocus.localized/OmniFocus.app
      __add_app_to_dock /Applications/Drafts.app
      __add_app_to_dock /Applications/Visual\ Studio\ Code.app
      __add_app_to_dock /Applications/WezTerm.app
      __add_app_to_dock /Applications/Discord.app
      __add_app_to_dock /Applications/Slack.app
      __add_app_to_dock /System/Applications/Messages.app
      __add_app_to_dock /Applications/Spotify.app
      __add_app_to_dock /System/Applications/Music.app
      __add_app_to_dock /System/Applications/App\ Store.app
      __add_app_to_dock /System/Applications/System\ Settings.app

      # Folders
      __add_folder_to_dock /Users/scotte/Documents/ 1 1 0
      __add_folder_to_dock /Users/scotte/Downloads/ 1 1 0
    '';
  };
}
