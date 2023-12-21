{ pkgs, ... }:
{
  programs.fish = {
    functions = {
      flushdns = {
        description = "Flush DNS cache";
        body = builtins.readFile ./functions/flushdns.fish;
      };
    };
  };
}
