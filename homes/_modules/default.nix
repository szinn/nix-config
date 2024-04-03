{
  inputs,
  config,
  ...
}: {
  imports = [
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
      git.enable = true;
    };

    xdg.enable = true;
  };
}
