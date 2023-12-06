{ inputs, outputs, lib, ... }: {
  imports = [
    ./global
    {
      home = {
        username = "scotte";
        homeDirectory = lib.mkDefault "/Users/scotte";
        stateVersion = "23.11";
        sessionPath = [ "$HOME/.local/bin" ];
      };
    }
  ];
}
