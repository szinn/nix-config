{ username }: { pkgs, ... }:
{
  imports = [
    ( import ./alacritty { username = username; } )
    ( import ./fish { username = username; } )
    ( import ./git { username = username; } )
    ( import ./tmux { username = username; } )
    ( import ./utilities { username = username; } )
    ( import ./wezterm { username = username; } )
  ];
}
