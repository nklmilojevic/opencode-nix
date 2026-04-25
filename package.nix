{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.25";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1p837xwzx5z7pqn5gx4smnm6c6gfz8a180dsrd0j95rbzn3x82yh";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "02vm6sciq4zyskqx9apcc71inryiqmgs3mws53ikcpn5qvcpv31x";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "07l3av6hdc0zn44n1cwi7qzhhkwj32n6n2m7frajgx60l630zd9s";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0dzmdaqcd4ivy9p5fxg9fmy4z5f36fhdiwlxj41fmpr8p5vw75bh";
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
