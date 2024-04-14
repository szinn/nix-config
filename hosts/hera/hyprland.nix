{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  homeCfgs = config.home-manager.users;
  homeSharePaths = lib.mapAttrsToList (_: v: "${v.home.path}/share") homeCfgs;
  vars = ''XDG_DATA_DIRS="$XDG_DATA_DIRS:${lib.concatStringsSep ":" homeSharePaths}" GTK_USE_PORTAL=0'';

  sway-kiosk = command: "${lib.getExe pkgs.sway} --unsupported-gpu --config ${pkgs.writeText "kiosk.config" ''
    output * bg #000000 solid_color
    xwayland disable
    input "type:touchpad" {
      tap enabled
    }
    exec '${vars} ${command}; ${pkgs.sway}/bin/swaymsg exit'
  ''}";
in {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };

  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "hyprland";
      start = ''
        ${lib.getExe pkgs.hyprland} &
        waitPID=$!
      '';
    }
  ];

  services.greetd = {
    enable = true;
    settings.default_session.command = sway-kiosk (lib.getExe config.programs.regreet.package);
  };

  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        # Whether to use the dark theme
        application_prefer_dark_theme = false;
      };

      commands = {
        # The command used to reboot the system
        reboot = ["systemctl" "reboot"];

        # The command used to shut down the system
        poweroff = ["systemctl" "poweroff"];
      };
    };
  };

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.hyprlock.text = "auth include login";
  };

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
    };
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    # dunst
    # swaybg
    wl-clipboard
    # TODO: gsettings + a default theme
    # grim
    # slurp
    # hyprpicker #TODO: remove this, we dont really need it
    # eww-wayland
    xdg-utils
    # mate.mate-polkit #TODO: fix polkit not autostarting
    openssl
    wlr-randr
    rofi-wayland # App launcher
    firefox
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      (nerdfonts.override {fonts = ["FiraCode"];})
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["FiraCode Nerd Font"];
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
      };
    };
  };
}
