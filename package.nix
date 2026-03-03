{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.16";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1a9qgzqa8d7azhdxr0zg8w5cqyz02di9dc0npjz8dp64phsrg0jb";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "17iw7hidhml6izij0n4wrd2q2vd9rrc5c8aj5929v7gicrh5vkcm";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "09lgbicd8ip4idiidn6pr1vra4k4d8xvax2n8frsa9bcrlb6r89m";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0a3yxhq6khgg0fi4jsjd8fcxknppv3jh0i5ch28ly38zajn7h6l6";
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
