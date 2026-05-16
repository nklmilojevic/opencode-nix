{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.2";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0hjc3032qmqifx99sky4yi26pk3pwsgr0wbgvscbrdyia5rkd3dw";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "077z13f77z0lyhzfyvkayjpwp59lkwclacg821h1j2hg1hnd282p";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1ph6q7y5p2vnk0zxb489w6jlgfil0yxaiz3p07awzcxnk3gip3fh";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1vw7h0c18dzgkcl70z36b1xrsr6ljpfg6ng5l1sx5ahgp4h90v5m";
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
