{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.21";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0dxzfjp2ikq5491qx9d0sniwjs1kdp6kcfykdkzvq87fhc5xjq9p";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0kwkvw7y567bajjzm84bpkka07nsaf00rx6xwq07xxlqfis2is7b";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1j5xw56x3iqg3hxqvcbf7jscnvgh760xxbxdmfrz97pnp9blas90";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "07a9xbj45irc1bcyp1bj699vh48ld84w1fwr8065gn2i0jzzlin2";
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
