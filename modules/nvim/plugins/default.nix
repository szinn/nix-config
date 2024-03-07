{
  imports = [
    ./harpoon.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    ./telescope.nix
    ./treesitter.nix
  ];

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
  };
}
