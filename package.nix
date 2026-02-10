{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.54";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1zmpljm3y4zn90ihigdyck3yxk9ilzvk595w4j6znyvr1mbbnqjq";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0n548yincasxiszj6hsp2bpl37wi9fb6m8ixcl7gaahv5dn8i1wa";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "11wycpcyjw06h0asq2yxn06m5a746vgsw269cgysprjrn1mhyimh";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0mbysxm5q653lv0yqn6pc2yrv70h7w82b1ymj3jhqazqvg9zx1fs";
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
