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

  # configuration of client name resolution
  clientLookup = {
    upstream = "127.0.0.1:5391";
    clients = {
      kubernetes = [
        "10.11.0.16"
        "10.11.0.17"
        "10.11.0.18"
        "10.11.0.19"
        "10.11.0.20"
        "10.11.0.21"
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
      ads = [
        "file://${ads-whitelist}"
      ];
      sophie = [
        "file://${sophie-whitelist}"
      ];
    };

    clientGroupsBlock = {
      default = [
        "ads"
        "default-whitelist"
      ];
      sophie = [
        "ads"
        "sophie"
      ];
      kubernetes = [
        "kubernetes"
      ];
    };
  };
}
