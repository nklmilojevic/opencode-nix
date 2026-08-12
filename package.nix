{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.17";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0wfgnx3s4b07hvyp765nbg55w18gq3cwri5cgpyn38ccd5008ya0";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0nk8w2k7s7bpqlj9z1r1plh8q218w3akmafz3mby87lg7jd52f8s";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1gax6asmz50p2q5in3n69pv71908aqhvjnn5s0gzrk6pkam3vnjq";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1k507dan0jyywrllfz87ij5z18s19r2jw1l8nranm8wzfnxj1ghk";
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
