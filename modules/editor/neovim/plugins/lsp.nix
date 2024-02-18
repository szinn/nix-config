{
  programs.nixvim = {
    plugins = {
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
    };
  };
}
