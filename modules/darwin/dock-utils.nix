{pkgs, ...}: {
  system.activationScripts.preUserActivation.text = ''
    __clear_apps_from_dock() {
      defaults delete com.apple.dock persistent-apps
    }
    __clear_others_from_dock() {
      defaults delete com.apple.dock persistent-others
    }
    __clear_dock() {
      __clear_apps_from_dock
      __clear_others_from_dock
    }

    # adds an application to macOS Dock
    # usage: __add_app_to_dock "Application Name"
    # example __add_app_to_dock "/System/Applications/Music.app"
    __add_app_to_dock() {
        defaults write com.apple.dock persistent-apps -array-add \
          "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    }

    # adds a folder to macOS Dock
    # usage: __add_folder_to_dock "Folder Path" <Arrangement> <displayAs> <ShowAs>
    # example: __add_folder_to_dock "~/Downloads" <Arrangement> <displayAs> <ShowAs>
    # key:
    # Arrangement
    #   1 -> Name
    #   2 -> Date Added
    #   3 -> Date Modified
    #   4 -> Date Created
    #   5 -> Kind
    # DisplayAs
    #   0 -> Stack
    #   1 -> Folder
    # ShowAs
    #   0 -> Automatic
    #   1 -> Fan
    #   2 -> Grid
    #   3 -> List
    __add_folder_to_dock() {
      defaults write com.apple.dock persistent-others -array-add \
        "<dict><key>tile-data</key><dict><key>arrangement</key><integer>$2</integer><key>displayas</key><integer>$3</integer><key>file-data</key><dict><key>_CFURLString</key><string>file://$1</string><key>_CFURLStringType</key><integer>15</integer></dict><key>file-type</key><integer>2</integer><key>showas</key><integer>$4</integer></dict><key>tile-type</key><string>directory-tile</string></dict>"
    }
  '';

  system.activationScripts.postActivation.text = ''
    sudo killall Finder
    sudo killall Dock
    # sudo killall gpg-agent
  '';
}
