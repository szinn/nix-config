{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    overlays = import ../overlays inputs;
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system overlays;
    };

    packages = {
      # nix run github:szinn/nix-config#talosctl
      # nix run .#talosctl
      inherit (pkgs) talosctl;
    };
  };
}
