{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.12";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0qbrfmpg1gyqngsa3v9kp85lzkwazrbp3ay0v4n7729dyvz8y0a4";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0ah65i1bmmqqxdfk9rinld65mbvx3a725wq2gkghp5r5925i2m10";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "07gp8z4w4hif1j0pp7pk5qwiasi8xs6xddj9h1af4x50d40b38s3";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "10yi9s3lqskdgw43bhhv4nwqbzn9b9z7s8shawr0mmndxiiclv43";
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
