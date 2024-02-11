{ username }: args@{ pkgs, lib, config, inputs, ... }:
with lib;
let
  cfg = config.modules.${username}.editor.vscode;

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
  options.modules.${username}.editor.vscode = {
    enable = mkEnableOption "vscode";
    extensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
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
            "Library/Application Support/Code/User/keybindings.json".source = config.home-manager.users.${username}.lib.file.mkOutOfStoreSymlink cfg.keybindingsPath;
          };

          programs.fish.shellAliases = mkIf config.modules.scotte.shell.fish.enable {
            # Prefer to use Homebrew install rather than nix package.
            code = "/opt/homebrew/bin/code";
          };
        })
      ]);
    })
    (mkIf cfg.server-enable {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          nodejs_21
        ];
      };
    })
  ];
}
