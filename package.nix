{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.23";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "17kj6gqs3nr5x37zwm3jmqckvyql3b0vm7697ra8v2i71r2av1xr";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "07jqpa12qvrhjzbl8sq4ihbh8y7d0xx3id25kqfkxarvwgsyqdfa";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "02mcz9jlxg3jz9ficp8ngmfwpw1gs93bjhgfy67lad2gjngha5yj";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "09g1n00p827mp29s03hbs4x1g6vs93wndvww8llcy87mr7naq58l";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
