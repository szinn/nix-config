{ config, inputs, lib, ... }:
with lib;
let cfg = config.modules.services.openssh;
in {
  options.modules.services.openssh = {
    enable = mkEnableOption "openssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        # Harden
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        # Automatically remove stale sockets
        StreamLocalBindUnlink = "yes";
        # Allow forwarding ports to everywhere
        GatewayPorts = "clientspecified";
      };
    };

    security = {
      # Passwordless sudo when SSH'ing with keys
      pam.enableSSHAgentAuth = true;
    };
  };
}
