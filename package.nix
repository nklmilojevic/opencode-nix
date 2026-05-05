{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.39";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0yspg6c81bvfsvj9kii2xblrk9rs369z8z6dr8hjfd3996jqbvk9";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0749czskpvc2b2yv4y0ivlpbmqcwnf5gfgssjnj8a94hdjkw899d";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0h9lbwfs9ym9cbqbjqi61fr9m5sar3v6bknm65wadp6i0ayl1csr";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1s2jhyii4y0w7jvl02p65jdxcvm8504zsgghv16d7y61jq3gnbxy";
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
