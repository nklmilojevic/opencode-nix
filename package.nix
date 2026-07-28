{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.8";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0vwp4qbjzwljsynkibjf6qagag234x8vm3n4jd8mv02x734rg9il";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1jdm54wpism80acgw770d1w8j6d7wamj9pmcz8i06da26pm6qfrd";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1hkr003fhy5rradkc8nvq4dxl5kpyrh0d8ky37zh0afwsr561rq5";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0nd8002xad22np0k3mmb05w1a5df8q1pbnzi855fyyj83vw1vrbd";
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
