{
  plugins.vim-bbye = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>bd";
      action = "<CMD>Bdelete<CR>";
      options = {
        desc = "[D]elete Buffer";
      };
    }
  ];
}
