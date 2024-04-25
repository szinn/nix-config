{...}: {
  imports = [
    ./bind
    ./k3s
    ./minio
    ./monitoring
    ./nfs
    ./openssh
    ./rclone-backup
    ./samba
    ./sops
    ./zenstate
  ];
}
