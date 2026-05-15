{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.51";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1b3rpq3lyzy9cpvqivnwy4banc70s50w8pg88jgj0zphhhws70vg";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0996rvnjp0syfifn5ahy7rj871gbmz96m9qhxbfyh210w0v2g7aw";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0c2km744qzfhbx0r4y8pk4jin95qp2db4v9dvm3g4mc9miqw9bn8";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "110p1bp1161601lsd970xx08rmlmjgc93m2hqwcv7vj2rsnfiajc";
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
