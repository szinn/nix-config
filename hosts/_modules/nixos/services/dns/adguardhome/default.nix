{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.services.dns.adguardhome;
  settingsFormat = pkgs.formats.yaml {};
  adguardUser = "adguardhome";
in
  with lib; {
    options.modules.services.dns.adguardhome = {
      enable = mkEnableOption "adguardhome";
      package = mkPackageOption pkgs "adguardhome" {};
      mutableSettings = mkOption {
        type = types.bool;
        default = false;
      };
      passwordPath = mkOption {
        type = types.str;
      };
      host = mkOption {
        default = "0.0.0.0";
        type = types.str;
        description = ''
          Host address to bind HTTP server to.
        '';
      };

      port = mkOption {
        default = 3000;
        type = types.port;
        description = ''
          Port to serve HTTP pages on.
        '';
      };

      settings = mkOption {
        default = null;
        type = types.nullOr (types.submodule {
          freeformType = settingsFormat.type;
          options = {
            schema_version = mkOption {
              default = cfg.package.schema_version;
              defaultText = literalExpression "cfg.package.schema_version";
              type = types.int;
              description = ''
                Schema version for the configuration.
                Defaults to the `schema_version` supplied by `cfg.package`.
              '';
            };
          };
        });
        description = ''
          AdGuard Home configuration. Refer to
          <https://github.com/AdguardTeam/AdGuardHome/wiki/Configuration#configuration-file>
          for details on supported values.

          ::: {.note}
          On start and if {option}`mutableSettings` is `true`,
          these options are merged into the configuration file on start, taking
          precedence over configuration changes made on the web interface.

          Set this to `null` (default) for a non-declarative configuration without any
          Nix-supplied values.
          Declarative configurations are supplied with a default `schema_version`, and `http.address`.
          :::
        '';
      };
    };

    config = mkIf cfg.enable {
      services.adguardhome = {
        enable = true;

        inherit (cfg) host port settings mutableSettings;
      };

      # add user, needed to access the secret
      users.users.${adguardUser} = {
        isSystemUser = true;
        group = adguardUser;
      };
      users.groups.${adguardUser} = {};

      # insert password before service starts
      # password in sops is unencrypted, so we bcrypt it
      # and insert it as per config requirements
      systemd.services.adguardhome = {
        preStart = lib.mkAfter ''
          HASH=$(cat ${cfg.passwordPath} | ${pkgs.apacheHttpd}/bin/htpasswd -niB "" | cut -c 2-)
          ${pkgs.gnused}/bin/sed -i "s,ADGUARDPASS,$HASH," "$STATE_DIRECTORY/AdGuardHome.yaml"
        '';
        serviceConfig.User = adguardUser;
      };
    };
  }
