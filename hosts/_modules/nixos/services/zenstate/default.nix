{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.zenstate;
  disable-c6 = pkgs.writeScript "disable-c6" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.kmod}/bin/modprobe msr
    ${pkgs.zenstates}/bin/zenstates --c6-disable
  '';
in {
  options.modules.services.zenstate.enable = mkEnableOption "zenstate";

  config = mkIf cfg.enable {
    systemd.services.disable-c6 = {
      description = "Disable C6 state";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${disable-c6}";
      };
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
    };
  };
}
