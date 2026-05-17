{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.4";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0s7hc17wpdcnczy0cq8fxj6xgqg05yg8v3rchic1xk4w3bw9qw3q";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0yg9p06zckjfsf2gsarhxcw000f31mbcihqmlv37bpwajc39v0k7";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0gqnm3m3q3rg829xhf7gdkw1hbcbx5x9rj26ri194h6n7l95ccj4";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0pbiq09cx0dix85zzwqpxh256s5ha6mnzkq9ac3ljxzkvmgmab1d";
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
