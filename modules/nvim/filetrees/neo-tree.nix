{
  lib,
  config,
  ...
}: let
  cfg = config.plugins.neo-tree;
in {
  plugins.neo-tree = {
    enable = true;
    enableDiagnostics = true;
    enableGitStatus = true;
    enableModifiedMarkers = true;
    enableRefreshOnWrite = true;
    closeIfLastWindow = true;
    popupBorderStyle = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
    buffers = {
      bindToCwd = false;
      followCurrentFile = {
        enabled = true;
      };
    };
    window = {
      width = 40;
      height = 15;
      autoExpandWidth = false;
      mappings = {
        "<space>" = "none";
      };
    };
  };

  keymaps = lib.mkIf cfg.enable [
    {
      mode = "n";
      key = "<leader>n";
      action = "<CMD>Neotree action=focus reveal toggle<CR>";
      options = {
        desc = "Neotree";
      };
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "<CMD>Neotree action=focus reveal<CR>";
      options = {
        desc = "Neotree";
      };
    }
  ];
}
