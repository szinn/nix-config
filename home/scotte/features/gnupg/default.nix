{ config, pkgs, ... }: {
  config = {
    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      publicKeys = [
        { source = ./scotte-keya.asc; trust = 5; }
        { source = ./scotte-keyb.asc; trust = 5; }
        { source = ./charles-keya.asc; trust = 5; }
      ];
      settings = {
        default-key = "2D13 FA40 E115 2976 8168  33B3 B2F1 677D B034 8B42";
        default-recipient-self = true;
        use-agent = true;
      };
    };
    home.packages = with pkgs; [ pinentry ];
  };
}
