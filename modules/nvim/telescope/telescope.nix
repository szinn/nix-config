{
  plugins = {
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        ui-select = {
          enable = true;
          settings = {
            specific_opts = {
              codeactions = true;
            };
          };
        };
        undo = {
          enable = true;
          settings.mappings = {
            i = {
              "<CR>" = "require('telescope-undo.actions').yank_additions";
              "<s-cr>" = "require('telescope-undo.actions').yank_deletions";
              "<c-cr>" = "require('telescope-undo.actions').restore";
            };
            n = {
              "y" = "require('telescope-undo.actions').yank_additions";
              "Y" = "require('telescope-undo.actions').yank_deletions";
              "u" = "require('telescope-undo.actions').restore";
            };
          };
        };
      };
      settings = {
        keymaps = {
          "<leader>sh" = {
            action = "help_tags";
            desc = "[S]earch [H]elp";
          };
          "<leader>sk" = {
            action = "keymaps";
            desc = "[S]earch [K]eymaps";
          };
          "<leader>sf" = {
            action = "find_files";
            desc = "[S]earch [F]iles";
          };
          "<leader>ss" = {
            action = "builtin";
            desc = "[S]earch [S]elect Telescope";
          };
          "<leader>sw" = {
            action = "grep_string";
            desc = "[S]earch Current [W]ord";
          };
          "<leader>sg" = {
            action = "live_grep";
            desc = "[S]earch by [G]rep";
          };
          "<leader>sd" = {
            action = "diagnostics";
            desc = "[S]earch [D]iagnostics";
          };
          "<leader>sr" = {
            action = "resume";
            desc = "[S]earch [R]esume";
          };
          "<leader>s." = {
            action = "oldfiles";
            desc = "[S]earch Recent Files (. for repeat)";
          };
          "<leader><leader>" = {
            action = "buffers";
            desc = "[] Find existing buffers";
          };
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
  };

  extraConfigLua = ''
    require('telescope').setup {
        extensions = {
            ['ui-select'] = {require('telescope.themes').get_dropdown()}
        }
    }

    vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false
        })
    end, {
        desc = '[/] Fuzzily search in current buffer'
    })

    vim.keymap.set('n', '<leader>s/', function()
        require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files'
        }
    end, {
        desc = '[S]earch [/] in Open Files'
    })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
        require('telescope.builtin').find_files {
            cwd = vim.fn.stdpath 'config'
        }
    end, {
        desc = '[S]earch [N]eovim files'
    })
  '';
}
