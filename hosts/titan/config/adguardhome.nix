{lib, ...}: let
  port_dns = 53;
  yaml_schema_version = 28;
in {
  schema_version = yaml_schema_version;

  dhcp.enabled = false;

  users = [
    {
      name = "admin";
      password = "ADGUARDPASS"; # placeholder, real one inserted on service start
    }
  ];

  log = {
    verbose = false;
  };

  auth_attempts = 3;
  block_auth_min = 3600;

  clients = {
    persistent = let
      clients = [
        {
          name = "Scotte";
          ids = [
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
          tags = [
            "user_admin"
          ];
        }
        {
          name = "Sophie";
          ids = [
            "10.20.0.16"
            "10.20.0.18"
            "10.20.0.19"
            "10.20.0.20"
          ];
          tags = [
            "user_regular"
          ];
        }
        {
          name = "k8s-main";
          ids = [
            "10.11.0.16"
            "10.11.0.17"
            "10.11.0.18"
            "10.11.0.19"
            "10.11.0.20"
            "10.11.0.21"
          ];
          tags = [
            "user_regular"
          ];
        }
        {
          name = "k8s-staging";
          ids = [
            "10.12.0.16"
            "10.12.0.17"
            "10.12.0.18"
            "10.12.0.19"
            "10.12.0.20"
            "10.12.0.21"
          ];
          tags = [
            "user_regular"
          ];
        }
      ];

      buildClient = info: {
        inherit (info) name ids tags;

        use_global_settings = true;
        filtering_enabled = true;
        safe_search.enabled = false;
        blocked_services.schedule.time_zone = "Local";
      };
    in
      map buildClient clients;
  };

  dns = {
    # dns server bind deets
    bind_host = "0.0.0.0";
    port = port_dns;

    aaaa_disabled = true;
    protection_enabled = true;
    filtering_enabled = true;

    # bootstrap DNS - used for resolving upstream dns deets
    bootstrap_dns = [
      # cloudflare
      "1.1.1.1"
      "1.0.0.1"
      # quad9
      "9.9.9.9"
    ];

    # upstream DNS
    upstream_dns = [
      # Bind
      # "[/zinn.ca/]127.0.0.1:5391"
      # "[/zinn.tech/]127.0.0.1:5391"
      # "[/10.in-addr.arpa/]127.0.0.1:5391"
      # "[/1.168.192.in-addr.arpa/]127.0.0.1:5391"

      # UniFi
      "[/zinn.ca/]10.0.0.1:53"
      "[/zinn.tech/]10.0.0.1:53"
      "[/10.in-addr.arpa/]10.0.0.1:53"
      "[/1.168.192.in-addr.arpa/]10.0.0.1:53"

      "https://dns.cloudflare.com/dns-query"
      "https://dns.quad9.net/dns-query"
    ];

    # resolving local addresses
    local_ptr_upstreams = [
      # "127.0.0.1:5391"
      "10.0.0.1:53"
    ];
    use_private_ptr_resolvers = true;
    edns_client_subnet = {
      custom_ip = "";
      enabled = true;
      use_custom = false;
    };

    # security
    enable_dnssec = true;

    # local cache settings
    cache_size = 100000000; # 100MB - unnessecary but hey
    cache_ttl_min = 30;
    cache_ttl_max = 60;
    cache_optimistic = true;

    # rate limiting
    ratelimit = 200;

    theme = "auto";
  };

  filters = let
    urls = [
      {
        name = "Scotte's list";
        url = "https://github.com/szinn/k8s-homelab/releases/download/adguard/hosts-adguard.blacklist";
      }
      {
        name = "AdGuard DNS filter";
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
      }
      {
        name = "BlockListProject - Malware List";
        url = "https://blocklistproject.github.io/Lists/adguard/malware-ags.txt";
      }
      {
        name = "1Hosts Lite";
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_24.txt";
      }
      {
        name = "phishing army";
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt";
      }
      {
        name = "hagezi multi pro";
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_48.txt";
      }
      {
        name = "Big OSID";
        url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt";
      }
      {
        name = "Local Custom list";
        url = "https://raw.githubusercontent.com/szinn/nix-config/main/hosts/titan/config/local-custom-filter.txt";
      }
    ];

    buildList = id: url: {
      enabled = true;
      inherit id;
      inherit (url) name;
      inherit (url) url;
    };
  in
    lib.imap1 buildList urls;
}
