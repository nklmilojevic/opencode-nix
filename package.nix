{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.42";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0kf8qhcpxq94m1pkwhzfl86k430vw73a47nxhba1cdgx2nxvm9x8";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "05cc32ypyd7ihf0937gnmz9sx2ym8s7n6fkmbs5k4fs6nk6iqh0n";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "08kwsm7n64gws926ssaws28wqipzh2gs5ahhk7f9wva3nhnn3rlz";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1xgraxl1ajd71mg61pk404acnb8cgislp4inpk2l2n39fy1yiji0";
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
