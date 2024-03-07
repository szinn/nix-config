{
  plugins.tagbar = {
    enable = true;
    settings.width = 50;
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-g>";
      action = ":TagbarToggle<cr>";
      options = {
        desc = "Toggle tagbar";
        silent = true;
      };
    }
  ];
}
