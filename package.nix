{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.27";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1zkfn69r5xn7bi6yg06070x039iiybx9yyc08f4syfbfcxa1mn0r";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "12rb4b8m3aikxifzzxqzp4i9rzd5r60zzfvy7lazy1rlh3lb4v9r";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1r9s5mllmdzncsjiqm7pys2vv03wa890mim8xz26hbqmzp2yiyfy";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0l9a5s52hpgcxyp35frjf7pqcj245z6hplgnlday95h9wwiw84l9";
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
