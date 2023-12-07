{ config, pkgs, lib, ... }: {
  config = {
    programs.git = {
      extraConfig = {
        credential = { helper = "osxkeychain"; };
      };
    };
  };
}
