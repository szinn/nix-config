{
  pkgs,
  config,
  ...
}: let
  font_family = "Inter";
in {
  programs.hyprlock = {
    enable = true;

    general = {
      disable_loading_bar = true;
      hide_cursor = false;
      no_fade_in = true;
    };

    backgrounds = [
      {
        monitor = "";
        path = ""; # "${config.home.homeDirectory}/wall.png";
      }
    ];

    input-fields = [
      {
        monitor = "HDMI-A-1";

        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 2;

        outer_color = "rgb(248, 248, 242)";
        inner_color = "rgb(11, 13, 15)";
        font_color = "rgb(248, 248, 242)";

        fade_on_empty = false;
        placeholder_text = ''<span font_family="${font_family}" foreground="##0B0D0F">Password...</span>'';

        dots_spacing = 0.3;
        dots_center = true;
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        inherit font_family;
        font_size = 50;
        color = "rgb(248, 248, 242)";

        position = {
          x = 0;
          y = 80;
        };

        valign = "center";
        halign = "center";
      }
    ];
  };
}
