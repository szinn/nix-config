{
  inputs,
  pkgs ? import <nixpkgs> {},
}: {
  minio = pkgs.callPackage ./minio.nix {};
  tesla-auth = pkgs.callPackage ./tesla-auth.nix {};
  talosctl = pkgs.callPackage ./talosctl.nix {};
  talhelper = inputs.talhelper.packages.${pkgs.system}.default;
}
