inputs:
let
  additions = final: _prev: import ../pkgs { pkgs = final; };
in
[
  additions
]
