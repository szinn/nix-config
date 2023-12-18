{ config, lib, pkgs, ... }: {
  imports = [
    ./devonthink
    ./fish
    ./git
    ./gnupg
    ./vscode
  ];

  home.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "DejaVuSansMono" "DroidSansMono" ]; }) ];
}
