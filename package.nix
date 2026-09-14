{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.31";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1shd2il7nczfn0i85dq1a44zcp266kf9d0vj7s90s0wb58jxm2bd";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1l35fjdzsz5a5ccr1if822rvrxlk74kbakbiwmy2ny62hacgqc4z";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1sll8hs3i2xc6zrqcxy2x02b5iksl0czw836zyk4f7vz42hlmkyz";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0wfnaymjyfd4j8qi975b0zmc8xvr8pyxs1aznqck82szfq39myp1";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
