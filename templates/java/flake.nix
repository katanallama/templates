{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mvn2nix.url = "github:fzakaria/mvn2nix";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, mvn2nix, utils, ... }:
    let
      overlay = final: prev: {
        java-template = final.callPackage ./default.nix { };
        jdtls = final.callPackage ./jdtls.nix { };
      };

      pkgsForSystem = system:
        import nixpkgs {
          overlays = [ mvn2nix.overlay overlay ];
          inherit system;
        };
    in utils.lib.eachSystem utils.lib.defaultSystems (system: rec {
      legacyPackages = pkgsForSystem system;
      packages = utils.lib.flattenTree {
        inherit (legacyPackages) java-template;
      };
      defaultPackage = legacyPackages.java-template;
      devShell = legacyPackages.mkShellNoCC {
        name = "java-template";
        buildInputs = [
          legacyPackages.jdk17
          legacyPackages.maven
          legacyPackages.jdtls
          packages.java-template
        ];
        shellHook = ''
          export JAVA_HOME=${legacyPackages.jdk17}/
          export JDTLS_PATH=${legacyPackages.jdtls}/share/java/
        '';
      };
    });
}
