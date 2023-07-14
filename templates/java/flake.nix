{
  description = "A Nix flake for building a Java project with a minimally managed pom.xml";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # Set your project name, version, groupid, artifactid
    # as these will be updated in your pom automatically here
    pname = "projectName";
    version = "0.1";
    groupId = "com";
    artifactId = pname;
    mainClass = "${groupId}.${pname}.Project";

    # Update pom.xml
    pomTemplate = builtins.readFile ./pom.xml;
    replacedPomContent =
      builtins.replaceStrings
      ["GROUPID" "ARTIFACTID" "VERSION" "MAINCLASS"]
      [groupId artifactId version mainClass]
      pomTemplate;
    pomXml = pkgs.writeText "pom.xml" replacedPomContent;
  in {
    overlays = {
      default = final: _: removeAttrs self.packages.${final.system} ["default"];
    };

    packages.${system} = {
      ${pname} = pkgs.callPackage ./. {inherit pname version pomXml;};
      jdt-language-server = pkgs.callPackage ./jdt-language-server.nix {};
      default = self.packages.${system}.${pname};
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = [
        pkgs.jdk17
        self.packages.${system}.jdt-language-server
      ];
      inputsFrom = [
        self.packages.${system}.${pname}
      ];
      JAVA_HOME = pkgs.jdk17;
      JDTLS_PATH = "${self.packages.${system}.jdt-language-server}/share/java/";
      # If you need a C lib you can do this, don't forget to include it in default.nix
      # LD_LIBRARY_PATH = "${pkgs.xorg.libXxf86vm}/lib/libXxf86vm.so.1";
    };
    formatter.${system} = pkgs.alejandra;
  };
}
