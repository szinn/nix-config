{
  plugins.lspsaga = {
    enable = true;
    beacon = {
      enable = true;
    };
    ui = {
      border = "rounded"; # One of none, single, double, rounded, solid, shadow
      codeAction = "💡"; # Can be any symbol you want 💡
    };
    hover = {
      openCmd = "!floorp"; # Choose your browser
      openLink = "gx";
    };
    diagnostic = {
      borderFollow = true;
      diagnosticOnlyCurrent = false;
      showCodeAction = true;
    };
    symbolInWinbar = {
      enable = true; # Breadcrumbs
    };
    codeAction = {
      extendGitSigns = false;
      showServerName = true;
      onlyInCursor = true;
      numShortcut = true;
      keys = {
        exec = "<CR>";
        quit = ["<Esc>" "q"];
      };
    };
    lightbulb = {
      enable = false;
      sign = false;
      virtualText = true;
    };
    implement = {
      enable = false;
    };
    rename = {
      autoSave = false;
      keys = {
        exec = "<CR>";
        quit = ["<C-k>" "<Esc>"];
        select = "x";
      };
    };
    outline = {
      autoClose = true;
      autoPreview = true;
      closeAfterJump = true;
      layout = "normal"; # normal or float
      winPosition = "right"; # left or right
      keys = {
        jump = "e";
        quit = "q";
        toggleOrJump = "o";
      };
    };
    scrollPreview = {
      scrollDown = "<C-f>";
      scrollUp = "<C-b>";
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "gd";
      action = "<CMD>Lspsaga finder def<CR>";
      options = {
        desc = "[G]oto [D]efinition";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gr";
      action = "<CMD>Lspsaga finder ref<CR>";
      options = {
        desc = "[G]oto [R]eferences";
        silent = true;
      };
    }

    # {
    #   mode = "n";
    #   key = "gD";
    #   action = "<CMD>Lspsaga show_line_diagnostics<CR>";
    #   options = {
    #     desc = "Goto Declaration";
    #     silent = true;
    #   };
    # }

    {
      mode = "n";
      key = "gi";
      action = "<CMD>Lspsaga finder imp<CR>";
      options = {
        desc = "[G]oto [I]mplementation";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "gt";
      action = "<CMD>Lspsaga peek_type_definition<CR>";
      options = {
        desc = "[G]oto [T]ype Definition";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "K";
      action = "<CMD>Lspsaga hover_doc<CR>";
      options = {
        desc = "Hover";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>cw";
      action = "<CMD>Lspsaga outline<CR>";
      options = {
        desc = "Outline";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>cr";
      action = "<CMD>Lspsaga rename<CR>";
      options = {
        desc = "[C]ode [R]ename";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>ca";
      action = "<CMD>Lspsaga code_action<CR>";
      options = {
        desc = "[C]ode [A]ction";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>cd";
      action = "<CMD>Lspsaga show_line_diagnostics<CR>";
      options = {
        desc = "[C]ode Line [D]iagnostics";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "[D";
      action = "<CMD>Lspsaga diagnostic_jump_next<CR>";
      options = {
        desc = "Next [D]iagnostic";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "]D";
      action = "<CMD>Lspsaga diagnostic_jump_prev<CR>";
      options = {
        desc = "Previous [D]iagnostic";
        silent = true;
      };
    }
  ];
}
