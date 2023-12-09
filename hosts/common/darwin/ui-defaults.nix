{ config, ... }:
{
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
        InitialKeyRepeat = 15;
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
        autohide = true;
        # Add translucency in dock for hidden applications
        showhidden = true;
        # Enable spring loading on all dock items
        enable-spring-load-actions-on-all-items = true;
        mineffect = "genie";
        orientation = "bottom";
        show-recents = false;
        tilesize = 36;
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

    activationScripts.postUserActivation.text = ''
      ###############################################################################
      # General UI/UX                                                               #
      ###############################################################################
      # Dark mode
      defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
      # Disable transparency in the menu bar and elsewhere on Yosemite
      defaults write com.apple.universalaccess reduceTransparency -bool true
      # Set sidebar icon size to medium
      defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
      # Show scrollbars (Possible values: `WhenScrolling`, `Automatic` and `Always`)
      defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
      # Increase window resize speed for Cocoa applications
      defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
      # Expand save panel by default
      defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
      defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
      # Expand print panel by default
      defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
      defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
      # Save to disk (not to iCloud) by default
      defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
      # Automatically quit printer app once the print jobs complete
      defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
      # Disable the “Are you sure you want to open this application?” dialog
      defaults write com.apple.LaunchServices LSQuarantine -bool false
      # Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
      /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
      # Display ASCII control characters using caret notation in standard text views
      # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
      defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
      # Disable automatic termination of inactive apps
      defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
      # Disable the crash reporter
      #defaults write com.apple.CrashReporter DialogType -string "none"
      # Reveal IP address, hostname, OS version, etc. when clicking the clock
      # in the login window
      sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
      # Disable automatic capitalization as it’s annoying when typing code
      defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
      # Disable smart dashes as they’re annoying when typing code
      defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
      # Disable automatic period substitution as it’s annoying when typing code
      defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
      # Disable smart quotes as they’re annoying when typing code
      defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
      # Disable auto-correct
      defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
      ###############################################################################
      # Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
      ###############################################################################
      # Trackpad: enable tap to click for this user and for the login screen
      defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
      defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
      defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
      # Trackpad: map bottom right corner to right-click
      defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
      defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
      defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
      defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
      # Increase sound quality for Bluetooth headphones/headsets
      defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
      # Enable full keyboard access for all controls
      # (e.g. enable Tab in modal dialogs)
      defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
      # Set a blazingly fast keyboard repeat rate
      # defaults write NSGlobalDomain KeyRepeat -int 2
      # defaults write NSGlobalDomain InitialKeyRepeat -int 10
      ###############################################################################
      # Energy saving                                                               #
      ###############################################################################
      # Enable lid wakeup
      sudo pmset -a lidwake 1
      # Sleep the display after 15 minutes
      sudo pmset -a displaysleep 15
      # Set machine sleep to 20 minutes on battery
      sudo pmset -b sleep 20
      # Set standby delay to 24 hours (default is 1 hour)
      sudo pmset -a standbydelay 86400
      # Hibernation mode
      # 0: Disable hibernation (speeds up entering sleep mode)
      # 3: Copy RAM to disk so the system state can still be restored in case of a
      #    power failure.
      sudo pmset -a hibernatemode 0
      # Remove the sleep image file to save disk space
      # sudo rm /private/var/vm/sleepimage
      # Create a zero-byte file instead…
      # sudo touch /private/var/vm/sleepimage
      # …and make sure it can’t be rewritten
      # sudo chflags uchg /private/var/vm/sleepimage
      ###############################################################################
      # Screen                                                                      #
      ###############################################################################
      # Require password immediately after sleep or screen saver begins
      defaults write com.apple.screensaver askForPassword -int 1
      defaults write com.apple.screensaver askForPasswordDelay -int 0
      # Save screenshots to Downloads/Screenshots
      defaults write com.apple.screencapture location -string "/Users/scotte/Downloads/Screenshots"
      # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
      defaults write com.apple.screencapture type -string "png"
      # Disable shadow in screenshots
      defaults write com.apple.screencapture disable-shadow -bool true
      # Enable subpixel font rendering on non-Apple LCDs
      # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
      defaults write NSGlobalDomain AppleFontSmoothing -int 1
      # Enable HiDPI display modes (requires restart)
      sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
      ###############################################################################
      # Finder                                                                      #
      ###############################################################################
      # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
      defaults write com.apple.finder QuitMenuItem -bool true
      # Finder: disable window animations and Get Info animations
      defaults write com.apple.finder DisableAllAnimations -bool true
      # Set HOME as the default location for new Finder windows
      # For other paths, use `PfLo` and `file:///full/path/here/`
      defaults write com.apple.finder NewWindowTarget -string "PfLo"
      defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/scotte/"
      # Show icons for hard drives, servers, and removable media on the desktop
      defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
      defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
      defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
      defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
      # Finder: show hidden files by default
      defaults write com.apple.finder AppleShowAllFiles -bool true
      # Finder: show all filename extensions
      defaults write NSGlobalDomain AppleShowAllExtensions -bool true
      # Finder: show status bar
      defaults write com.apple.finder ShowStatusBar -bool true
      # Finder: show path bar
      defaults write com.apple.finder ShowPathbar -bool true
      # Disable display full POSIX path as Finder window title
      defaults write com.apple.finder _FXShowPosixPathInTitle -bool false
      # Keep folders on top when sorting by name
      defaults write com.apple.finder _FXSortFoldersFirst -bool true
      # Disable the warning when changing a file extension
      defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
      # Enable spring loading for directories
      defaults write NSGlobalDomain com.apple.springing.enabled -bool true
      # Remove the spring loading delay for directories
      defaults write NSGlobalDomain com.apple.springing.delay -float 0
      # Avoid creating .DS_Store files on network or USB volumes
      defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
      defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
      # Disable disk image verification
      defaults write com.apple.frameworks.diskimages skip-verify -bool true
      defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
      defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
      # Automatically open a new Finder window when a volume is mounted
      defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
      defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
      defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
      # Use list view in all Finder windows by default
      # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
      # defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
      # Show the ~/Library folder
      chflags nohidden ~/Library
      # Show the /Volumes folder
      sudo chflags nohidden /Volumes
      # Expand the following File Info panes:
      # “General”, “Open with”, and “Sharing & Permissions”
      defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true \
        OpenWith -bool true \
        Privileges -bool true
      ###############################################################################
      # Dock, Dashboard, and hot corners                                            #
      ###############################################################################
      # Enable highlight hover effect for the grid view of a stack (Dock)
      defaults write com.apple.dock mouse-over-hilite-stack -bool true
      # Set the icon size of Dock items to 36 pixels
      # defaults write com.apple.dock tilesize -int 36
      # Change minimize/maximize window effect
      defaults write com.apple.dock mineffect -string "scale"
      # Minimize windows into their application’s icon
      defaults write com.apple.dock minimize-to-application -bool true
      # Enable spring loading for all Dock items
      defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
      # Show indicator lights for open applications in the Dock
      defaults write com.apple.dock show-process-indicators -bool true
      # Don’t animate opening applications from the Dock
      defaults write com.apple.dock launchanim -bool false
      # Speed up Mission Control animations
      defaults write com.apple.dock expose-animation-duration -float 0.1
      # Don’t automatically rearrange Spaces based on most recent use
      defaults write com.apple.dock mru-spaces -bool false
      # Disable dock magnification
      defaults write com.apple.dock magnification -bool false
      # Set dock magnification size
      defaults write com.apple.dock largesize -int 48
      # Automatically hide and show the Dock
      # defaults write com.apple.dock autohide -bool true
      # Remove the auto-hiding Dock delay
      defaults write com.apple.dock autohide-delay -float 0
      # Remove the animation when hiding/showing the Dock
      defaults write com.apple.dock autohide-time-modifier -float 0
      # Make Dock icons of hidden applications translucent
      # defaults write com.apple.dock showhidden -bool true
      # Show recent applications in Dock
      defaults write com.apple.dock show-recents -bool true
      # Hot corners
      # Possible values:
      #  0: no-op
      #  2: Mission Control
      #  3: Show application windows
      #  4: Desktop
      #  5: Start screen saver
      #  6: Disable screen saver
      #  7: Dashboard
      # 10: Put display to sleep
      # 11: Launchpad
      # 12: Notification Center
      # 13: Lock Screen
      # Top left screen corner → Mission Control
      defaults write com.apple.dock wvous-tl-corner -int 2
      defaults write com.apple.dock wvous-tl-modifier -int 0
      # Top right screen corner → Display to sleep
      defaults write com.apple.dock wvous-tr-corner -int 10
      defaults write com.apple.dock wvous-tr-modifier -int 0
      # Bottom left screen corner → Display to sleep
      defaults write com.apple.dock wvous-bl-corner -int 10
      defaults write com.apple.dock wvous-bl-modifier -int 0
      # Bottom right screen corner →
      defaults write com.apple.dock wvous-bl-corner -int 14
      defaults write com.apple.dock wvous-bl-modifier -int 0
      ###############################################################################
      # Safari & WebKit                                                             #
      ###############################################################################
      # Privacy: don’t send search queries to Apple
      defaults write com.apple.Safari UniversalSearchEnabled -bool false
      defaults write com.apple.Safari SuppressSearchSuggestions -bool true
      # Press Tab to highlight each item on a web page
      defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
      # Show the full URL in the address bar (note: this still hides the scheme)
      defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
      # Set Safari’s home page to `about:blank` for faster loading
      defaults write com.apple.Safari HomePage -string "about:blank"
      # Prevent Safari from opening ‘safe’ files automatically after downloading
      defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
      # Hide Safari’s bookmarks bar by default
      defaults write com.apple.Safari ShowFavoritesBar -bool false
      # Hide Safari’s sidebar in Top Sites
      defaults write com.apple.Safari ShowSidebarInTopSites -bool false
      # Disable Safari’s thumbnail cache for History and Top Sites
      defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
      # Enable Safari’s debug menu
      defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
      # Make Safari’s search banners default to Contains instead of Starts With
      defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
      # Enable the Develop menu and the Web Inspector in Safari
      defaults write com.apple.Safari IncludeDevelopMenu -bool true
      defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
      # Add a context menu item for showing the Web Inspector in web views
      defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
      # Enable continuous spellchecking
      defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
      # Disable auto-correct
      defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
      # Warn about fraudulent websites
      defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
      # Enable “Do Not Track”
      defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
      # Update extensions automatically
      defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
      # Show Favorites bar
      defaults write com.apple.Safari ShowFavoritesBar-v2 -bool true
      # Enable narrow tabs
      defaults write com.apple.Safari EnableNarrowTabs -int 1
      # Enable compact display
      defaults write com.apple.Safari ShowStandaloneTabBar -int 0
      ###############################################################################
      # Spotlight                                                                   #
      ###############################################################################
      # Disable Spotlight indexing for any volume that gets mounted and has not yet
      # been indexed before.
      # Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
      # sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
      # Change indexing order and disable some search results
      # Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
      # 	MENU_DEFINITION
      # 	MENU_CONVERSION
      # 	MENU_EXPRESSION
      # 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
      # 	MENU_WEBSEARCH             (send search queries to Apple)
      # 	MENU_OTHER
      defaults write com.apple.spotlight orderedItems -array \
        '{"enabled" = 1;"name" = "APPLICATIONS";}' \
        '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
        '{"enabled" = 1;"name" = "DIRECTORIES";}' \
        '{"enabled" = 1;"name" = "PDF";}' \
        '{"enabled" = 1;"name" = "FONTS";}' \
        '{"enabled" = 0;"name" = "DOCUMENTS";}' \
        '{"enabled" = 0;"name" = "MESSAGES";}' \
        '{"enabled" = 0;"name" = "CONTACT";}' \
        '{"enabled" = 0;"name" = "EVENT_TODO";}' \
        '{"enabled" = 0;"name" = "IMAGES";}' \
        '{"enabled" = 0;"name" = "BOOKMARKS";}' \
        '{"enabled" = 0;"name" = "MUSIC";}' \
        '{"enabled" = 0;"name" = "MOVIES";}' \
        '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
        '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
        '{"enabled" = 0;"name" = "SOURCE";}' \
        '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
        '{"enabled" = 0;"name" = "MENU_OTHER";}' \
        '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
        '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
        '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
        '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
      # # Load new settings before rebuilding the index
      # killall mds > /dev/null 2>&1
      # # Make sure indexing is enabled for the main volume
      # sudo mdutil -i on / > /dev/null
      # # Rebuild the index from scratch
      # sudo mdutil -E / > /dev/null
      ###############################################################################
      # Time Machine                                                                #
      ###############################################################################
      # Prevent Time Machine from prompting to use new hard drives as backup volume
      defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
      # Disable local Time Machine backups
      # hash tmutil &> /dev/null && sudo tmutil disablelocal
      ###############################################################################
      # Activity Monitor                                                            #
      ###############################################################################
      # Show the main window when launching Activity Monitor
      defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
      # Visualize CPU usage in the Activity Monitor Dock icon
      defaults write com.apple.ActivityMonitor IconType -int 5
      # Show all processes in Activity Monitor
      defaults write com.apple.ActivityMonitor ShowCategory -int 0
      # Sort Activity Monitor results by CPU usage
      defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
      defaults write com.apple.ActivityMonitor SortDirection -int 0
      ###############################################################################
      # Mac App Store                                                               #
      ###############################################################################
      # Enable the WebKit Developer Tools in the Mac App Store
      defaults write com.apple.appstore WebKitDeveloperExtras -bool true
      # Enable Debug Menu in the Mac App Store
      defaults write com.apple.appstore ShowDebugMenu -bool true
      # Enable the automatic update check
      defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
      # Check for software updates daily, not just once per week
      defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
      # Download newly available updates in background
      defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
      # Install System data files & security updates
      defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
      # Automatically download apps purchased on other Macs
      defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
      # Turn on app auto-update
      defaults write com.apple.commerce AutoUpdate -bool true
      # Allow the App Store to reboot machine on macOS updates
      defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
      ###############################################################################
      # GPGMail 2                                                                   #
      ###############################################################################
      # Disable signing emails by default
      defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false
      ###############################################################################
      # GPGTools                                                                    #
      ###############################################################################
      # Don't check the use keychain for PGP
      defaults write org.gpgtools.common UseKeychain -bool false
    '';
  };
}
