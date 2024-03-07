{
  keymaps = [
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

  plugins.neo-tree = {
    enable = true;

    closeIfLastWindow = true;
    window = {
      width = 30;
      autoExpandWidth = true;
    };
  };
}
