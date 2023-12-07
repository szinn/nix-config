{ config, pkgs, ... }: {
  config = {
    home.packages = with pkgs; [
      rustup
      sccache
    ];

    home.file.".cargo/config.toml".source = ./cargo.toml;
  };
}
