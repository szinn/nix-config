{
  config,
  pkgs,
  ...
}: {
  modules = {
    services = {
      ntp.chrony = {
        enable = true;
        servers = [
          "0.ca.pool.ntp.org"
          "1.ca.pool.ntp.org"
          "2.ca.pool.ntp.org"
          "3.ca.pool.ntp.org"
        ];
      };

      dns = {
        cloudflare-dyndns = {
          enable = true;
          apiTokenFile = config.sops.secrets."networking/cloudflare/api-token".path;
          domains = ["zinn.tech" "vpn.zinn.tech"];
        };

        dnsdist = {
          enable = true;
          config = builtins.readFile ./config/dnsdist.conf;
        };

        bind = {
          enable = true;
          config = import ./config/bind.nix {inherit config;};
        };

        blocky = {
          enable = true;
          package = pkgs.blocky;
          config = import ./config/blocky.nix;
        };
      };

      security = {
        openssh.enable = true;
        onepassword-connect = {
          enable = true;
          credentialsFile = config.sops.secrets.onepassword-credentials.path;
          port = 8438;
        };
      };
    };
  };
}
