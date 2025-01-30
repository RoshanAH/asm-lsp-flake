{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}: let
  src = fetchFromGitHub {
    repo = "asm-lsp";
    owner = "bergercookie";
    rev = "b74fc0f96c852b6721f90a50482819a00b0bc695";
    hash = "sha256-0Vh2EQrJqGltqdM6q5hGaS36Oyy1V531tXX242rLfsA=";
  };
  workspaceManifest = (lib.importTOML "${src}/Cargo.toml").workspace.package;
  manifest = (lib.importTOML "${src}/asm-lsp/Cargo.toml").package;
in rustPlatform.buildRustPackage {
    inherit src;
    inherit (workspaceManifest) version;
    pname = manifest.name;
    cargoLock.lockFile = "${src}/Cargo.lock";

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      openssl
    ];

    # tests expect ~/.cache/asm-lsp to be writable
    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    meta = {
      description = "Language server for NASM/GAS/GO Assembly";
      homepage = "https://github.com/bergercookie/asm-lsp";
      license = lib.licenses.bsd2;
      maintainers = with lib.maintainers; [
        NotAShelf
        CaiqueFigueiredo
      ];
      mainProgram = "asm-lsp";
      platforms = lib.platforms.unix;
    };
}
