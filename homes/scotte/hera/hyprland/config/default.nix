{
  inputs,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."hypr/hyprland.conf" = {
    text =
      lib.mkForce
      (''
          exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all && systemctl --user restart hyprland-session.target
        ''
        + builtins.readFile ./hyprland.conf);
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
}
