{
  plugins.trouble = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>TroubleToggle<cr>";
      options = {
        desc = "Toggle Trouble";
      };
    }
    {
      mode = "n";
      key = "<leader>xw";
      action = "<cmd>TroubleToggle workspace_diagnostics<cr>";
      options = {
        desc = "Trouble Workspace Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>xd";
      action = "<cmd>TroubleToggle document_diagnostics<cr>";
      options = {
        desc = "Trouble Document Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>TroubleToggle quickfix<cr>";
      options = {
        desc = "Trouble Quick Fix";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>TroubleToggle loclist<cr>";
      options = {
        desc = "Trouble Toggle LocList";
      };
    }
    {
      mode = "n";
      key = "gR";
      action = "<cmd>TroubleToggle lsp_references<cr>";
      options = {
        desc = "Trouble LSP References";
      };
    }
  ];
}
