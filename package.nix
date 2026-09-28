{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.33";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1hd37ipl9pm33f4w8mvb6an2k0scsgdjznmb4rk1jjr2b5mng6hl";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "14sbwpkbnmybicisazp8lk3nnzpa752g2pzi5v8zqlq53jphqv8r";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0cpzns5ksmvwwkbcb1z9wslz1lk3mj5vgds7z7di8qml9mnz6g72";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "07dk0yxfzqbqc9b2win9ncqsm39z70r2pjibk5i7n4sksr570b6d";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
