{pkgs, ...}: {
  imports = [
    ./go
    ./postgres
    ./rust
  ];

  config = {
    home.packages = with pkgs; [
      mdbook
      mdbook-admonish
      mdbook-toc
    ];
  };
}
