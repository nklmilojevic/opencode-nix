{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.5";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "082rkym9aybkgga3szb883jsr96srxh036fdx2qcd6ir45my1jcj";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "081h0g7jkblv0mw691cx8pflq0a6j3jsmns0aca61qvhbhj5lw3l";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "01s1036zshhayl33h7rmacc0hv57y3wkcmvycg1mvk1wrln0a9vr";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0w7yyv3dkrca6vi4hid5hs0vyvyyglhzksva3azg0c2xgdsf56p5";
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
