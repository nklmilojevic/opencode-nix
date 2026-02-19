{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.7";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1r9hixy0irfa3yf5lpbch3dsv1m8kpq7a61bq17y0pglj7l8g8gc";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0ws3wy4dpqwcpgx9ixbbyb6bipdnnf31wpcgpc01zv04ycrv2n5b";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0yx6vfkjwdf68p7782y22p6r1747bcq59yr0vg6q1d3q013k8sn3";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1qwxvy5a5sj2g9ni49wvgxvm87xk3x3w6g4zzlyq1b48ni6vbdjv";
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
