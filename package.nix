{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.16";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1ha1qgskgr3l34kp0ahcm82rr9vka7hck12y2m9cmp4d98vchcqd";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1iblxlmblmiplkdrrcg2zby7qfw0jg45gcgxc3v2zjjhx3nc5dh9";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "01pir5593xp0745chlwhszyxwlsrvxlpicxyvishyf11hg0d3kmn";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1l5n7fg6a8m90l304lcqqn1fi091af8p60i3d1y3ixim5p1s111h";
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
