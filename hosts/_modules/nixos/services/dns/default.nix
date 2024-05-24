{...}: {
  imports = [
    ./adguardhome.nix
    ./bind.nix
    ./blocky.nix
    ./cloudflare-dyndns.nix
    ./dnsdist.nix
  ];
}
