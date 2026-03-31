{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.10";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0588fx52hx064g301hshbabvrlkhwa3jzznk10s3gayr473p201z";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0ynam3x6kgh9b4d17s99kkk9wgb77pskgwv3gpsflsx9yp8xn2lr";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1zfh92hfpbzgspvy15hqawym6r98rjx3pmaks8p7610zb93p5f1y";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0imklqg7kcska1r0bypcg9bpbmbh33ybf3vz5apdqzk3imayqv36";
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
