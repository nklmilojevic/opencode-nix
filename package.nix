{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.29";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0hihxwd545y4l9dcy4fr7wykl946lxnkbgbww8z9wxa2l95mdpx2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "12pjlq3d09yciszmfl2ixy5yaf82a9jzi3k6bi7d8qw2ryn5bimv";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1qha434s8snk45lz30n8lv3j4lpid0y7fagn1lacxms0j05jgqnr";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0wky0km3ykhrd5s71hylnkpdjzrn5h78qsw2dhqc3129igp8zh0z";
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
