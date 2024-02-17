{
  imports = [
    ./keys.nix
    ./lualine.nix
    ./neo-tree.nix
    ./treesitter.nix
  ];

  programs.nixvim = {
    colorschemes.dracula.enable = true;

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
