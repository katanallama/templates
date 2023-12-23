{
  description = "A Nix flake for building a rust project targeting stm32";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    nixpkgs,
    rust-overlay,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [rust-overlay.overlays.default];
    };
    rustChannel = "nightly";
    rustEnvironment = let
      rust-bin-pkg = pkgs.rust-bin.${rustChannel}.latest;
    in
      with pkgs;
        mkShell {
          packages = [
            (rust-bin-pkg.default.override {
              extensions = [
                "llvm-tools-preview"
                "rust-src"
                "rustfmt"
              ];
              targets = [
                "thumbv7m-none-eabi"
              ];
            })

            gdb
            openocd
            probe-rs
            pkg-config
            rust-analyzer-unwrapped
          ];

          RUST_SRC_PATH = "${rust-bin-pkg.rust-src}/lib/rustlib/src/rust/library";
          RUST_BACKTRACE = "full";
          shellHook = ''
            export PATH=$PATH:${buildCommand}/bin:${flashCommand}/bin:${debugCommand}/bin:${ocdCommand}/bin:${gdbCommand}/bin
          '';
        };

    # --features will override the default in Cargo.toml
    buildCommand = pkgs.writeShellScriptBin "build103" ''
      cargo clean
      cargo build --features f103
    '';

    # rust-stm32 corresponds to the package name in Cargo.toml
    flashCommand = pkgs.writeShellScriptBin "flash103" ''
      cargo clean
      cargo flash --chip STM32F103RB --elf target/thumbv7m-none-eabi/debug/rust-stm32
    '';

    # run the real time debugger
    debugCommand = pkgs.writeShellScriptBin "debug103" ''
      cargo clean
      cargo embed with_rtt
    '';

    # openOCD and gdb are both blocking, run each in their own terminal
    # openocd -f openocd/ocd_stlv2_stm32f1.cfg -l .openocd/openocd.log
    ocdCommand = pkgs.writeShellScriptBin "ocd103" ''
      openocd -f openocd/ocd_stlv2_stm32f1.cfg
    '';

    # rust-stm32 corresponds to the package name in Cargo.toml
    gdbCommand = pkgs.writeShellScriptBin "gdb103" ''
      gdb -ex "target extended-remote localhost:3333" \
          -ex "file target/thumbv7m-none-eabi/debug/rust-stm32" \
          -ex load \
          -ex "info registers" \
          # -ex continue \
          # -ex "monitor arm semihosting enable" \
          # -ex continue
    '';
  in {
    packages.${system} = {
      default = rustEnvironment;
      buildRustStm32 = buildCommand;
      flashRustStm32 = flashCommand;
      debugRustStm32 = debugCommand;
      ocdRustStm32 = ocdCommand;
      gdbRustStm32 = gdbCommand;
    };
  };
}
