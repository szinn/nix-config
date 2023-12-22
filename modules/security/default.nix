{ username }: { pkgs, ... }:
{
  imports = [
    ( import ./one-password { username = username; } )
    ( import ./gnupg { username = username; } )
    ( import ./ssh { username = username; } )
  ];
}
