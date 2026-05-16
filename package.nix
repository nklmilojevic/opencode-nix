{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.3";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0x5678d6pcdq8hi8wy8fhjhvmvcbhiyikkfmj5wmfjr7j183x0cv";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1r5f26wv6yq0rqiy66cl2kpf5n9z59rmc452s9kf40k8kmrs0xb9";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0w730dfbnbvcwiqd0k9g3my0wkr6lk4q4108p28ipnx90nsrcyc1";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0abnfrrisvsh16vyr1pxi56gnpzri0knpaqgiq20d2xqfs6kg8a3";
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
