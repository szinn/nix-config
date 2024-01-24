{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "talosctl";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "talos";
    rev = "v${version}";
    hash = "sha256-Bj7pSK2hIS/4P7Ot2jITbhp++4cWg1gXR/vEngp5lFQ=";
  };

  vendorHash = "sha256-nY/wf4zAsdz+BChpIZzOTkEoX+c3mo/PfeYUigh+D6c=";
  # proxyVendor = true;

  ldflags = [ "-s" "-w" ];

  GOWORK = "off";

  subPackages = [ "cmd/talosctl" ];

  nativeBuildInputs = [ installShellFiles ];

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
    maintainers = with maintainers; [ flokli ];
  };
}
