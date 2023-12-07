{ inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  config = {
    security.pam.enableSudoTouchIdAuth = true;

    nix.gc.interval = {
      Hour = 12;
      Minute = 15;
      Day = 1;
    };

    system = {
      defaults = {
        NSGlobalDomain = {
          # Set to dark mode
          AppleInterfaceStyle = "Dark";
          # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
          AppleKeyboardUIMode = 3;
          # Expand print panel by default
          PMPrintingExpandedStateForPrint = true;
          # Set a fast key repeat rate
          KeyRepeat = 2;
          # Shorten delay before key repeat begins
          InitialKeyRepeat = 12;
          # Save to local disk by default, not iCloud
          NSDocumentSaveNewDocumentsToCloud = false;
          # Disable autocorrect capitalization
          NSAutomaticCapitalizationEnabled = false;
          # Disable autocorrect smart dashes
          NSAutomaticDashSubstitutionEnabled = false;
          # Disable autocorrect adding periods
          NSAutomaticPeriodSubstitutionEnabled = false;
          # Disable autocorrect smart quotation marks
          NSAutomaticQuoteSubstitutionEnabled = false;
        };

        dock = {
          # Automatically show and hide the dock
          autohide = false;
          # Add translucency in dock for hidden applications
          showhidden = true;
          # Enable spring loading on all dock items
          enable-spring-load-actions-on-all-items = true;
          mineffect = "genie";
          orientation = "bottom";
          show-recents = false;
          tilesize = 44;
        };

        finder = {
          # Default Finder window set to column view
          FXPreferredViewStyle = "clmv";
          # Finder search in current folder by default
          FXDefaultSearchScope = "SCcf";
          # Disable warning when changing file extension
          FXEnableExtensionChangeWarning = false;
          # Allow quitting of Finder application
          QuitMenuItem = true;
        };

        # Where to save screenshots
        screencapture.location = "~/Downloads";
      };

      activationScripts.postActivation.text = ''
        # Must match what is in /etc/shells
        sudo chsh -s /run/current-system/sw/bin/fish scotte
      '';
      # Settings that don't have an option in nix-darwin
      activationScripts.postUserActivation.text = ''
        # Don't check the use keychain for PGP
        defaults write org.gpgtools.common UseKeychain -bool false
        # Avoid creating .DS_Store files on network or USB volumes
        defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
        defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
        # Show the ~/Library folder
        chflags nohidden ~/Library
        # Enable dock magnification
        defaults write com.apple.dock magnification -bool true
        # Set dock magnification size
        defaults write com.apple.dock largesize -int 48
        # Show dock immediately
        defaults write com.apple.Dock autohide-delay -float 0
        # Remove animation
        defaults write com.apple.dock autohide-time-modifier -float 0
        # Show all filename extensions
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true
        # Disable the warning when changing a file extension
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
        # Don's show network or CD drives on desktop
        defaults write com.apple.finder ShowExternalHardDrivesOnDesktop 0
        defaults write com.apple.finder ShowRemovableMediaOnDesktop 0
      '';
    };
  };
}
