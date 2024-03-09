{
  plugins.tagbar = {
    enable = true;
    settings.width = 50;
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-g>";
      action = ":TagbarToggle<CR>";
      options = {
        desc = "Toggle tagbar";
        silent = true;
      };
    }
  ];
}
