{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.12";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "06z3f36md7s093gz5xbnnhz7zwkhvyg25ag35a5241xgkklh1cry";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0cr16i3gjm45iq24bbv5xvsrdfwx72j0nlf454zcx7hzxkasd0hm";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1acwmdzxq5zk9a8s5v854zhcq6qdyk4aackq8q89mwjswvn2qb44";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1f17kif8d2n62kyd6w81ps9xkmqn5k18id7qv7gc6rvj10r0sqx2";
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
