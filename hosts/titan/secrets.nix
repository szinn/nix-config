{
  pkgs,
  config,
  ...
}: {
  config = {
    environment.systemPackages = [
      pkgs.sops
      pkgs.age
    ];

    sops = {
      defaultSopsFile = ./secrets.sops.yaml;
      age.sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];

      secrets = {
        # adguardhome-password = {
        #   owner = "adguardhome";
        #   restartUnits = ["adguardhome.service"];
        # };

        # onepassword-credentials = {
        #   mode = "0444";
        # };

        "networking/cloudflare/api-token" = {
          restartUnits = ["cloudflare-dyndns.service"];
        };

        # "gatus/config.yaml" = {
        #   restartUnits = ["gatus.service"];
        #   owner = "gatus";
        # };

        # "networking/bind/rndc-key" = {
        #   restartUnits = ["bind.service"];
        #   owner = config.users.users.named.name;
        # };
        # "networking/bind/externaldns-key" = {
        #   restartUnits = ["bind.service"];
        #   owner = config.users.users.named.name;
        # };
        # "networking/bind/zones/1.168.192.in-addr.arpa" = {
        #   restartUnits = ["bind.service"];
        #   owner = config.users.users.named.name;
        # };
        # "networking/bind/zones/10.in-addr.arpa" = {
        #   restartUnits = ["bind.service"];
        #   owner = config.users.users.named.name;
        # };
        # "networking/bind/zones/test.zinn.ca" = {
        #   restartUnits = ["bind.service"];
        #   owner = config.users.users.named.name;
        # };
        # "networking/bind/zones/zinn.ca" = {
        #   restartUnits = ["bind.service"];
        #   owner = config.users.users.named.name;
        # };
        # "networking/bind/zones/zinn.tech" = {
        #   restartUnits = ["bind.service"];
        #   owner = config.users.users.named.name;
        # };
      };
    };
  };
}
