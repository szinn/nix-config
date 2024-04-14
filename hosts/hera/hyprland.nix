{
  inputs,
  pkgs,
  config,
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

  # greetd display manager
  services.greetd = let
    session = {
      command = "${lib.getExe config.programs.hyprland.package}";
      user = "scotte";
    };
  in {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = session;
      initial_session = session;
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
