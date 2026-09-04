{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.28";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0jpmrqqq6xi4m3pdw8dpysjgqq417nsfpgjzymb7klszc99arb2j";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "19m6dqrs8jvv9l78s80isrbpz3s74czwi6b60g8iscidkxwfvmam";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0lfc4dkb651mb3q9sd86higxkgy0fcgz95jkqdgkg8fw74g99fkl";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0cb3qrdiy8rb0xaiz82qxg0a3myqxlkhwxjx3iiv768ifvay1z3x";
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
