{
  self,
  nixpkgs,
  nix2vim,
  ...
} @inputs:
let
  inherit (nixpkgs) lib;

  additions = final: _prev: import ../pkgs { pkgs = final; };
  importLocalOverlay = file:
    lib.composeExtensions
      (_: _: { __inputs = inputs; })
      (import (../overlays + "/${file}"));

  localOverlays =
    lib.mapAttrs'
      (f: _: lib.nameValuePair
        (lib.removeSuffix ".nix" f)
        (importLocalOverlay f)
      )
      (builtins.readDir ../overlays);

in
localOverlays // {
  default = lib.composeManyExtensions ([
    nix2vim.overlay
    additions
    (final: prev: {
      inherit (self.packages.${final.stdenv.hostPlatform.system}) nix-fast-build;
    })
  ] ++ (lib.attrValues localOverlays));
}
