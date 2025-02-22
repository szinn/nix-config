{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.security.openssh;
in {
  options.modules.services.security.openssh = {
    enable = mkEnableOption "openssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      # Don't allow home-directory authorized_keys
      authorizedKeysFiles = lib.mkForce ["/etc/ssh/authorized_keys.d/%u"];
      settings = {
        # Harden
        PasswordAuthentication = false;
        PermitRootLogin = "yes";
        # Automatically remove stale sockets
        StreamLocalBindUnlink = "yes";
        # Allow forwarding ports to everywhere
        GatewayPorts = "clientspecified";
      };
    };

    security.pam.sshAgentAuth = {
      # Passwordless sudo when SSH'ing with keys
      enable = true;
      authorizedKeysFiles = [
        "/etc/ssh/authorized_keys.d/%u"
      ];
    };
  };
}
