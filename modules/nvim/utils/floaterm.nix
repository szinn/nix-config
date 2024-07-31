{
  plugins = {
    floaterm = {
      enable = true;

      width = 0.8;
      height = 0.8;

      title = "";

      keymaps.toggle = "<leader>,";
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>,";
        desc = "Toggle float terminal";
      }
    ];
  };
}
