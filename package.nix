{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.7";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0pkr7acdrgma3nqh38hpc9fxasiskrj4h3h9r1x1mqlmls8xcrrc";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "05jlwqza0hzyjaxlvsqmjp3q4wff39l6wksmi0kwyiw6mfs5qlkn";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1v9rvg581wbm6khhxw2xhsby5vqhbc4hmn9383ajpvi8x24893bi";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1vxv258g5a7gknb14qgqk9ar2say823y91vhsw7f474dq94aiqgg";
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
