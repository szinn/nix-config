{
  imports = [
    ./harpoon.nix
    ./keys.nix
    ./lualine.nix
    ./lsp.nix
    ./neo-tree.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  programs.nixvim = {
    colorschemes = {
      tokyonight = {
        enable = true;
        style = "night";
      };
    };

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
  };
}
