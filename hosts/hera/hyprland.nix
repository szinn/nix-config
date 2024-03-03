{
  inputs,
  pkgs,
  ...
}: {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    regreet = {
      enable = true;
      cageArgs = ["-dsmlast"];
      settings = {
        GTK.applicationprefer_dark_theme = true;

        commands = {
          reboot = ["systemctl" "reboot"];
          poweroff = ["systemctl" "poweroff"];
        };
      };
    };
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
    waybar
    wayvnc
    # mate.mate-polkit #TODO: fix polkit not autostarting
    openssl
    wlr-randr
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      (nerdfonts.override {fonts = ["FiraMono"];})
    ];

    fontconfig = {
      enable = true;
      defaultFonts.monospace = ["FiraMono Nerd Font Mono"];
      defaultFonts.serif = ["Noto Serif"];
      defaultFonts.sansSerif = ["Noto Sans"];
    };
  };
}
