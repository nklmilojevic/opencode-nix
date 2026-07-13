{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.20";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "011z61dqnvaww9qskyb31ydxym90xn9wjw1p86qry7f4zk66qf47";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0db2hz4npfy9b4jrd9mgdwqxcc62jgb7gqzrrc5hgx9kv7f2i37b";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1ham6apa3dfldhxan67ky1gry09j71021y52xb92acjysf19d1qh";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0d9i8ds7n6vm2192ja6k8j0dr46hkclh5qkc6ljb31h8wv18b3ad";
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
