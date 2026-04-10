{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.3";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1f7daxp5j3igvw6kgwsixqmk7w6l93rjdk46ak2wp4ql59h76zak";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0yv47q5nli143gfzzj2k1128kv92l519s4c3a7kb0iijzjgqd4ci";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "09rfjj0nrhf2s897ygcy01hdnhdizhqjdyb8ghl662mkf1sdw05g";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0lgp9jkwnya5nx1972gwbp6jcfiwnp43630sjnyrvrnbyhb13lj4";
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
