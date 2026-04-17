{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.9";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0sp32p8pzhh2h15s3n070yfvyv50y9wzj498xl40mr1gmpv1n0dn";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1cx5ac7148k9ari2dszj0yvms3x1rlmp1ni7s7z21dalp6frrgig";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0sgb3cnhg2g08il77qyvi2p610i8lilfra8bw5igqqyb90ad5v3f";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1scl7njd37lidvr6mqyc1i5isjpb1j8phrg839kmmp6ryknk4fal";
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
