{ config, pkgs, lib, ... }: {
  config = {
    home.file.".psqlrc".source = ./psqlrc;
  };
}
