{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.40";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1vzjync9pwp787587yg24y6y6kc1xaqwc4p78gp6vkbf3jnscqpn";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1xyrx6s4spsfb5zdh7vwvbmyf34nnz4dqdf8g89pyhh0h1yavm0h";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "01hlc2sqgsfwln6405mxr5mjrkhmpa2gmyj8h5hkgqv2shag0k94";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1w6ljwd24wk7g3frpigvg1g6nx7ygc4s4adzb8v70vzgzrsvcyqg";
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
