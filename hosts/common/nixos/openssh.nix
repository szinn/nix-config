{ config, inputs, ... }:
{
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
}
