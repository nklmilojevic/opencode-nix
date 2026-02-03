{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.49";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "01acjk4h5wk3qdxafr7r1x5sa663vjb5j09n7f67691v4gylk0p2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0y93xbhcxwfnd281gdjyakxljz3wd6y0wzzs0dyzypk5jd30i9f1";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "03p3753jpx2bdpwy4mbpzwwyd2r5yx7nw8v95av9r0bl5nd5jvqr";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0z6y6fijspc555r584m0s74ri3lslrs9qmkgq4cxz6qcpcgy0spb";
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
