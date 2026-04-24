{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.24";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "033xyix06kyvdfa3ypxl3mp9ka4rzkj3xfp4p034xnh5r7m0pwck";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0y7670yrwc7xbxshwpmcvgg7qx6ny9lr0xw5cbafz8zb80f8ms99";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0wi21qjph5k4mjgk5kacsndykx54hd3bgkgj4s7an0dcd12jgk0p";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0lwq3dq1l7wz6rzxl23kv91x7jgl75vdm5gxwcgy4bcy8bd6jasw";
    };
  };

  currentPlatform = platformInfo.${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

in stdenv.mkDerivation {
  pname = "opencode";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/opencode-${currentPlatform.platform}/-/opencode-${currentPlatform.platform}-${version}.tgz";
    sha256 = currentPlatform.sha256;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/opencode $out/bin/opencode
    chmod +x $out/bin/opencode

    runHook postInstall
  '';

  meta = with lib; {
    description = "OpenCode - AI-powered coding assistant in your terminal";
    homepage = "https://github.com/anomalyco/opencode";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "opencode";
  };
}
