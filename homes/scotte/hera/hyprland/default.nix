{pkgs, ...}: {
  imports = [
    ./config
    ./waybar
  ];

  wayland.windowManager.hyprland.enable = true;

  systemd.user.services.wayVNC = {
    Unit = {
      Description = "VNC server for Wayland.";
      Documentation = "https://github.com/any1/wayvnc";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session-pre.target"];
    };

    Service = {
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc -g 0.0.0.0";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      KillMode = "mixed";
    };

    Install = {WantedBy = ["hyprland-session.target"];};
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
