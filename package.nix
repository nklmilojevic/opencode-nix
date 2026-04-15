{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.4";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0pp8l1an5lzddzss9s5dq346343rpyqw5wv7jh1qnrfsf6sz8xh2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "11li4hah3w1z2h7p7p9h21ngb2qm6yj4pfa69m0v7drmg6krkxnp";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1xd7smr0c1s9j7szgfmzjdx5kip2cjc6f1pc4bikgl0jva8wl82q";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0djbrnp4pzzgvbahw4jvqizplirg5hxny3dhgyx6vgjkb2dq43im";
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
