_: let
  config = import ../modules/nvim;
in {
  perSystem = {
    inputs',
    pkgs,
    system,
    ...
  }: let
    nixvim' = inputs'.nixvim.legacyPackages;
    nvim = nixvim'.makeNixvimWithModule {
      inherit pkgs;
      module = config;
      extraSpecialArgs = {
      };
    };
  in {
    packages = {
      # nix run github:szinn/nix-config#nvim
      # nix run .#nvim
      inherit nvim;
    };
  };
}
