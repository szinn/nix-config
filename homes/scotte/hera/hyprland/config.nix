{...}: {
  wayland.windowManager.hyprland.settings = {
    exec-once = "/nix/store/h3zv7932ymvq41z7dh92v02h9pmnb583-dbus-1.14.10/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP & systemctl --user restart hyprland-session.target & waybar & wayvnc 0.0.0.0 & alacritty";
    "monitor" = "HDMI-A-1,1920x1080@50,0x0,1";

    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
    ];

    general = {
      border_size = 0;
      no_border_on_floating = true;
      gaps_in = 5;
      gaps_out = 0;
      #col.inactive_border = rgba(595959aa)
      #col.active_border = rgba(999999aa)
      layout = "master";
      #layout = dwindle
      #layout = nstack
      #layout = hy3
      resize_on_border = true;
    };

    "$mainMod" = "SUPER";

    bind = [
      "$mainMod, Return, exec, alacritty"
      "$mainMod, d, exec, rofi -show drun"
      "$mainMod, g, exec, firefox"
      "$mainMod, t, exec, tmux"
      "$mainMod, v, exec, nvim"

      # Switch workspaces with mod key + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod, F1, workspace, 11"
      "$mainMod, F2, workspace, 12"
      "$mainMod, F3, workspace, 13"
      "$mainMod, F4, workspace, 14"
      "$mainMod, F5, workspace, 15"
      "$mainMod, F6, workspace, 16"
      "$mainMod, F7, workspace, 17"
      "$mainMod, F8, workspace, 18"
      "$mainMod, F9, workspace, 19"
      "$mainMod, F10, workspace, 20"
      "$mainMod, F11, workspace, 21"
      "$mainMod, F12, workspace, 22"

      # Move active window to a workspace with mod key + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
      "$mainMod SHIFT, F1, movetoworkspacesilent, 11"
      "$mainMod SHIFT, F2, movetoworkspacesilent, 12"
      "$mainMod SHIFT, F3, movetoworkspacesilent, 13"
      "$mainMod SHIFT, F4, movetoworkspacesilent, 14"
      "$mainMod SHIFT, F5, movetoworkspacesilent, 15"
      "$mainMod SHIFT, F6, movetoworkspacesilent, 16"
      "$mainMod SHIFT, F7, movetoworkspacesilent, 17"
      "$mainMod SHIFT, F8, movetoworkspacesilent, 18"
      "$mainMod SHIFT, F9, movetoworkspacesilent, 19"
      "$mainMod SHIFT, F10, movetoworkspacesilent, 20"
      "$mainMod SHIFT, F11, movetoworkspacesilent, 21"
      "$mainMod SHIFT, F12, movetoworkspacesilent, 22"

      # Scroll through existing workspaces with mod key + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];
  };
}
