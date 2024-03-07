{
  plugins = {
    floaterm = {
      enable = true;

      width = 0.8;
      height = 0.8;

      title = "";

      keymaps.toggle = "<leader>,";
    };

    which-key.registrations = {
      "<leader>," = "Toggle float terminal";
    };
  };
}
