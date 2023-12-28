{ lib, stdenv, fetchurl }:
with lib;
stdenv.mkDerivation {
  pname = "tesla-auth";
  version = "v0.9.0";
  src = fetchurl {
    url = "https://github.com/adriankumpf/tesla_auth/releases/download/v0.9.0/tesla-auth-macos.tar.gz";
    sha256 = "sha256-qD85h1JMl92yP80S2JZF5q6aQ9nf8fsxKPWX7xOUN4A=";
  };

  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/bin
    tar zxf $src -O tesla_auth > $out/bin/tesla_auth
    chmod +x $out/bin/tesla_auth
  '';

  meta = {
    description = "Command-line tool for fetching authentication tokens for Tesla";
    homepage = "https://github.com/adriankumpf/tesla_auth";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
