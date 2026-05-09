{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.43";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1knzg0ifxnx5608zp8rscxqz999caiqlsch4c2mlmbsvsz4kq1iy";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1kp1fi0jqwip8bb6r22c8c6rjcjxwbhrkaz555lxdbp7d7fl2qp4";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "07gi7dw00x47ljqyp2ibvrmjb93q0x091zg3y5gn92jpgxv0r404";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1dwc4ipdwmaz82jk3vqiw8cbamzaaay20s1jxd98wi78wmq50ndc";
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
