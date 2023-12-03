{ config, pkgs, ... }: {
  home-manager.users.${config.user} = {
    # programs.nix-index = {
    #   enable = true;
    #   enableFishIntegration = true;
    # };
  };
  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];
  };
}
