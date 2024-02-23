{
  programs.nixvim = {
    plugins = {
      which-key = {
        enable = true;

        registrations = {
          "<leader>f" = "Find Files";
        };
      };
    };
  };
}
