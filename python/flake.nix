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
      systems = [
        "x86_64-linux"
      ];

      perSystem = {
        lib,
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        customizePkgs = pkgs:
          pkgs
          // {
            python3 = pkgs.python311;
            python3Packages = pkgs.python311Packages;
          };
        customPkgs = customizePkgs pkgs;

        commonArgs = {
          pname = "python-template";
          version = "v0.1.0";

          nativeBuildInputs = with customPkgs; [];
          buildInputs = [];
        };
      in {
        devShells.default = customPkgs.mkShell {
          name = "python";
          inputsFrom = builtins.attrValues self.checks;
          buildInputs = [customPkgs.ruff customPkgs.ruff-lsp];
        };

        packages = {
          package = customPkgs.callPackage ./package.nix {};
        };

        formatter = customPkgs.alejandra;
      };
    });
}
