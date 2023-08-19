{
  description = "A collection of flake templates";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: {
    templates = {

      stm32-c = {
        path = ./stm32-c;
        description = "stm32 C dev environment";
      };

      java = {
        path = ./java;
        description = "Java dev environment";
      };

    };
  };
}
