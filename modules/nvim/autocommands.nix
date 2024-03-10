{
  autoCmd = [
    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Remove trailing whitespace on save
    {
      event = "BufWrite";
      command = "%s/\\s\\+$//e";
    }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Set indentation to 2 spaces for nix files
    {
      event = "FileType";
      pattern = "nix";
      command = "setlocal expandtab tabstop=2 shiftwidth=2";
    }

    # Set indentation to 4 spaces (but use tabs) for go files
    {
      event = "FileType";
      pattern = "go";
      command = "setlocal noexpandtab tabstop=4 shiftwidth=4";
    }

    # Set indentation to 4 spaces for rust files
    {
      event = "FileType";
      pattern = "rs";
      command = "setlocal expandtab tabstop=4 shiftwidth=4";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex"
        "latex"
        "markdown"
      ];
      command = "setlocal spell spelllang=en,fr";
    }

    # Highlight when yanking (copying) text
    #  See `:help vim.highlight.on_yank()`
    {
      event = "TextYankPost";
      callback = {
        __raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      };
    }
  ];
}
