{ pkgs ? import <nixpkgs> { } }: rec {
  talosctl = pkgs.callPackage ./talosctl.nix { };
  tesla-auth = pkgs.callPackage ./tesla-auth.nix { };
}
