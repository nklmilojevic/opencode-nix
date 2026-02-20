{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.10";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "09vzbw34smgrpkjphs5r0rrn9hqczrcsv6pavac5gg5nmzr14h33";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "15wlvhg0bww1c4c7fbwj4hbavk786bdydk3fl35av5k6dhfvj0mz";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "02i36r78c6xhiiz9hfwv9hibdyfganhm7n3jp0d7ajw37yqc91b7";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1dvcf15xp1m22shhmqrah2nz9rlpm40d29mgpshqrc5x32mlzivv";
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
