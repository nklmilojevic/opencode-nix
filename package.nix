{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.37";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0nilgq0f36gsi3lhc98yr4dfhcbzyhzhjw8b66y3gdw0v4dhrj1p";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "007bn7nz82znqq013sxnvim33ms8p7dk3ry1a5lhicax3v0jayk1";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "14ryqzils3rb1wgxy2m5n7db251sflp29ck87bhjvjp5q3zkswll";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0qj0ph4dnph9hmimzrsrj5q1bpl2ifvqi7ib9zsm3lybhd0y22yy";
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
