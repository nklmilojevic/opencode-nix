{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.11";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "15mfy8xmngplmhwb63var6him9svh6973jcqcamirgilwnfkb9qw";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1xsrbv8hyzavpi58bqjghwmibnj9ry2s648zpl3sp09b98xy4859";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "09ryflbrx5xxwx74w911w1pnvrhshklk84j4ryk4w22l6wgy6fvm";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "00npk1r0z54pv05k6v2akcc0vsyjjfv1wiypng480qgg3mklgknl";
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
