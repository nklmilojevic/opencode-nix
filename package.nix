{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.17";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0jysd9i6lkbq2rflhgxghn2dhs723qzcdd7clzy5larjkf6w09mf";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1wbjna1z7wy7zr6sz8ya9d1qax82n10dds89dyc1cpwcpadp0966";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1rr3inq74dyhvwsxvv4bbcg3r8pkl7sdb5s1dwf66s92by8jnflv";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "116539has77lva6r9dyj5zffqjd2wc5paj44qdinp0i0sjb4zd0r";
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
