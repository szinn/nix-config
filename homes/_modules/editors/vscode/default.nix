{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.editors.vscode;

  defaultExtensions = let
    inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace open-vsx;
  in [
  ];
in {
  options.modules.editors.vscode = {
    enable = mkEnableOption "vscode";
    extensions = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    configPath = mkOption {
      type = types.str;
    };
    keybindingsPath = mkOption {
      type = types.str;
    };
    server-enable = mkEnableOption "vscode-server";
  };

  # Point settings.json to configPath
  config = mkMerge [
    (mkIf cfg.enable {
      programs.vscode = {
        enable = true;
        mutableExtensionsDir = true;

        extensions = mkMerge [
          defaultExtensions
          cfg.extensions
        ];
      };
      home.packages = with pkgs; [
        nixpkgs-fmt
      ];
    })
    (mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
      home.file = {
        "Library/Application Support/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink cfg.configPath;
        "Library/Application Support/Code/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink cfg.keybindingsPath;
      };

      programs.fish.shellAliases = {
        code = "/opt/homebrew/bin/code";
      };
    })
    (mkIf cfg.server-enable {
      home.packages = with pkgs; [
        nodejs_21
      ];
    })
  ];
}
