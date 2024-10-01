{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  installShellFiles,
}:
buildGo122Module rec {
  pname = "talosctl";
  # renovate: datasource=docker depName=ghcr.io/siderolabs/installer
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    rev = "v${version}";
    # nix-shell -p nix-prefetch-github --run "nix-prefetch-github siderolabs talos --rev v1.8.0"
    hash = "sha256-Ezie6RQsigmJgdvnSVk6awuUu2kODSio9DNg4bow76M=";
  };

  # vendorHash = lib.fakeHash;
  vendorHash = "sha256-9qkealjjdBO659fdWdgFii3ThPRwKpYasB03L3Bktqs=";

  ldflags = ["-s" "-w"];

  # This is needed to deal with workspace issues during the build
  overrideModAttrs = _: {
    GOWORK = "off";
  };
  GOWORK = "off";

  subPackages = ["cmd/talosctl"];

  nativeBuildInputs = [installShellFiles];

  postInstall = ''
    installShellCompletion --cmd talosctl \
      --bash <($out/bin/talosctl completion bash) \
      --fish <($out/bin/talosctl completion fish) \
      --zsh <($out/bin/talosctl completion zsh)
  '';

  doCheck = false; # no tests

  meta = with lib; {
    description = "A CLI for out-of-band management of Kubernetes nodes created by Talos";
    homepage = "https://www.talos.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [flokli];
  };
}
