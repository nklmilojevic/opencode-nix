{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.3";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1b7r5p7a1ljql5yj50x3p0x6xsc3l35w2w1s5v628k3gqv7c3dw0";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1bfmlxc1734l5k7amyghrr3sz4yq9phi2ingxva2fykmbbn4qki8";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "15fahnjs9amnh6fz5ljg5kvd2g0v8bz14zjdgpyrrkv64xs6l288";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "08fllnn457f8ql6a4rsl1h84yvm2rvmgyqm7187nzsc9r2yca0mi";
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
