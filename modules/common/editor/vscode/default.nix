{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.modules.vscode;

  jsonFormat = pkgs.formats.json { };
  
  vscode-extensions = (import ./extensions.nix){ pkgs = pkgs; };
  userDir = "${config.homePath}/Library/Application Support/Code/User";
  configFilePath = "${userDir}/settings.json";
  defaultConfig = builtins.fromJSON (builtins.readFile ./settings.json);

  defaultExtensions = with pkgs.vscode-extensions; [
    tamasfe.even-better-toml
  ];
in {
  options.modules.vscode = {
    enable = mkEnableOption "VSCode";
    package = mkPackageOption pkgs "vscode" { };
    extensions = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    config = mkOption {
      type = jsonFormat.type;
      default = { };
    };
  };

  config.home-manager.users.${config.user} = { lib, ... }: mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = cfg.package;
      mutableExtensionsDir = true;

      extensions = mkMerge [
        defaultExtensions
        cfg.extensions
      ];

      # userSettings = defaultConfig;
      userSettings = mkMerge [
        defaultConfig
        cfg.config
      ];
    };

    home = {
      activation = {
        removeExistingVSCodeSettings = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
          rm -rf "${configFilePath}"
        '';

        overwriteVSCodeSymlink = let
          userSettings = config.home-manager.users.${config.user}.programs.vscode.userSettings;
          jsonSettings = pkgs.writeText "tmp_vscode_settings" (builtins.toJSON userSettings);
        in lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          rm -rf "${configFilePath}"

          cat ${jsonSettings} | ${pkgs.jq}/bin/jq --monochrome-output > "${configFilePath}"
        '';
      };
    };
  };
}
