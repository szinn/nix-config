inputs: let
  inherit (import ./utils.nix) pickLatest;

  overrides = final: prev: {
    go_1_22 =
      pickLatest (prev.go_1_22.overrideAttrs (old: {
        version = "1.22.4";
        src = prev.fetchurl {
          url = "https://go.dev/dl/go1.22.4.src.tar.gz";
          # hash = prev.lib.fakeHash;
          hash = "sha256-/tcgZ45yinyjC6jR3tHKr+J9FgKPqwIyuLqOIgCPt4Q=";
        };
      }))
      prev.go_1_22;

    # lua-language-server =
    #   pickLatest (prev.lua-language-server.overrideAttrs (old: {
    #     version = "3.9.1";
    #     src = prev.fetchFromGitHub {
    #       owner = "luals";
    #       repo = "lua-language-server";
    #       rev = "3.9.1";
    #       # nix-shell -p nix-prefetch-github --run "nix-prefetch-github luals lua-language-server --rev 3.9.1"
    #       # hash = prev.lib.fakeHash;
    #       hash = "sha256-M4eTrs5Ue2+b40TPdW4LZEACGYCE/J9dQodEk9d+gpY=";
    #       fetchSubmodules = true;
    #     };
    #   }))
    #   prev.lua-language-server;

    atuin = prev.atuin.overrideAttrs (_old: {
      patches = [./patches/0001-make-atuin-on-zfs-fast-again.patch];
    });
  };

  additions = final: _prev:
    import ../pkgs {
      inherit inputs;
      pkgs = final;
    };
in [
  overrides
  additions
  inputs.rust-overlay.overlays.default
]
