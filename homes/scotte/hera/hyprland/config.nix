{...}: {
  wayland.windowManager.hyprland.settings = {
    exec-once = "/nix/store/h3zv7932ymvq41z7dh92v02h9pmnb583-dbus-1.14.10/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP & systemctl --user stop hyprland-session.target & systemctl --user start hyprland-session.target & waybar & wayvnc 0.0.0.0 & alacritty";

    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
    ];

    "$mainMod" = "SUPER";

    bind = [
      "$mainMod, g, exec, foot -e firefox"
      "$mainMod, t, exec, foot -e tmux"
      "$mainMod, v, exec, foot -e nvim"
    ];
  };
}
