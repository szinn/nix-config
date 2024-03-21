# Makefile to quickly iterate on building the overlays
build:
	nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'

clean:
	rm result*
