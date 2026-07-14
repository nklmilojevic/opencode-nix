{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.0";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1kvf0clygk8i8pgxv2036s8qblfyspw6dc1w1gxgs2fa2xj1hif5";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1akzgml9prdlk4jvszsh3jc8xw29iw0h7k03yam6ck8c5pnxwp4k";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1kn6h626is7vjd2qswsgaz3bq7qzyfydjva9a4shvlj723h1afwz";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0pl5pykhydjxb5vda4hzwakkhsxdvzvgjabbjhza3y2bm73f78yp";
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
