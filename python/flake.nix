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

        pythonPkgs = customizePkgs pkgs;
      in {
        devShells.default = pythonPkgs.mkShell {
          name = "python";
          buildInputs = with pythonPkgs; [
            ruff
            ruff-lsp
          ];
        };

        packages = {
          default = pythonPkgs.callPackage ./package.nix {};
        };
      };
    });
}
