{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.53";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1sxl0hfpdw49n58f47xfg097pq0cl0c2j4g9r6zqvwlvacmj8d7m";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0zcc4ns6g7wflz4mdvm6gw5f10w9z9qmzysl4mpdg1iwv1253yqi";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1sn3f4fmrza8kyinmpnhhk5pwnvzac3absjb3z43k7pf8y87a0s7";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0h5p1bm0q79nb6nclr6jx3bgnp75zq2hv0fabkwrrnrynf1zlz9i";
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
