{pkgs, ...}: {
  imports = [
    ./config.nix
    ./waybar
  ];

  wayland.windowManager.hyprland.enable = true;
  programs.waybar.enable = true;

  # gtk = {
  #   enable = true;
  #   gtk.cursorTheme.name = "Adwaita";
  #   gtk.cursorTheme.package = pkgs.gnome.adwaita-icon-theme;
  #   gtk.theme.name = "adw-gtk3-dark";
  #   gtk.theme.package = pkgs.adw-gtk3;
  # };
}
