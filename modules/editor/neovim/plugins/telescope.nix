{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      keymaps = {
        # Find files using Telescope command-line sugar.
        "<leader>ff" = {
          action = "find_files";
          desc = "Find File";
        };
        "<leader>fg" = {
          action = "live_grep";
          desc = "Live Grep";
        };
        "<leader>b" = {
          action = "buffers";
          desc = "Find Buffer";
        };
        "<leader>fh" = {
          action = "help_tags";
          desc = "Help tags";
        };
        "<leader>fd" = {
          action = "diagnostics";
          desc = "Diagnostics";
        };

        # FZF like bindings
        "<C-p>" = "git_files";
        "<leader>p" = {
          action = "oldfiles";
          desc = "Find Old File";
        };
        "<C-f>" = "live_grep";
      };

      keymapsSilent = true;

      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
      };
    };
  };
}
