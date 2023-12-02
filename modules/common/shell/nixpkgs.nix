{ config, pkgs, ... }: {
  home-manager.users.${config.user} = {
    # programs.nix-index = {
    #   enable = true;
    #   enableFishIntegration = true;
    # };
  };
}
