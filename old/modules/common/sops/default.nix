{lib, pkgs, config, inputs, ... }:
with lib;
let
  cfg = config.modules.sops;
in {
  options.modules.sops = {
    enable = mkEnableOption "SOPS";
    defaultSopsFile = mkOption {
      type = types.path;
    };
    secrets = mkOption {
      type = types.attrs;
      default = {};
    };
    ageKeyFile = mkOption {
      type = types.str;
      default = "${config.home-manager.users.${config.user}.xdg.configHome}/age/keys.txt";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home-manager.users.${config.user} = {
        imports = [
          inputs.sops-nix.homeManagerModules.sops
        ];

        home.packages = with pkgs; [
          sops
          age
        ];

        sops = {
          defaultSopsFile = cfg.defaultSopsFile;
          age.keyFile = cfg.ageKeyFile;
          secrets = cfg.secrets;
        };

        home.sessionVariables = {
          SOPS_AGE_KEY_FILE = cfg.ageKeyFile;
        };
      };
    })
  ];
}
