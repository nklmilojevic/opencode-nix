{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.8";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1rvpq8iqzy2vl54bywfr1vx48pgh332fnw0li4wyga9m8776zw6y";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0mw5iyb87p7v17gzqn078457bajwgccl7v8vc2wg1kl8ppmwmva5";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1vpfxw2qghd434fsdfjql0viyhkzb4bmy4ggkrzmgrdcl33r2cwq";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1jrk84lrjdf9s3133z6825vgrxm7r872lc71lv02cz47chi5qrif";
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
