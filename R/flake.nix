{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self inputs;} ({withSystem, ...}: {
      systems = ["x86_64-linux"];

      perSystem = {
        lib,
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        mkREnv = pkgList: pkgs.rWrapper.override {packages = pkgList;};

        R = mkREnv (with pkgs.rPackages; [
          languageserver
          lintr
          quarto
          rmarkdown
          tidyverse
        ]);
      in {
        devShells.default = pkgs.mkShellNoCC {
          name = "R";
          buildInputs = [R];
        };
      };
    });
}
