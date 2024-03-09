{
  lib,
  config,
  ...
}: let
  cfg = config.plugins.bufferline;
in {
  plugins = {
    bufferline = {
      enable = true;
      separatorStyle = "thick"; # “slant”, “padded_slant”, “slope”, “padded_slope”, “thick”, “thin”
      offsets = [
        {
          filetype = "neo-tree";
          text = "Neo-tree";
          highlight = "Directory";
          text_align = "left";
        }
      ];
    };
  };

  extraConfigLua = lib.mkIf cfg.enable ''
    require('which-key').register {
      ['<leader>b'] = {
          name = '[B]uffer',
          _ = 'which_key_ignore'
      },
    }
  '';

  keymaps = lib.mkIf cfg.enable [
    {
      mode = "n";
      key = "<Tab>";
      action = "<CMD>BufferLineCycleNext<CR>";
      options = {
        desc = "Cycle to next buffer";
      };
    }

    {
      mode = "n";
      key = "<S-Tab>";
      action = "<CMD>BufferLineCyclePrev<CR>";
      options = {
        desc = "Cycle to previous buffer";
      };
    }

    {
      mode = "n";
      key = "<S-l>";
      action = "<CMD>BufferLineCycleNext<CR>";
      options = {
        desc = "Cycle to next buffer";
      };
    }

    {
      mode = "n";
      key = "<S-h>";
      action = "<CMD>BufferLineCyclePrev<CR>";
      options = {
        desc = "Cycle to previous buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>bd";
      action = "<CMD>bdelete<CR>";
      options = {
        desc = "[D]elete Buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>bb";
      action = "<CMD>e #<CR>";
      options = {
        desc = "Switch to Other [B]uffer";
      };
    }

    # {
    #   mode = "n";
    #   key = "<leader>`";
    #   action = "<CMD>e #<CR>";
    #   options = {
    #     desc = "Switch to Other Buffer";
    #   };
    # }

    {
      mode = "n";
      key = "<leader>br";
      action = "<CMD>BufferLineCloseRight<CR>";
      options = {
        desc = "Delete Buffers to the [R]ight";
      };
    }

    {
      mode = "n";
      key = "<leader>bl";
      action = "<CMD>BufferLineCloseLeft<CR>";
      options = {
        desc = "Delete Buffers to the [L]eft";
      };
    }

    {
      mode = "n";
      key = "<leader>bo";
      action = "<CMD>BufferLineCloseOthers<CR>";
      options = {
        desc = "Delete [O]ther Buffers";
      };
    }

    {
      mode = "n";
      key = "<leader>bp";
      action = "<CMD>BufferLineTogglePin<CR>";
      options = {
        desc = "Toggle Buffer [P]in";
      };
    }

    {
      mode = "n";
      key = "<leader>bP";
      action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
      options = {
        desc = "Delete Non-[P]inned Buffers";
      };
    }
  ];
}
