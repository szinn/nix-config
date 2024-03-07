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

    which-key = {
      enable = true;

      registrations = {
        "<leader>f" = "Find Files";
        "<leader>a" = "Harpoon Add";
      };
    };
  };
}
