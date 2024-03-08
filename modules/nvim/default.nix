{pkgs, ...}: {
  imports = [
    ./autocommands.nix
    ./completion.nix
    ./keymappings.nix
    ./options.nix
    ./plugins
  ];

  extraConfigLua = builtins.readFile ./lua/init.lua;

  extraPlugins = with pkgs.vimPlugins; [
    telescope-ui-select-nvim
    vim-sleuth
  ];
}
