{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.52";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0b0xmzpm15yk3b008q26bi07vnx46ygcgg0rznv8k92s5saflxn7";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "17mxavimjvmxv2db00a5x885azzlqbgbx00v0ap48m5w7h0rgkwr";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0ylswbi61cdz1xs41qnxgs1li04z2p2bagqxxvxiwxj6cx0y02qj";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0n4i8i0ykfk01ck6xlsl81dpbfs5j2v0m2g8l3h3vl4jdxzrvwm0";
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
