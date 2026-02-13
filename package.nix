{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.65";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "16scjxr4z1hpbhhi7a5z0h4inq8bmsv4d2vrmjcccacf55kdp3p8";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0yqx1ghzcd1crvbc1n3zyimx31liiqk7xkkxcd633x675i4kaw2a";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "18g240dngky1svc54q39fmnlkiv61lg87y1yb89yvy9kyygb1aj7";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "117aca3m2zxwagzfi1snb16cxjq7n5ly1hai5chi15h9fzzz9fw4";
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
