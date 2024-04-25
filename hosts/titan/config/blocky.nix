let
  kubernetes-blacklist = builtins.toFile "kubernetes-blacklist" ''
    slack.com
  '';
  sophie-whitelist =
    builtins.toFile "sophie-whitelist" ''
    '';
in {
  ports = {
    dns = "0.0.0.0:5353";
    http = 4000;
  };
  upstreams.groups.default = [
    # Cloudflare
    "tcp-tls:1.1.1.1:853"
    "tcp-tls:1.0.0.1:853"
  ];

  # configuration of client name resolution
  clientLookup = {
    upstream = "127.0.0.1:5354";
  };

  ecs.useAsClient = true;

  prometheus = {
    enable = true;
    path = "/metrics";
  };

  queryLog = {
    type = "csv";
    target = "/tmp/blocky";
    logRetentionDays = 7;
    flushInterval = "30s";
  };

  blocking = {
    loading.downloads.timeout = "4m";
    blackLists = {
      ads = [
        "https://github.com/szinn/k8s-homelab/releases/download/pi-hole/hosts.blacklist"
      ];
      kubernetes = [
        "file://${kubernetes-blacklist}"
      ];
    };

    whiteLists = {
      sophie = [
        "file://${sophie-whitelist}"
      ];
    };

    clientGroupsBlock = {
      default = [
        "ads"
      ];
      "sophie*" = [
        "ads"
        "sophie"
      ];
      "k8s-*" = [
        "kubernetes"
      ];
    };
  };
}
