{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.12";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0i69pkvdwj58l86sa6wf7s7rv1bb3lqpqk2xfqy60kazd4xik5v6";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0s4aiv54mbp0zfz37jh1760ic5gdf9srfm9myx4rn0hx2k8jlnlr";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "16g8sblz7asakxwlcx8z34g707q4n6kykahcckm4sdbhag0f6qa7";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "041w6hnafvz3r9rha6wdw1qhgnd6slamy4l3nap04k5fpnad556k";
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
