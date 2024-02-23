{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./editors
    ./security
    ./shell
  ];

  config = {
    home.stateVersion = "23.11";

    programs = {
      home-manager.enable = true;
      git.enable = true;
    };

    xdg.enable = true;
  };
}
