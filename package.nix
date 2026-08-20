{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.19";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0rfwfzf4s1pq774ixy8a4bf1xw7ixz215ms17gqbqivlcz8gq863";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0rslvldispwh5d08l29680la719d118ywnc2mjc3zbkg24d7jqf2";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "05rc3xk6cx8ahl2x841zw4xdnsrppwgrjd0lzc70j0hzgwrs3yvz";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0jfawk6syqrdq7hd387mmjlbxkwq276lmq59nxpqdg6w82g6bbjr";
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
