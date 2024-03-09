{
  lib,
  config,
  ...
}: let
  cfg = config.plugins.trouble;
in {
  plugins.trouble = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<CMD>TroubleToggle<CR>";
      options = {
        desc = "Toggle Trouble";
      };
    }
    {
      mode = "n";
      key = "<leader>xw";
      action = "<CMD>TroubleToggle workspace_diagnostics<CR>";
      options = {
        desc = "Trouble [W]orkspace Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>xd";
      action = "<CMD>TroubleToggle document_diagnostics<CR>";
      options = {
        desc = "Trouble [D]ocument Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<CMD>TroubleToggle quickfix<CR>";
      options = {
        desc = "Trouble [Q]uick Fix";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<CMD>TroubleToggle loclist<CR>";
      options = {
        desc = "Trouble Toggle [L]ocList";
      };
    }
    {
      mode = "n";
      key = "xr";
      action = "<CMD>TroubleToggle lsp_references<CR>";
      options = {
        desc = "Trouble LSP [R]eferences";
      };
    }
  ];

  extraConfigLua = lib.mkIf cfg.enable ''
    require('which-key').register {
      ['<leader>x'] = {
          name = 'Trouble',
          _ = 'which_key_ignore'
      },
    }
  '';
}
