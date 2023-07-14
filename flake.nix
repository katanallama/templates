{
  description = "A collection of flake templates";

  inputs = {
    nix-vital.url = "github:nixvital/flake-templates";
    ml-pkgs.url = "github:katanallama/ml-pkgs";
  };

  outputs = { self, nixpkgs, nix-vital, ... }@inputs: {
    templates = {

      stm32 = {
        path = ./stm32;
        description = "stm32 dev environment";
      };

      java = {
        path = ./java;
        description = "Java dev environment";
      };

    } // nix-vital.templates;
  };
}
