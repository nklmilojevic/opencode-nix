{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.11";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0p3z5vi6xbw71p4bam739g4zjxwc9abrykcm40ipyzwdp1md4yyz";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1p0c0wcysz4i430biby9yhb1vs97p0cpack7a24g50a14srsz62d";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "015xzl5aw7fkmzlxzkxik94jazwipj054wzr7k66wb97ajf93a90";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1f7qw5c2plr5jvqgsz1hxvyxhlfd4igdbv97bb7vigwbpraavhfm";
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
