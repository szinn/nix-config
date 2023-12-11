{ config, ... }:
{
  system = {
    defaults = {
      NSGlobalDomain = {
        # Whether to always show hidden files. The default is false
        AppleShowAllFiles = true;
        # Enables swiping left or right with two fingers to navigate backward or forward. The default is true
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        # Enables swiping left or right with two fingers to navigate backward or forward. The default is true
        AppleEnableSwipeNavigateWithScrolls = true;
        # Sets the level of font smoothing (sub-pixel font rendering)
        # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
        AppleFontSmoothing = 1;
        # Set to 'Dark' to enable dark mode, or leave unset for normal mode
        AppleInterfaceStyle = "Dark";
        # Whether to automatically switch between light and dark mode. The default is false
        AppleInterfaceStyleSwitchesAutomatically = false;
        # Configures the keyboard control behavior.  Mode 3 enables full keyboard control
        AppleKeyboardUIMode = 3;
        # Whether to enable the press-and-hold feature.  The default is true
        ApplePressAndHoldEnabled = true;
        # Whether to show all file extensions in Finder. The default is false
        AppleShowAllExtensions = true;
        # When to show the scrollbars. Options are 'WhenScrolling', 'Automatic' and 'Always'
        AppleShowScrollBars = "WhenScrolling";
        # Jump to the spot that's clicked on the scroll bar. The default is false
        AppleScrollerPagingBehavior = false;
        # Whether to enable automatic capitalization.  The default is true
        NSAutomaticCapitalizationEnabled = false;
        # Whether to enable smart dash substitution.  The default is true
        NSAutomaticDashSubstitutionEnabled = false;
        # Whether to enable smart period substitution.  The default is true
        NSAutomaticPeriodSubstitutionEnabled = false;
        # Whether to enable smart quote substitution.  The default is true
        NSAutomaticQuoteSubstitutionEnabled = false;
        # Whether to enable automatic spelling correction.  The default is true
        NSAutomaticSpellingCorrectionEnabled = false;
        # Whether to animate opening and closing of windows and popovers.  The default is true
        NSAutomaticWindowAnimationsEnabled = true;
        # Whether to disable the automatic termination of inactive apps
        NSDisableAutomaticTermination = true;
        # Whether to save new documents to iCloud by default.  The default is true.
        NSDocumentSaveNewDocumentsToCloud = false;
        # Sets the window tabbing when opening a new document: 'manual', 'always', or 'fullscreen'.  The default is 'fullscreen'.
        AppleWindowTabbingMode = "manual";
        # Whether to use expanded save panel by default.  The default is false.
        NSNavPanelExpandedStateForSaveMode = true;
        # Whether to use expanded save panel by default.  The default is false.
        NSNavPanelExpandedStateForSaveMode2 = true;
        # Sets the size of the finder sidebar icons: 1 (small), 2 (medium) or 3 (large). The default is 3.
        NSTableViewDefaultSizeMode = 2;
        # Whether to display ASCII control characters using caret notation in standard text views. The default is false.
        NSTextShowsControlCharacters = true;
        # Whether to enable the focus ring animation. The default is true.
        NSUseAnimatedFocusRing = true;
        # Whether to enable smooth scrolling. The default is true.
        NSScrollAnimationEnabled = true;
        # Sets the speed speed of window resizing. The default is given in the example.
        NSWindowResizeTime = 0.001;
        # Apple menu > System Preferences > Keyboard
        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # For example, the Delete key continues to remove text for as long as you hold it down.
        # This sets how long you must hold down the key before it starts repeating.
        InitialKeyRepeat = 15;
        # Apple menu > System Preferences > Keyboard
        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # For example, the Delete key continues to remove text for as long as you hold it down.
        # This sets how fast it repeats once it starts.
        KeyRepeat = 2;
        # Whether to use the expanded print panel by default. The default is false.
        PMPrintingExpandedStateForPrint = true;
        # Whether to use the expanded print panel by default. The default is false.
        PMPrintingExpandedStateForPrint2 = true;
        # Use F1, F2, etc. keys as standard function keys.
        "com.apple.keyboard.fnState" = true;
        # Configures the trackpad tap behavior.  Mode 1 enables tap to click.
        "com.apple.mouse.tapBehavior" = 1;
        # Apple menu > System Preferences > Sound
        # Sets the beep/alert volume level from 0.000 (muted) to 1.000 (100% volume).
        # 75% = 0.7788008
        # 50% = 0.6065307
        # 25% = 0.4723665
        "com.apple.sound.beep.volume" = 0.50;
        # Apple menu > System Preferences > Sound
        # Make a feedback sound when the system volume changed. This setting accepts
        # the integers 0 or 1. Defaults to 1.
        "com.apple.sound.beep.feedback" = 1;
        # Whether to enable trackpad secondary click.  The default is true.
        "com.apple.trackpad.enableSecondaryClick" = true;
        # Configures the trackpad corner click behavior.  Mode 1 enables right click.
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        # Configures the trackpad tracking speed (0 to 3).  The default is "1".
        "com.apple.trackpad.scaling" = 1.0;
        # Whether to enable spring loading (expose) for directories.
        "com.apple.springing.enabled" = true;
        # Set the spring loading delay for directories. The default is given in the example.
        "com.apple.springing.delay" = 0.0;
        # Whether to enable "Natural" scrolling direction.  The default is true.
        "com.apple.swipescrolldirection" = true;
        # Whether to use centimeters (metric) or inches (US, UK) as the measurement unit.  The default is based on region settings.
        # AppleMeasurementUnits = "Centimeters";
        # Whether to use the metric system.  The default is based on region settings.
        # AppleMetricUnits = 1;
        # Whether to use Celsius or Fahrenheit.  The default is based on region settings.
        # AppleTemperatureUnit = "Celsius";
        # Whether to use 24-hour or 12-hour time.  The default is based on region settings.
        # AppleICUForce = false;
        # Whether to autohide the menu bar.  The default is false.
        _HIHideMenuBar = false;
      };

      dock = {
        # Show appswitcher on all displays
        appswitcher-all-displays = false;
        # Automatically show and hide the dock
        autohide = true;
        # Autohide delay
        autohide-delay = 0.0;
        # Autohide time modifier
        autohide-time-modifier = 1.0;
        # Dashboard as a space
        dashboard-in-overlay = false;
        # Enable spring loading on all dock items
        enable-spring-load-actions-on-all-items = true;
        # Expose dock animation delay
        expose-animation-duration = 0.1;
        # Expose applications by group
        expose-group-by-app = true;
        # Launch animation
        launchanim = false;
        # Set the minimize/maximize window effect. The default is genie
        mineffect = "genie";
        # Enable highlight hover effect for the grid view of a stack in the Dock
        mouse-over-hilite-stack = false;
        # Whether to automatically rearrange spaces based on most recent use.  The default is true
        mru-spaces = false;
        # Position of the dock on screen.  The default is "bottom"
        orientation = "bottom";
        # Show indicator lights for open applications in the Dock. The default is true
        show-process-indicators = true;
        # Whether to make icons of hidden applications tranclucent.  The default is false
        showhidden = true;
        # Show recent applications in the dock. The default is true
        show-recents = true;
        # Show only open applications in the Dock. The default is false
        static-only = false;
        # Size of the icons in the dock.  The default is 64
        tilesize = 36;
        # Magnify icon on hover. The default is false
        magnification = false;
        # Magnified icon size on hover. The default is 16
        largesize = 16;
        # Hot corner action for top left corner. Valid values include:
        # * `1`: Disabled
        # * `2`: Mission Control
        # * `3`: Application Windows
        # * `4`: Desktop
        # * `5`: Start Screen Saver
        # * `6`: Disable Screen Saver
        # * `7`: Dashboard
        # * `10`: Put Display to Sleep
        # * `11`: Launchpad
        # * `12`: Notification Center
        # * `13`: Lock Screen
        # * `14`: Quick Note
        wvous-tl-corner = 1;
        wvous-bl-corner = 2;
        wvous-tr-corner = 10;
        wvous-br-corner = 14;
      };

      finder = {
        # Show all files
        AppleShowAllFiles = true;
        # Show status bar
        ShowStatusBar = true;
        # Show path bar
        ShowPathbar = true;
        # Finder search in this mac
        FXDefaultSearchScope = "SCev";
        # Default Finder window set to list view
        FXPreferredViewStyle = "Nlsv";
        # Show all extensions
        AppleShowAllExtensions = true;
        # Show icons on desktop
        CreateDesktop = true;
        # Allow quitting of Finder application
        QuitMenuItem = true;
        # Show Poxis Path in title
        _FXShowPosixPathInTitle = false;
        # Disable warning when changing file extension
        FXEnableExtensionChangeWarning = false;
      };

      ActivityMonitor = {
        # Change which processes to show.
        # * 100: All Processes
        # * 101: All Processes, Hierarchally
        # * 102: My Processes
        # * 103: System Processes
        # * 104: Other User Processes
        # * 105: Active Processes
        # * 106: Inactive Processes
        # * 107: Windowed Processes
        # Default is 100.
        ShowCategory = 100;
        # Change the icon in the dock when running.
        # * 0: Application Icon
        # * 2: Network Usage
        # * 3: Disk Activity
        # * 5: CPU Usage
        # * 6: CPU History
        # Default is null.
        IconType = 5;
        # Which column to sort the main activity page (such as "CPUUsage"). Default is null.
        SortColumn = "CPUUsage";
        # The sort direction of the sort column (0 is decending). Default is null
        SortDirection = 0;
        # Open the main window when opening Activity Monitor. Default is true
        OpenMainWindow = true;
      };

      LaunchServices = {
        LSQuarantine = false;
      };

      SoftwareUpdate = {
        # Automatically install Mac OS software updates. Defaults to false
        AutomaticallyInstallMacOSUpdates = false;
      };

      menuExtraClock = {
        # Show an analog clock instead of a digital one. Default is null
        IsAnalog = false;
        # Show a 24-hour clock, instead of a 12-hour clock. Default is null
        Show24Hour = false;
        # Show the AM/PM label. Useful if Show24Hour is false. Default is null
        ShowAMPM = true;
        # Show the day of the month. Default is null
        ShowDayOfMonth = true;
        # Show the day of the week. Default is null
        ShowDayOfWeek = true;
        # Show the full date. Default is null.
        # 0 = Show the date
        # 1 = Don't show
        # 2 = Don't show
        # TODO: I don't know what the difference is between 1 and 2.
        ShowDate = 1;
        # Show the clock with second precision, instead of minutes. Default is null
        ShowSeconds = false;
      };

      magicmouse = {
        # "OneButton": any tap is a left click.  "TwoButton": allow left-
        # and right-clicking.
        MouseButtonMode = "TwoButton";
      };

      screencapture = {
        # The filesystem path to which screencaptures should be written
        location = "/Users/scotte/Download/Screenshots";
        # The image format to use, such as "jpg"
        type = "png";
        # Disable drop shadow border around screencaptures. The default is false
        disable-shadow = true;
      };

      spaces = {
        # Apple menu > System Preferences > Mission Control
        # Displays have separate Spaces (note a logout is required before
        # this setting will take effect).
        # false = each physical display has a separate space (Mac default)
        # true = one space spans across all physical displays
        spans-displays = false;
      };
      universalaccess = {
        # Disable transparency in the menu bar and elsewhere.
        # Requires macOS Yosemite or later.
        # The default is false.
        reduceTransparency = true;
      };

      trackpad = {
        # Whether to enable trackpad tap to click.  The default is false
        Clicking = true;
        # Whether to enable tap-to-drag. The default is false
        Dragging = false;
        # Whether to enable trackpad right click.  The default is false
        TrackpadRightClick = true;
        # Whether to enable three finger drag.  The default is false
        TrackpadThreeFingerDrag = false;
        # 0 to enable Silent Clicking, 1 to disable.  The default is 1
        ActuationStrength = 1;
        # For normal click: 0 for light clicking, 1 for medium, 2 for firm.
        # The default is 1.
        FirstClickThreshold = 1;
        # For force touch: 0 for light clicking, 1 for medium, 2 for firm.
        # The default is 1.
        SecondClickThreshold = 1;
      };
    };

    activationScripts.preUserActivation.text = ''
      sudo rm -f /etc/bashrc /etc/zshrc /etc/zshenv
    '';

    # See https://github.com/mathiasbynens/dotfiles/blob/master/.macos
    activationScripts.postUserActivation.text = ''
        mkdir -p /Users/scotte/Downloads/Screenshots
        ###############################################################################
        # General UI/UX                                                               #
        ###############################################################################
        # Automatically quit printer app once the print jobs complete
        defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
      #   ###############################################################################
      #   # Screen                                                                      #
      #   ###############################################################################
      #   # Require password immediately after sleep or screen saver begins
      #   defaults write com.apple.screensaver askForPassword -int 1
      #   defaults write com.apple.screensaver askForPasswordDelay -int 0
      #   # Save screenshots to Downloads/Screenshots
      #   defaults write com.apple.screencapture location -string "/Users/scotte/Downloads/Screenshots"
      #   # Enable HiDPI display modes (requires restart)
      #   sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
        ###############################################################################
        # Finder                                                                      #
        ###############################################################################
        # Finder: disable window animations and Get Info animations
        defaults write com.apple.finder DisableAllAnimations -bool true
        # Set HOME as the default location for new Finder windows
        # For other paths, use `PfLo` and `file:///full/path/here/`
        defaults write com.apple.finder NewWindowTarget -string "PfLo"
        defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/scotte/"
      #   # Hide icons for hard drives, servers, and removable media on the desktop
      #   defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
      #   defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
      #   defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
      #   defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
      #   # Keep folders on top when sorting by name
      #   defaults write com.apple.finder _FXSortFoldersFirst -bool true
      #   # Avoid creating .DS_Store files on network or USB volumes
      #   defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
      #   defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
      #   # Disable disk image verification
      #   defaults write com.apple.frameworks.diskimages skip-verify -bool true
      #   defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
      #   defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
      #   # Automatically open a new Finder window when a volume is mounted
      #   defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
      #   defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
      #   defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
      #   # Use list view in all Finder windows by default
      #   # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
      #   # defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
      #   # Show the ~/Library folder
      #   chflags nohidden ~/Library
      #   # Show the /Volumes folder
      #   sudo chflags nohidden /Volumes
      #   # Expand the following File Info panes:
      #   # “General”, “Open with”, and “Sharing & Permissions”
      #   defaults write com.apple.finder FXInfoPanesExpanded -dict \
      #     General -bool true \
      #     OpenWith -bool true \
      #     Privileges -bool true
      #   ###############################################################################
      #   # Safari & WebKit                                                             #
      #   ###############################################################################
      #   # Privacy: don’t send search queries to Apple
      #   defaults write com.apple.Safari UniversalSearchEnabled -bool false
      #   defaults write com.apple.Safari SuppressSearchSuggestions -bool true
      #   # Press Tab to highlight each item on a web page
      #   defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
      #   defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
      #   # Show the full URL in the address bar (note: this still hides the scheme)
      #   defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
      #   # Set Safari’s home page to `about:blank` for faster loading
      #   defaults write com.apple.Safari HomePage -string "about:blank"
      #   # Prevent Safari from opening ‘safe’ files automatically after downloading
      #   defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
      #   # Hide Safari’s bookmarks bar by default
      #   defaults write com.apple.Safari ShowFavoritesBar -bool false
      #   # Hide Safari’s sidebar in Top Sites
      #   defaults write com.apple.Safari ShowSidebarInTopSites -bool false
      #   # Disable Safari’s thumbnail cache for History and Top Sites
      #   defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
      #   # Enable Safari’s debug menu
      #   defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
      #   # Make Safari’s search banners default to Contains instead of Starts With
      #   defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
      #   # Enable the Develop menu and the Web Inspector in Safari
      #   defaults write com.apple.Safari IncludeDevelopMenu -bool true
      #   defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
      #   defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
      #   # Add a context menu item for showing the Web Inspector in web views
      #   defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
      #   # Enable continuous spellchecking
      #   defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
      #   # Disable auto-correct
      #   defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
      #   # Warn about fraudulent websites
      #   defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
      #   # Enable “Do Not Track”
      #   defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
      #   # Update extensions automatically
      #   defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
      #   # Show Favorites bar
      #   defaults write com.apple.Safari ShowFavoritesBar-v2 -bool true
      #   # Enable narrow tabs
      #   defaults write com.apple.Safari EnableNarrowTabs -int 1
      #   # Enable compact display
      #   defaults write com.apple.Safari ShowStandaloneTabBar -int 0
      #   ###############################################################################
      #   # Spotlight                                                                   #
      #   ###############################################################################
      #   # Disable Spotlight indexing for any volume that gets mounted and has not yet
      #   # been indexed before.
      #   # Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
      #   # sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
      #   # Change indexing order and disable some search results
      #   # Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
      #   # 	MENU_DEFINITION
      #   # 	MENU_CONVERSION
      #   # 	MENU_EXPRESSION
      #   # 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
      #   # 	MENU_WEBSEARCH             (send search queries to Apple)
      #   # 	MENU_OTHER
      #   defaults write com.apple.spotlight orderedItems -array \
      #     '{"enabled" = 1;"name" = "APPLICATIONS";}' \
      #     '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
      #     '{"enabled" = 1;"name" = "DIRECTORIES";}' \
      #     '{"enabled" = 1;"name" = "PDF";}' \
      #     '{"enabled" = 1;"name" = "FONTS";}' \
      #     '{"enabled" = 0;"name" = "DOCUMENTS";}' \
      #     '{"enabled" = 0;"name" = "MESSAGES";}' \
      #     '{"enabled" = 0;"name" = "CONTACT";}' \
      #     '{"enabled" = 0;"name" = "EVENT_TODO";}' \
      #     '{"enabled" = 0;"name" = "IMAGES";}' \
      #     '{"enabled" = 0;"name" = "BOOKMARKS";}' \
      #     '{"enabled" = 0;"name" = "MUSIC";}' \
      #     '{"enabled" = 0;"name" = "MOVIES";}' \
      #     '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
      #     '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
      #     '{"enabled" = 0;"name" = "SOURCE";}' \
      #     '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
      #     '{"enabled" = 0;"name" = "MENU_OTHER";}' \
      #     '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
      #     '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
      #     '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
      #     '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
      #   # # Load new settings before rebuilding the index
      #   # killall mds > /dev/null 2>&1
      #   # # Make sure indexing is enabled for the main volume
      #   # sudo mdutil -i on / > /dev/null
      #   # # Rebuild the index from scratch
      #   # sudo mdutil -E / > /dev/null
      #   ###############################################################################
      #   # Time Machine                                                                #
      #   ###############################################################################
      #   # Prevent Time Machine from prompting to use new hard drives as backup volume
      #   defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
      #   # Disable local Time Machine backups
      #   # hash tmutil &> /dev/null && sudo tmutil disablelocal
      #   ###############################################################################
      #   # Mac App Store                                                               #
      #   ###############################################################################
      #   # Enable the WebKit Developer Tools in the Mac App Store
      #   defaults write com.apple.appstore WebKitDeveloperExtras -bool true
      #   # Enable Debug Menu in the Mac App Store
      #   defaults write com.apple.appstore ShowDebugMenu -bool true
      #   # Enable the automatic update check
      #   defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
      #   # Check for software updates daily, not just once per week
      #   defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
      #   # Download newly available updates in background
      #   defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
      #   # Install System data files & security updates
      #   defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
      #   # Automatically download apps purchased on other Macs
      #   defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
      #   # Turn on app auto-update
      #   defaults write com.apple.commerce AutoUpdate -bool true
      #   # Allow the App Store to reboot machine on macOS updates
      #   defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
      #   ###############################################################################
      #   # GPGMail 2                                                                   #
      #   ###############################################################################
      #   # Disable signing emails by default
      #   defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false
      #   ###############################################################################
      #   # GPGTools                                                                    #
      #   ###############################################################################
      #   # Don't check the use keychain for PGP
      #   defaults write org.gpgtools.common UseKeychain -bool false
    '';
  };
}
