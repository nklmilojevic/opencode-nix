{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.26";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "00lg6n9qwz2hyxnx6rpvlzrdrq1qykw9yw3rly5sf5qm243qn3cr";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "06w4iwx7hsizpc0mhaadl5xsr38fczwwkmfkyp42jrldqk3cc32y";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1qspva8s88lx2f7jadgv1bvw25cncx7bym85gzzlvw6k78dmgwnz";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "05byc10dc9lgi3zwnc2f5jnyw80gj5vmgik6zj1zjqnx76h9ph6r";
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
