{
  jdk17,
  makeWrapper,
  maven,
  nix-gitignore,
  pomXml,
  pname,
  version,
}: let
  name = "${pname}-${version}";
  src = nix-gitignore.gitignoreSource ["*.nix"] ./.;
in
  maven.buildMavenPackage rec {
    inherit pname name src version;

    preConfigure = ''
      # copy the updated pom file with the configuration defined by the flake
      cp ${pomXml} pom.xml
    '';

    mvnHash = "sha256-4RWhvMHAYI4QhLhXssCv+62XP5v4oxftFlJSXBjUK7g=";

    nativeBuildInputs = [jdk17 maven makeWrapper];

    installPhase = ''
      # create the bin directory
      mkdir -p $out/bin

      # create a symbolic link for the lib directory
      ln -s $fetchedMavenDeps/.m2 $out/lib

      # copy out the JAR
      # Maven already setup the classpath to use m2 repository layout
      # with the prefix of lib/
      cp target/${name}.jar $out/

      # create a wrapper that will automatically set the classpath
      # this should be the paths from the dependency derivation
      makeWrapper ${jdk17}/bin/java $out/bin/${pname} \
              --add-flags "-jar $out/${name}.jar"
    '';
  }
