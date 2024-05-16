inputs: let
  inherit (import ./utils.nix) pickLatest;

  overrides = final: prev: {
    # go_1_22 =
    #   pickLatest (prev.go_1_22.overrideAttrs (old: {
    #     version = "1.22.2";
    #     src = prev.fetchurl {
    #       url = "https://go.dev/dl/go1.22.2.src.tar.gz";
    #       # hash = lib.fakeHash;
    #       hash = "sha256-N06oKyiexzjpaCZ8rFnH1f8YD5SSJQJUeEsgROkN9ak=";
    #     };
    #   }))
    #   prev.go_1_22;

    lua-language-server =
      pickLatest (prev.lua-language-server.overrideAttrs (old: {
        version = "3.9.1";
        src = prev.fetchFromGitHub {
          owner = "luals";
          repo = "lua-language-server";
          rev = "3.9.1";
          hash = "sha256-M4eTrs5Ue2+b40TPdW4LZEACGYCE/J9dQodEk9d+gpY=";
          fetchSubmodules = true;
        };
      }))
      prev.lua-language-server;

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
