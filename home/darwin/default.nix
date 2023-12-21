{ config, lib, pkgs, ... }: {
  imports = [
    ./devonthink
    ./gnupg
    ./vscode
  ];

  home.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "DejaVuSansMono" "DroidSansMono" ]; }) ];
}
