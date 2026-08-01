{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.11";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "10lpm0v6f0s2zd5i4qh6lmkgzrg0xdix4bj9rvhg3vyryby9fj86";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "12qqml6qkwaawg0kcrzkan42z42xm2hii3rh31qr63ng1jlgnvh4";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1fpfzap4qvwxhhzc59h861axdxczr290pv7ypi6fqls304wjjnz5";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1b6gibfh251l2g2ykwsbvh6a3nyaa8apd4bb0b70l25cn94kfxs8";
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
