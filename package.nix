{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.11";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0aq64ybwschq7k7a9yw2xsi5h240pqyg2c485nsx13av37bl0ns6";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "13ww5iridkn2h8qpx8qglgxwniczp7ws8vlzfcjlg0sni8jafck3";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0xl8djh6jpfy72pjzx61scd8q0l7vnmdsmb0by42vw9sph5a8ppd";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1xankvdfhsq1vllsb6dg8ad8r31jc7sjsz1w5301sdc7k488vrbp";
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
