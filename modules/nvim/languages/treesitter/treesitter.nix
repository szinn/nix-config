{
  plugins = {
    treesitter = {
      enable = true;
      nixvimInjections = true;
      folding = true;
      settings = {
        indent = {
          enable = true;
        };
      };
    };
  };
}
