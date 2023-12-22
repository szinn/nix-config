{ username }: { pkgs, ... }:
{
  imports = [
    ( import ./devonthink { username = username; } )
    ( import ./dosync { username = username; } )
  ];
}
