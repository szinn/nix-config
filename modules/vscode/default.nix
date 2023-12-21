{ username }: args@{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.modules.${username}.vscode;

  defaultExtensions =
    let
      vscode = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
      open-vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx;
      nixpkgs = pkgs.vscode-extensions;
    in
    [
    ];
in
{
  options.modules.${username}.vscode = {
    enable = mkEnableOption "vscode";
    extensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
    configPath = mkOption {
      type = types.str;
    };
  };

  # Point settings.json to configPath
  config = mkIf cfg.enable {
    home-manager.users.${username} = (mkMerge [
      {
        programs.vscode = {
          enable = true;
          package = pkgs.vscode;
          mutableExtensionsDir = true;

          extensions = mkMerge [
            defaultExtensions
            cfg.extensions
          ];
        };
        home.packages = with pkgs; [
          nixpkgs-fmt
        ];
      }
      (mkIf pkgs.stdenv.isDarwin {
        home.file = {
          "Library/Application Support/Code/User/settings.json".source = config.home-manager.users.${username}.lib.file.mkOutOfStoreSymlink cfg.configPath;
        };

        programs.fish.shellAliases = mkIf config.modules.scotte.fish.enable {
          # Prefer to use Homebrew install rather than nix package.
          code = "/opt/homebrew/bin/code";
        };
      })
    ]);
  };
}
