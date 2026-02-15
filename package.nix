{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.5";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1hy6ki4hqk4w3d6l1fndm3hj0l66g26jd7vcxkmf3nmplaqlz7al";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "15gn1gdb2r37h4sccvag3fd1ssfaxqnhshp03l01ilbkslczl6i4";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "03ln0xhllp1v5jwbjjwvf1pq7kxdkr9i0hdr951qnabr19gzp7ki";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0h1vga56zadpca3hbl086xm18f4fbxdhrswh6nfnsgm3hmka59xy";
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
