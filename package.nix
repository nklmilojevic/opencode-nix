{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.12";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "13kxd89abrxyqymjzbmmvjqyv364xmmgm3gxiyv8q85p9c47d50l";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0v1fvxm89krggn494sw6al7412cgd3af07qpdyxqai0mxyjhzwci";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0nf3cp0fz11p92rf5j1jh1vfp7h5hm2rn7z07xk7754qpb4bvaji";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "16mvp4rzgs6q88x6fm8j5gdjapklz8h7fb5q2qdgz7dgnh90rkjv";
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
