{...}: {
  imports = [
    ./dns
    ./k3s
    ./minio
    ./monitoring
    ./ntp
    ./podman
    ./rclone-backup
    ./security
    ./zenstate
  ];
}
