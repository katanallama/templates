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
        pkgs,
        system,
        ...
      }: let
        py3 = pkgs.python311;
        py3Packages = pkgs.python311Packages;

        pyEnv = py3.withPackages (ps:
          with py3Packages; [
            # Add python packages as needed
            # numpy
            # pandas
          ]);
      in {
        devShells.default = pkgs.mkShell {
          name = "Python dev env";
          buildInputs = with pkgs; [
            ruff-lsp
            pyEnv
          ];
        };

        packages = {
          default = py3Packages.callPackage ./package.nix {};
        };
      };
    });
}
