{ pkgs, ... }: {
  environment.shells = with pkgs; [ fish ];

  programs = {
    bash = {
      enable = true;
    };
    fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
    zsh = {
      enable = true;
    };
  };
}
