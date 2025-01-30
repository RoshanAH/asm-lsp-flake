{
  description = "flake to package asm-lsp";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: rec {
        packages.default = pkgs.callPackage ./package.nix {};

        apps.default = {
          type = "app";
          program = packages.default;
        };
      };
      flake = { };
    };
}
