{
  plugins = {
    harpoon = {
      enable = true;

      keymapsSilent = true;

      keymaps = {
        addFile = "<leader>a";
        toggleQuickMenu = "<C-e>";
        navFile = {
          "1" = "<C-j>";
          "2" = "<C-k>";
          "3" = "<C-l>";
          "4" = "<C-m>";
        };
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>a";
        desc = "Harpoon Add";
      }
    ];
  };
}
