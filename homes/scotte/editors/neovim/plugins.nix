{
  plugins = {
    gitsigns = {
      enable = true;
      signs = {
        add.text = "+";
        change.text = "~";
      };
    };

    nvim-autopairs.enable = true;

    nvim-colorizer = {
      enable = true;
      userDefaultOptions.names = false;
    };

    oil.enable = true;

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

    lualine = {
      enable = true;

      globalstatus = true;

      # +-------------------------------------------------+
      # | A | B | C                             X | Y | Z |
      # +-------------------------------------------------+
      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch"];
        lualine_c = ["filename" "diff"];

        lualine_x = [
          "diagnostics"

          # Show active language server
          {
            name.__raw = ''
              function()
                  local msg = ""
                  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                  local clients = vim.lsp.get_active_clients()
                  if next(clients) == nil then
                      return msg
                  end
                  for _, client in ipairs(clients) do
                      local filetypes = client.config.filetypes
                      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                          return client.name
                      end
                  end
                  return msg
              end
            '';
            icon = "";
            color.fg = "#ffffff";
          }
          "encoding"
          "fileformat"
          "filetype"
        ];
      };
    };

    lsp = {
      enable = true;

      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>k" = {
            action = "goto_prev";
            desc = "Goto Previous";
          };
          "<leader>j" = {
            action = "goto_next";
            desc = "Goto Next";
          };
        };

        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gD = {
            action = "references";
            desc = "Goto References";
          };
          gt = {
            action = "type_definition";
            desc = "Goto Type Definition";
          };
          gi = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<F2>" = {
            action = "rename";
            desc = "Rename";
          };
        };
      };

      servers = {
        bashls.enable = true;
        gopls.enable = true;
        lua-ls.enable = true;
        nil_ls.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = true;
          installRustc = false;
          settings = {
            cargo.features = "all";
          };
        };
        yamlls.enable = true;
      };
    };

    lsp-format = {
      enable = true;
      lspServersToEnable = [
        "rust-analyzer"
      ];
    };

    neo-tree = {
      enable = true;

      closeIfLastWindow = true;
      window = {
        width = 30;
        autoExpandWidth = true;
      };
    };
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };

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

    treesitter = {
      enable = true;

      nixvimInjections = true;

      folding = true;
      indent = true;
    };

    treesitter-refactor = {
      enable = true;
      highlightDefinitions.enable = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>n";
      action = "<CMD>Neotree action=focus reveal toggle<CR>";
      options = {
        desc = "Neotree";
      };
    }
  ];
}
