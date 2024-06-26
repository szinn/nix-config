{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.devops;
in {
  config = mkIf cfg.enable {
    programs.k9s = {
      enable = true;
      package = pkgs.k9s;

      aliases = {
        aliases = {
          dp = "deployments";
          sec = "v1/secrets";
          jo = "jobs";
          cr = "clusterroles";
          crb = "clusterrolebindings";
          ro = "roles";
          rb = "rolebindings";
          np = "networkpolicies";
        };
      };

      settings = {
        k9s = {
          liveViewAutoRefresh = false;
          refreshRate = 2;
          maxConnRetry = 5;
          readOnly = false;
          noExitOnCtrlC = false;
          ui = {
            # skin = "catppuccin-macchiato";
            enableMouse = false;
            headless = false;
            logoless = false;
            crumbsless = false;
            reactive = false;
            noIcons = false;
          };
          skipLatestRevCheck = false;
          disablePodCounting = false;
          shellPod = {
            image = "busybox:1.35.0";
            namespace = "default";
            limits = {
              cpu = "100m";
            };
          };
          imageScans = {
            enable = false;
            exclusions = {
              namespaces = [];
              labels = {};
            };
          };
          logger = {
            tail = 100;
            buffer = 5000;
            sinceSeconds = -1;
            fullScreen = false;
            textWrap = false;
            showTime = false;
          };
          thresholds = {
            cpu = {
              critical = 90;
              warn = 70;
            };
            memory = {
              critical = 90;
              warn = 70;
            };
          };
        };
      };
    };
  };
}
