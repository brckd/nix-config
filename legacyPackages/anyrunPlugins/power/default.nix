{pkgs, ...}: let
  inherit (pkgs) glib makeWrapper rustPlatform atk gtk3 gtk-layer-shell pkg-config librsvg cargo rustc;

  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
  pname = cargoToml.package.name;
  inherit (cargoToml.package) version;
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = ./.;

    cargoLock = {
      lockFile = ./Cargo.lock;
      # Temporary while packages aren't yet stabilized
      allowBuiltinFetchGit = true;
    };

    strictDeps = true;

    nativeBuildInputs = [
      pkg-config
      makeWrapper
    ];

    buildInputs = [
      glib
      atk
      gtk3
      librsvg
      gtk-layer-shell
    ];

    doCheck = true;
    checkInputs = [
      cargo
      rustc
    ];

    copyLibs = true;

    # CARGO_BUILD_INCREMENTAL = "false";
    RUST_BACKTRACE = "full";
  }
