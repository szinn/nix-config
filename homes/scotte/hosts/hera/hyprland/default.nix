{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  hyprland_waybar = pkgs.waybar.overrideAttrs (oldAttrs: {
    mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    postPatch = ''
      sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
    '';
  });
in {
  imports = [
    ./hyprlock.nix
    ./wlogout.nix
  ];

  services.hypridle = {
    enable = true;

    listeners = [
      {
        timeout = 300;
        onTimeout = "${lib.getExe config.programs.hyprlock.package}";
        onResume = "${pkgs.libnotify}/bin/notify-send \"Welcome back ${config.home.username}!\"";
      }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    package = hyprland_waybar;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
  };

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

  services.dunst = {
    enable = true;
    configFile = ./configs/dunstrc;
  };

  gtk = {
    enable = true;

    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
  };

  home.sessionVariables.GTK_THEME = "Dracula";

  xdg.configFile = {
    "hypr/hyprland.conf" = {
      text =
        lib.mkForce
        (''
            exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all && systemctl --user restart hyprland-session.target
          ''
          + builtins.readFile ./configs/hyprland.conf);
      onChange = ''
        (  # execute in subshell so that `shopt` won't affect other scripts
          shopt -s nullglob  # so that nothing is done if /tmp/hypr/ does not exist or is empty
          for instance in /tmp/hypr/*; do
            HYPRLAND_INSTANCE_SIGNATURE=''${instance##*/} ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl reload config-only \
              || true  # ignore dead instance(s)
          done
        )
      '';
    };

    "waybar" = {
      source = ./configs/waybar;
      recursive = true;
      onChange = ''systemctl --user restart waybar'';
    };

    "rofi" = {
      source = ./configs/rofi;
      recursive = true;
    };
  };
}
