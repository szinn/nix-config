{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.zenstate;
  before-sleep = pkgs.writeScript "before-sleep" ''
    #!${pkgs.bash}/bin/bash
    modprobe msr
    ${pkgs.zenstates}/bin/zenstates --c6-disable
  '';
in {
  options.modules.services.zenstate.enable = mkEnableOption "zenstate";

  config = mkIf cfg.enable {
    systemd.services.before-sleep = {
      description = "Jobs to run before going to sleep";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${before-sleep}";
      };
      wantedBy = ["multi-user.target"];
      # before = ["sleep.target"];
    };
  };
}
