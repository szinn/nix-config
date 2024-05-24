{...}: {
  imports = [
    ./dns
    ./monitoring
    ./networking
    ./ntp
    ./security
    ./k3s.nix
    ./minio.nix
    ./podman.nix
    ./rclone-backup.nix
    ./zenstate.nix
  ];
}
