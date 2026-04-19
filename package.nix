{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.17";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0j1cd4g9mdv5x4s348i87lmnvyixcx3kr5pkn7l1a7rzwy3m3xaa";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1dhhwxljxaaqmh9na7wy2ndxpryl66balamacv467cr7n1ib4qpy";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0jzabpd48xlnvqvl8rs7wm0i765wk4pxhkkm7qf4crbk3vsdmd5h";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1nx402pwhwifsarcdfg0vkh5225jf6lawc5r1wpivskaymi8xrp6";
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
