inputs: let
  overrides = final: prev: {
    go_1_22 = prev.go_1_22.overrideAttrs (old: {
      src = prev.fetchurl {
        url = "https://go.dev/dl/go1.22.2.src.tar.gz";
        # hash = lib.fakeHash;
        hash = "sha256-N06oKyiexzjpaCZ8rFnH1f8YD5SSJQJUeEsgROkN9ak=";
      };
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
