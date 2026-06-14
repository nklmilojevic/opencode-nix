{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.7";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1hvxf4q8x9jf7h3i6a0jx1ps0fyv81l2mdbfgdcr62rk5yq8hyi5";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "02xc7fh0wihmsan8vbg69g71kf4amc80b52wywwqjl7b5g0a9c10";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0c9lsa0nab8pxihjgklz6xcw376mkac2850lfld8cmdl9j6dhq4k";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "12sm91w2v4rbd2zg4ic4w97zl2wavslc73vc04xb74xrqxfzxfl9";
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
