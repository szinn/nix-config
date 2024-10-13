inputs: let
  inherit (import ./utils.nix) pickLatest;

  overrides = final: prev: {
    # go_1_22 =
    #   pickLatest (prev.go_1_22.overrideAttrs (old: {
    #     version = "1.22.5";
    #     src = prev.fetchurl {
    #       url = "https://go.dev/dl/go1.22.5.src.tar.gz";
    #       # hash = prev.lib.fakeHash;
    #       hash = "sha256-rJxyPyJJaa7mJLw0/TTJ4T8qIS11xxyAfeZEu0bhEvY=";
    #     };
    #   }))
    #   prev.go_1_22;

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

    go-task = prev.go-task.overrideAttrs (old: {
      patches = [];
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
