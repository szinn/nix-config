{
  plugins = {
    lsp = {
      enable = true;
      capabilities = "offsetEncoding =  'utf-16'";

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
          # gd = {
          #   action = "definition";
          #   desc = "Goto Definition";
          # };
          # gD = {
          #   action = "references";
          #   desc = "Goto References";
          # };
          # gt = {
          #   action = "type_definition";
          #   desc = "Goto Type Definition";
          # };
          # gi = {
          #   action = "implementation";
          #   desc = "Goto Implementation";
          # };
          # K = {
          #   action = "hover";
          #   desc = "Hover";
          # };
          # "<F2>" = {
          #   action = "rename";
          #   desc = "Rename";
          # };
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
            checkOnSave = true;
            cargo.features = "all";
            check = {
              command = "clippy";
            };
            procMacro = {
              enable = true;
            };
          };
        };
        yamlls.enable = true;
      };
    };
  };

  extraConfigLua = ''
    local _border = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = _border
      }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = _border
      }
    )

    vim.diagnostic.config{
      float={border=_border}
    };

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }
  '';
}
