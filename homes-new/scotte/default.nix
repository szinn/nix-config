{hostname, ...}: {
  imports = [
    ../modules
    ./${hostname}
  ];
}
