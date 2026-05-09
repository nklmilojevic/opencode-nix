{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.44";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1hzyp3xdpc5xy1kc4rgkvnff4bjgjsmkrdnm83vkf9rm7x7nbs66";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0ixihqv5x697pjx4mid5c395kxxvrzw2b4rvkbl861nnzdk5mb80";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1d812yibsdk6vhqq44mim11wrkkziw22shddszc46irz4s0qrsan";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "08hxd3jig4azfniac8lnnzqig2a78ykahvsbj20vjyrb6dbazcfm";
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
