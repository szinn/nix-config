{
  inputs,
  pkgs,
  lib,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
in {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --remember-session --sessions ${hyprland-session}";
        user = "greeter";
      };
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
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
    # swaylock-effects
    # swayidle
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
