{
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
        desc = "Trouble Workspace Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>xd";
      action = "<CMD>TroubleToggle document_diagnostics<CR>";
      options = {
        desc = "Trouble Document Diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<CMD>TroubleToggle quickfix<CR>";
      options = {
        desc = "Trouble Quick Fix";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<CMD>TroubleToggle loclist<CR>";
      options = {
        desc = "Trouble Toggle LocList";
      };
    }
    {
      mode = "n";
      key = "gR";
      action = "<CMD>TroubleToggle lsp_references<CR>";
      options = {
        desc = "Trouble LSP References";
      };
    }
  ];
}
