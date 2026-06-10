{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.2";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "012a1p7grlmcvncd83xdzqsdjq39kgxlybkbjb6qmxvy8v4a62b0";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1gdmnf67a04pg323f3y5gzwhqj5aqzjigq84d9yvvy9wm72xf5r4";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0g771k8c92wbx7g3cvcn49x87w7bzlj0q8pfx8n6lzab5gb1g2c9";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1hm01ifrlidhi13ymvibk3nwhppzmsd6hbc7ixyk52w1s35lx61w";
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
