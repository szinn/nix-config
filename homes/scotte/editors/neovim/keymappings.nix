{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps = let
    mapAttrsToList = f: attrs:
      map (name: f name attrs.${name}) (builtins.attrNames attrs);

    normal =
      mapAttrsToList
      (key: action: {
        mode = "n";
        options.silent = true;
        inherit action key;
      })
      {
        "<Space>" = "<NOP>";

        # Esc to clear search results
        "<esc>" = ":noh<CR>";

        # fix Y behaviour
        Y = "y$";

        # back and fourth between the two most recent files
        "<C-c>" = ":b#<CR>";

        # close by Ctrl+x
        "<C-x>" = ":close<CR>";

        # save by Space+s or Ctrl+s
        "<C-s>" = ":w<CR>";

        # navigate to left/right window
        # "<leader>h" = "<C-w>h";
        # "<leader>l" = "<C-w>l";

        # Press 'H', 'L' to jump to start/end of a line (first/last character)
        L = "$";
        H = "^";

        # resize with arrows
        "<C-Up>" = ":resize -2<CR>";
        "<C-Down>" = ":resize +2<CR>";
        "<C-Left>" = ":vertical resize +2<CR>";
        "<C-Right>" = ":vertical resize -2<CR>";

        # move current line up/down
        # M = Alt key
        "<M-k>" = ":move-2<CR>";
        "<M-j>" = ":move+<CR>";
      };

    visual =
      mapAttrsToList
      (key: action: {
        mode = "v";
        options.silent = true;
        inherit action key;
      })
      {
        # better indenting
        ">" = ">gv";
        "<" = "<gv";
        "<TAB>" = ">gv";
        "<S-TAB>" = "<gv";

        # move selected line / block of text in visual mode
        "K" = ":m '<-2<CR>gv=gv";
        "J" = ":m '>+1<CR>gv=gv";
      };
  in (normal
    ++ visual
    ++ [
      {
        mode = "n";
        key = "<leader>s";
        action = ":w<CR>";
        options = {
          desc = "Save";
        };
      }
    ]);
}
