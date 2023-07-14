{
  description = "A collection of flake templates";

  inputs = {
    nix-vital.url = "github:nixvital/flake-templates";
    ml-pkgs.url = "github:katanallama/ml-pkgs";
  };

  outputs = { self, nixpkgs, nix-vital, ... }@inputs: {
    templates = {

      python = {
        path = ./python;
        description = "Python dev environment";
      };

      poetry = {
        path = ./poetry;
        description = "Python dev environment with Poetry";
      };

      tensorflow = {
        path = ./tensorflow;
        description = "Tensorflow dev environment";
      };

      torch = {
        path = ./torch;
        description = "Torch dev environment";
      };

      langchain = {
        path = ./langchain;
        description = "Langchain dev environment";
      };

      stm32 = {
        path = ./stm32;
        description = "stm32 dev environment";
      };

      java = {
        path = ./templates/java;
        description = "Java dev environment";
      };

    } // nix-vital.templates;
  };
}
