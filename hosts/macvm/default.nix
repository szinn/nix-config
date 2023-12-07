{ pkgs, config, inputs, ... }: {
  imports = [
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
    }
    ../common/global
    ../common/darwin
    ../common/users/scotte/darwin.nix
  ];

  config = {
    networking.hostName = "macvm";
    system.stateVersion = 4;

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
        "$(__dock_item /Applications/Safari.app)" \
        "$(__dock_item ${pkgs.vscode}/Applications/Visual\ Studio\ Code.app)" \
        "$(__dock_item ${pkgs.alacritty}/Applications/Alacritty.app)" \
        "$(__dock_item /System/Applications/App\ Store.app)" \
        "$(__dock_item /System/Applications/System\ Settings.app)"

      sudo killall Finder
      sudo killall Dock
    '';
  };
}
