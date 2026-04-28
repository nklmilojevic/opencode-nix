{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.29";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0wdwxfsi48qpkabq05gdh4vjpd30ab6daa5jdrsnxngrysj687v2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1dk7jlcfr31cpdf2h37lzan7kjfywciqmddqs6r4nqw1s6avxl1q";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "00v92hxk0f8yjfmwf1kdnqyla8l3d6jqi58dq4jkk2v4cflr6gk7";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0s569a3xhdqiarwp78rf9hn87c1gjd0xiwfhmswnmfls4sd58wvk";
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
