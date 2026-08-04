{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.12";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1yddbvym6qz4jn3hzd6palzif4v89y0vznw6zpkkz1af4w2jpdws";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1l9vlbx3rinf1mnbqk260n04bwc5l435miydz1vpc82fwqzl2wlx";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0rkafh8h0ym1kd65va0z8f4ix0ysx1yrsamq9d72idyvrfw0p8zm";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "043swf5s71550afb278y76rq09h6nk9m5q5v1q717kks1rikmdzc";
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
