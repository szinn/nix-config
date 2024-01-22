{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.modules.services.rustdesk-server;
in
{
  options.modules.services.rustdesk-server = {
    enable = mkEnableOption "rustdesk-server";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rustdesk-server
    ];

    # networking.firewall = {
    #   # 8000 = Rustdesk?
    #   # 21115-21117 = Rustdesk  https://rustdesk.com/docs/en/self-host/
    #   # 21118 and 21119 = Rustdesk Web Client
    #   allowedUDPPorts = [ 22 21116 ... ];
    #   allowedTCPPorts = [ 22 8000 21115 21116 21117 21118 21119 ... ];
    # };

    systemd.tmpfiles.rules = [
      "d /opt/rustdesk 0700 root root"
      "d /var/log/rustdesk 0700 root root"
      # optional (only for [Erase Your Darlings](https://grahamc.com/blog/erase-your-darlings) or [tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) setups):
      # "L /opt/rustdesk/db_v2.sqlite3 - - - - /persist/opt/rustdesk/db_v2.sqlite3"
      # "L /opt/rustdesk/db_v2.sqlite3-shm - - - - /persist/opt/rustdesk/db_v2.sqlite3-shm"
      # "L /opt/rustdesk/db_v2.sqlite3-wal - - - - /persist/opt/rustdesk/db_v2.sqlite3-wal"
      # "L /opt/rustdesk/id_ed25519 - - - - /persist/opt/rustdesk/id_ed25519"
      # "L /opt/rustdesk/id_ed25519.pub - - - - /persist/opt/rustdesk/id_ed25519.pub"
    ];

    systemd.services.rustdesksignal = {
      description = "Rustdesk Signal Server (hbbs)";
      documentation = [ 
        "https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/install/"
        "https://github.com/techahold/rustdeskinstall/blob/43df6297a9b8b5ff0f3e05ec4bd6e0f4c7281f88/install.sh"
      ];
      after = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      partOf = [ "rustdeskrelay.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        LimitNOFILE=1000000;
        WorkingDirectory="/opt/rustdesk";
        StandardOutput="append:/var/log/rustdesk/hbbs.log";
        StandardError="append:/var/log/rustdesk/hbbs.error";
        ExecStart="${pkgs.rustdesk-server}/bin/hbbs -k _";
        Restart="always";
        RestartSec=10;
      };
      #script = with pkgs; ''
      #'';
    };

    systemd.services.rustdeskrelay = {
      description = "Rustdesk Relay Server (hbbr)";
      documentation = [ 
        "https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/install/"
        "https://github.com/techahold/rustdeskinstall/blob/43df6297a9b8b5ff0f3e05ec4bd6e0f4c7281f88/install.sh"
      ];
      after = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      partOf = [ "rustdesksignal.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        LimitNOFILE=1000000;
        WorkingDirectory="/opt/rustdesk";
        StandardOutput="append:/var/log/rustdesk/hbbr.log";
        StandardError="append:/var/log/rustdesk/hbbr.error";
        ExecStart="${pkgs.rustdesk-server}/bin/hbbr -k _";
        Restart="always";
        RestartSec=10;
      };
      #script = with pkgs; ''
      #'';
    };
  };
}
