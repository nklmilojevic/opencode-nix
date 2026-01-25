{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.36";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0p76b7v0q139ksyl59cr8akgb2ksvnv2lx9hhjdmk8cxpkfixk72";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0g8h8hbl34ibp3cha3ih1b0fjzzlgr0hkypggssbwkg5d13khsbk";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0i4h46kv9mj6am57wr27rrinimzggmjhy48p1d6bh63xsn9wz9l9";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0rsf50bidahylyjc6fcqg14k9q40xqq3ws4njpq6b3qvmnbjym1r";
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
