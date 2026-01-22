{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.32";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "12imqfm3g8na4q9gnzrmm8znanhsij5f0h2ip34ray5ys2vigw7l";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0h9cfrf39237xq3d433f72iz0laxwfgyr5bil66dgqka546ap1bc";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "04z63is7ih3acdgmhnq4bpag24nvg4aaj1rj2apclbscqmbjlv1z";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "10v2ggfpmjnci9ciql8swcwkq6n8bbrk13r8bm6qb907ga33509n";
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
