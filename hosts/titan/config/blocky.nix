let
  ads-whitelist = builtins.toFile "ads-whitelist" ''
    t.co
    slackb.com
    keybr.com
    is1-ssl.mzstatic.com
    cc-api-data.adobe.io
    ups.analytics.yahoo.com
  '';

  kubernetes-blacklist = builtins.toFile "kubernetes-blacklist" ''
    www.slack.com
  '';

  sophie-whitelist = builtins.toFile "sophie-whitelist" ''
    assets.adobedtm.com
    elink.clickdimensions.com
    www.googleadservices.com
    fls-na.amazon.ca
    r20.rs6.net
    go.pardot.com
    ssl.google-analytics.com
    notify.bugsnag.com
    click.emm.hermanmiller.com
    ads.google.com
    adwords.google.com
    app-measurement.com
    nexusrules.officeapps.live.com
    clickserve.dartsearch.net
    ad.doubleclick.net
  '';
in {
  ports = {
    dns = "0.0.0.0:5390";
    http = 4000;
  };

  upstreams.groups.default = [
    # Cloudflare
    "tcp-tls:1.1.1.1:853"
    "tcp-tls:1.0.0.1:853"
  ];

  caching.cacheTimeNegative = -1;

  # configuration of client name resolution
  clientLookup = {
    upstream = "127.0.0.1:5391";
    clients = {
      k8s-main = [
        "10.11.0.16"
        "10.11.0.17"
        "10.11.0.18"
        "10.11.0.19"
        "10.11.0.20"
        "10.11.0.21"
      ];
      k8s-staging = [
        "10.12.0.16"
        "10.12.0.17"
        "10.12.0.18"
        "10.12.0.19"
        "10.12.0.20"
        "10.12.0.21"
      ];
      scotte = [
        "10.20.0.32"
        "10.20.0.33"
        "10.20.0.34"
        "10.20.0.35"
        "10.20.0.36"
        "10.20.0.37"
        "10.21.0.2"
        "10.21.0.3"
        "10.21.0.4"
      ];
      sophie = [
        "10.20.0.16"
        "10.20.0.18"
        "10.20.0.19"
        "10.20.0.20"
      ];
    };
  };

  ecs.useAsClient = true;

  prometheus = {
    enable = true;
    path = "/metrics";
  };

  queryLog = {
    type = "console";
    # target = "/tmp";
    # logRetentionDays = 7;
  };

  filtering.queryTypes = ["AAAA"];

  # optional: use these DNS servers to resolve blacklist urls and upstream DNS servers. It is useful if no system DNS resolver is configured, and/or to encrypt the bootstrap queries.
  bootstrapDns = [
    {
      upstream = "https://one.one.one.one/dns-query";
      ips = ["1.1.1.1" "1.0.0.1"];
    }
    {
      upstream = "https://dns.quad9.net/dns-query";
      ips = ["9.9.9.9" "149.112.112.112"];
    }
  ];

  blocking = {
    blockType = "zeroIp";

    loading = {
      refreshPeriod = "4h";

      # optional: if failOnError, application startup will fail if at least one list can't be downloaded / opened. Default: blocking
      strategy = "fast";

      downloads = {
        timeout = "5s";
        attempts = 50;
        cooldown = "5s";
      };
    };

    blackLists = {
      ads = [
        "https://github.com/szinn/k8s-homelab/releases/download/pi-hole/hosts.blacklist"
        "https://blocklistproject.github.io/Lists/ads.txt"
        "https://blocklistproject.github.io/Lists/malware.txt"
      ];
      sophie = [];
      kubernetes = [
        "file://${kubernetes-blacklist}"
      ];
    };

    whiteLists = {
      ads = [
        "file://${ads-whitelist}"
      ];
      sophie = [
        "file://${sophie-whitelist}"
      ];
      kubernetes = [];
    };

    clientGroupsBlock = {
      default = [
        "ads"
      ];
      sophie = [
        "ads"
        "sophie"
      ];
      k8s-main = [
        "kubernetes"
      ];
      k8s-staging = [
        "kubernetes"
      ];
    };
  };
}
