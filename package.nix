{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.15";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "08dgrc5h57k1v3yid7s01iqyqv4zsqpn2dga6zhnl5gpn2js2mpw";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0v0cp1szxchlbh4lzip1mn7yvs3vsy8ps3vg40jcsyn7xsjdvqx5";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0jz6rjpb1mw4gs9zg7md41vpvkh10z9kkd6lbl9cifl6pd8pcn4l";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1c8j6vk2f12fbpyzrchlyh2cad3nkgc3xb8ldlh39gsrbh29zy7k";
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
