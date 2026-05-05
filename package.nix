{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.35";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "14wpn39c7lkdawjy0334aiwa382p15jflhw1i2a0xykn13603j19";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1hnzmh9jmlvkz54mm8a2k19z11jzvbjqczg9kbsjsfdj0l4y5c54";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0m66szxxzs81pz4kz5ssicrfqyad4i1fmivbdkw78a2qk29jy6dz";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0n3wh8pa9xhym1999v5cqdkwx0bnizj1jfypka07b7l43nahilk5";
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
