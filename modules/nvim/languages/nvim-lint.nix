{
  plugins.lint = {
    enable = true;
    lintersByFt = {
      json = ["jsonlint"];
      lua = ["selene"];
      nix = ["statix"];
      # java = ["checkstyle"];
      # javascript = ["eslint_d"];
      # javascriptreact = ["eslint_d"];
      # python = ["flake8"];
      # typescript = ["eslint_d"];
      # typescriptreact = ["eslint_d"];
    };
  };
}
