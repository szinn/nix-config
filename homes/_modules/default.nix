{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./applications
    ./development
    ./devops
    ./editors
    ./security
    ./shell
  ];

  config = {
    home.stateVersion = "23.11";

    programs = {
      home-manager.enable = true;
      nix-index-database.comma.enable = true;
      git.enable = true;
    };

    xdg.enable = true;
  };
}
