{
  description = "A collection of flake templates";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {...}: {
    templates = {
      stm32-rs = {
        path = ./stm32-rs;
        description = "stm32 Rust dev environment";
      };

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
