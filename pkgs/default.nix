{
  inputs,
  pkgs ? import <nixpkgs> {},
}: {
  tesla-auth = pkgs.callPackage ./tesla-auth.nix {};
  talosctl = pkgs.callPackage ./talosctl.nix {};
  talhelper = pkgs.callPackage inputs.talhelper {};
}
