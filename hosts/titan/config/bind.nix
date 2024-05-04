# Only define the known VLAN subnets as trusted
{config, ...}: let
  db-zinn-tech = ./zones/db.zinn.tech;
  db-test-zinn-ca = ./zones/db.test.zinn.tech;
  db-zinn-ca = ./zones/db.zinn.ca;
  db-10-in-addr-arpa = ./zones/db.10.in-addr.arpa;
  db-1-168-192-in-addr-arpa = ./zones/db/1.168.192.in-addr.arpa;
in ''
  include "${config.sops.secrets."networking/bind/rndc-key".path}";
  include "${config.sops.secrets."networking/bind/externaldns-key".path}";
  controls {
    inet 127.0.0.1 allow { localhost; } keys { "rndc-key"; };
  };

  acl "trusted" {
    10.0.0.0/16;     # LAN/SERVICES
    10.10.0.0/16;    # SERVERS
    10.11.0.0/16;    # HOMELAB
    10.12.0.0/16;    # STAGING
    10.20.0.0/16;    # TRUSTED
    10.21.0.0/16;    # WIREGUARD
    10.88.0.0/24;    # PODMAN
    192.168.1.0/24;  # IOT
    192.168.2.0/24;  # GUEST
  };
  acl badnetworks {  };

  options {
    listen-on port 5391 { any; };
    directory "${config.services.bind.directory}";
    pid-file "${config.services.bind.directory}/named.pid";

    allow-recursion { trusted; };
    allow-transfer { none; };
    allow-update { none; };
    blackhole { badnetworks; };
    dnssec-validation auto;
  };

  logging {
    channel stdout {
      stderr;
      severity info;
      print-category yes;
      print-severity yes;
      print-time yes;
    };
    category security { stdout; };
    category dnssec   { stdout; };
    category default  { stdout; };
  };

  zone "zinn.tech." {
    type master;
    file "${config.sops.secrets."networking/bind/zones/zinn.tech".path}";
    journal "${config.services.bind.directory}/db.zinn.tech.jnl";
    allow-transfer {
      key "externaldns";
    };
    update-policy {
      grant externaldns zonesub ANY;
    };
  };

  zone "test.zinn.ca." {
    type master;
    file "${config.sops.secrets."networking/bind/zones/test.zinn.ca".path}";
    journal "${config.services.bind.directory}/db.test.zinn.ca.jnl";
    allow-transfer {
      key "externaldns";
    };
    update-policy {
      grant externaldns zonesub ANY;
    };
  };

  zone "zinn.ca." {
    type master;
    file "${config.sops.secrets."networking/bind/zones/zinn.ca".path}";
    journal "${config.services.bind.directory}/db.zinn.ca.jnl";
    allow-transfer {
      key "externaldns";
    };
    update-policy {
      grant externaldns zonesub ANY;
    };
  };

  zone "10.in-addr.arpa." {
    type master;
    file "${config.sops.secrets."networking/bind/zones/10.in-addr.arpa".path}";
  };

  zone "1.168.192.in-addr.arpa." {
    type master;
    file "${config.sops.secrets."networking/bind/zones/1.168.192.in-addr.arpa".path}";
  };
''
