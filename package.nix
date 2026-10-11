{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.19.0";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "10kjbagbdi5n63m30i9l1y5hv15qq108ddv5ilm1a338gx4visbc";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "13vpysvy5swci904dhbldvkr0wrbl376cirg5lq16l27bln110c4";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0gfwxfcjv9lf0gkslbaca0qns5bqcmsvs3v3nnqflgfchyi4i045";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "118brirk5qf03jcjhy1sxgx90apwszvhpvh95pgfharj309g3k1g";
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
