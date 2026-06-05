{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.16.2";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0ccw9l7n67byi1wqv776z3fnd7mcxib91na68wjcwrrfarmgjbd2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0zmbpcdl3n89vzl85pbvk3si4a5236mdw3p85rzzqy748j7v6w6k";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "00ydww8ggdqgj5fagcn8a4xgykrsjkilvgw8is2g1w3li3zv9q8v";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0pzfp721i3bphyhzi46y3a6l947z60bd6qvdnqy7ihb2flykh0r1";
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
