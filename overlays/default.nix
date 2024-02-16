inputs:
let
  additions = final: _prev: import ../pkgs { pkgs = final; };
in
[
  inputs.nix2vim.overlay
  additions
  (import ./neovim-plugins.nix inputs)
]
