{
  plugins = {
    floaterm = {
      enable = true;
      settings = {
        width = 0.8;
        height = 0.8;
        title = "";
        keymap_toggle = "<leader>,";
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>,";
        desc = "Toggle float terminal";
      }
    ];
  };
}
