{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.24";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "16bjagmc04dx85d3g71w630z65msccq0222344lysygqgvx3q30k";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0my0wgfvbq7clq0v5v280yydkr67fszxhqqj8li0qkivq2bsfiin";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0dr86qslaxj95kkid7mn4s98h43h4v94jqnxibk43lk4nmslv026";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "06m76g99spdv19kq41hbdylsvvkpxdkbcadgz0jbp83fr3krzywg";
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
