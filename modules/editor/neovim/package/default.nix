{ pkgs, ... }:
# Comes from nix2vim overlay:
# https://github.com/gytis-ivaskevicius/nix2vim/blob/master/lib/neovim-builder.nix
pkgs.neovimBuilder {
  package = pkgs.neovim-unwrapped;
  imports = [
    # ../config/align.nix
    # ../config/bufferline.nix
    # ../config/colors.nix
    # ../config/completion.nix
    # ../config/gitsigns.nix
    # ../config/lsp.nix
    ../config/misc.nix
    # ../config/statusline.nix
    # ../config/syntax.nix
    # ../config/telescope.nix
    # ../config/toggleterm.nix
    # ../config/tree.nix
  ];
}
