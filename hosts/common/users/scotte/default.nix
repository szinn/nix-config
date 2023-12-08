{ config, pkgs, ... }:
{
  users.users.scotte = {
    name = "scotte";
    home = "/Users/scotte";
    shell = pkgs.fish;
    packages = [ pkgs.home-manager ];
  };

  home-manager.users.scotte = import ../../../../home/scotte/${config.networking.hostName}.nix;

  homebrew = {
    taps = [
    ];
    casks = [
      "1password" # 1Password packaging on Nix is broken for macOS
    ];
  };

  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    sudo chsh -s /run/current-system/sw/bin/fish scotte
  '';

  system.activationScripts.postUserActivation.text = ''
    # Define dock icon function
    __dock_item() {
      printf "%s%s%s%s%s" \
        "<dict><key>tile-data</key><dict><key>file-data</key><dict>" \
        "<key>_CFURLString</key><string>" \
        "$1" \
        "</string><key>_CFURLStringType</key><integer>0</integer>" \
        "</dict></dict></dict>"
    }

    # Choose and order dock icons
    defaults write com.apple.dock persistent-apps -array \
      "$(__dock_item /Applications/1Password.app)" \
      "$(__dock_item /Applications/Safari.app)" \
      "$(__dock_item ${pkgs.vscode}/Applications/Visual\ Studio\ Code.app)" \
      "$(__dock_item ${pkgs.alacritty}/Applications/Alacritty.app)" \
      "$(__dock_item /System/Applications/App\ Store.app)" \
      "$(__dock_item /System/Applications/System\ Settings.app)"

    sudo killall Finder
    sudo killall Dock
    # sudo killall gpg-agent
    '';
}
