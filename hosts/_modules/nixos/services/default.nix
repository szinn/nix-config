{...}: {
  imports = [
    ./dns
    ./k3s
    ./minio
    ./monitoring
    ./networking
    ./ntp
    ./podman
    ./rclone-backup
    ./security
    ./zenstate
  ];
}
