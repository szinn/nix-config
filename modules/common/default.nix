{ config, lib, pkgs, ... }: {
    imports = [
      ./shell
    ];

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      description = "Human readable name of the user";
    };
    homePath = lib.mkOption {
      type = lib.types.path;
      description = "Path of user's home directory.";
      default = builtins.toPath (if pkgs.stdenv.isDarwin then
        "/Users/${config.user}"
      else
        "/home/${config.user}");
    };
  };

  config = {
    services.nix-daemon.enable = true;

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        # warn-dirty = false;
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 2d";
      };
    };


    environment.systemPackages = with pkgs; [
        git
        wget
        curl
    ];

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
    home-manager.users.${config.user}.home.stateVersion = "23.11";

    system.stateVersion = 4;
  };
}
