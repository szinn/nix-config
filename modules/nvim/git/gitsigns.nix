{pkgs, ...}: {
  highlight = {
    GitSignsAdd.fg = "#98c379";
    GitSignsChange.fg = "#e5c07b";
    GitSignsDelete.fg = "#e06c75";
  };

  extraConfigLua =
    # lua
    ''
      require('gitsigns').setup{
        signs = {
          add          = { hl = 'GitSignsAdd'   , text = '┃', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
          change       = { hl = 'GitSignsChange', text = '┃', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
          delete       = { hl = 'GitSignsDelete', text = '▁', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn', show_count=true },
          topdelete    = { hl = 'GitSignsDelete', text = '▔', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn', show_count=true },
          changedelete = { hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn', show_count=true },
          untracked    = { hl = 'GitSignsAdd'   , text = '┆', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
        },
        count_chars = {
          [1]   = '₁',
          [2]   = '₂',
          [3]   = '₃',
          [4]   = '₄',
          [5]   = '₅',
          [6]   = '₆',
          [7]   = '₇',
          [8]   = '₈',
          [9]   = '₉',
          ['+'] = '₊',
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }

      require('which-key').register {
        ['<leader>gh'] = {
            name = '[G]itsigns [H]unks',
            _ = 'which_key_ignore'
        },
      }
    '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>ghb";
      action = "<CMD>Gitsigns blame_line<CR>";
      options = {
        silent = true;
        desc = "Blame line";
      };
    }
    {
      mode = "n";
      key = "<leader>ghB";
      action = "<CMD>Gitsigns toggle_current_line_blame<CR>";
      options = {
        silent = true;
        desc = "Toggle Blame Line";
      };
    }
    {
      mode = "n";
      key = "<leader>ghd";
      action = "<CMD>Gitsigns diffthis<CR>";
      options = {
        silent = true;
        desc = "Diff This";
      };
    }
    {
      mode = "n";
      key = "<leader>ghp";
      action = "<CMD>Gitsigns preview_hunk<CR>";
      options = {
        silent = true;
        desc = "Preview Hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>ghR";
      action = "<CMD>Gitsigns reset_buffer<CR>";
      options = {
        silent = true;
        desc = "Reset Buffer";
      };
    }
    {
      mode = ["n" "v"];
      key = "<leader>ghr";
      action = "<CMD>Gitsigns reset_hunk<CR>";
      options = {
        silent = true;
        desc = "Reset Hunk";
      };
    }
    {
      mode = ["n" "v"];
      key = "<leader>ghs";
      action = "<CMD>Gitsigns stage_hunk<CR>";
      options = {
        silent = true;
        desc = "Stage Hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>ghS";
      action = "<CMD>Gitsigns stage_buffer<CR>";
      options = {
        silent = true;
        desc = "Stage Buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>ghu";
      action = "<CMD>Gitsigns undo_stage_hunk<CR>";
      options = {
        silent = true;
        desc = "Undo Stage Hunk";
      };
    }
  ];

  extraPlugins = [
    pkgs.vimPlugins.gitsigns-nvim
  ];
}
