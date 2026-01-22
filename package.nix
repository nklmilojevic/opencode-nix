{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.31";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0qcw11m860g0k2q49awgv2fc65ggfgwzsnhwca78ypnykzs82ygf";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "04ygdhaw4bcza5f22b6nzw4mji741ribb9h0n4q2frbvbac618ya";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1gxja0kc6d44lf2smmaa164cbgnm611cscjdkzr7l60r3rhmf71a";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1ymzxkd5dnbxhqav2amam14wdpbryd8ahl22khr8afsiv4a5x5m5";
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
