{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.6";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1i30ni4gc34fnxdjv2i41hqxqygnkqhwg7rz8rkma0dvlfvalxxq";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "11xb3bssba6dpa0c187w3nnsq3s1vnjkn5a9axssyzhyz9ljnbry";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "17mlavvgpjz162ks8g48h1irdk09x2ci2ymlvkplq379j72a3qh4";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "183ngqhkrgxm8694sj06rksxayas3d1r5kam70plwl8fg1clzjcl";
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
